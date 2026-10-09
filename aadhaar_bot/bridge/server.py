from __future__ import annotations

import asyncio
import base64
import uuid
from typing import Any

from fastapi import FastAPI
from pydantic import BaseModel

from aadhaar_bot.bridge.captcha_solver import solve_captcha_image
from aadhaar_bot.bridge.retrieve_parse import (
    extract_pdf_bytes,
    extract_reference_id,
    extract_uid_digits,
    extract_uid_masked,
    is_no_record,
    otp_sent_ok,
    uid_retrieved_ok,
)
from aadhaar_bot.name_utils import uidai_name_candidates
from aadhaar_bot.pdf_password import pdf_password_hint
from aadhaar_bot.bridge.session_store import SessionStore
from aadhaar_bot.bridge.uidai_http import UidaiHttpError, UidaiMyAadhaarHttp

store = SessionStore()
uidai = UidaiMyAadhaarHttp()

app = FastAPI(title="UIDAI retrieveuideid bridge", version="2.0")


class LookupBody(BaseModel):
    mobile: str
    gender: str = "unspecified"
    holder_name: str = ""
    name: str = ""
    fetch_by_name: bool = True
    manual_name: bool = False
    skip_dob: bool = True
    session_id: str = ""


class OtpBody(BaseModel):
    session_id: str
    otp: str


async def _prepare_captcha() -> tuple[str, str]:
    cap = await uidai.fetch_captcha()
    txn = cap.get("captchaTxnId") or cap.get("txnId") or ""
    b64 = cap.get("captchaBase64String") or cap.get("captchaImage") or ""
    if not txn or not b64:
        raise UidaiHttpError(f"Captcha incomplete: {str(cap)[:120]}")
    solved = await asyncio.to_thread(solve_captcha_image, b64)
    return txn, solved


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok", "api": "retrieveuideid"}


async def _verify_uidai_name(
    mobile: str,
    name: str,
) -> tuple[dict[str, Any] | None, str, str, str, str, str]:
    """Returns (uidai_data, matched_name, captcha_txn, captcha_val, otp_txn) or Nones."""
    last_err = "No Records Found"
    for attempt in range(3):
        try:
            captcha_txn, captcha_val = await _prepare_captcha()
            otp_txn = UidaiMyAadhaarHttp.new_otp_txn_id()
            data = await uidai.retrieve_uid_eid(
                mobile=mobile,
                name=name,
                captcha_txn_id=captcha_txn,
                otp_txn_id=otp_txn,
                otp=None,
                captcha=None,
                dob=None,
                resend_otp=False,
            )
        except UidaiHttpError as e:
            last_err = str(e)
            if attempt < 2 and "captcha" in last_err.lower():
                continue
            raise UidaiHttpError(last_err) from e
        except Exception as e:
            raise UidaiHttpError(f"UIDAI connect fail (India VPS?): {e}") from e

        if is_no_record(data):
            return None, name, captcha_txn, captcha_val, otp_txn, last_err
        if otp_sent_ok(data):
            return data, name, captcha_txn, captcha_val, otp_txn, ""
        last_err = str(data.get("message") or data.get("statusMessage") or "OTP not sent")
        if attempt < 2:
            continue
        return None, name, captcha_txn, captcha_val, otp_txn, last_err
    return None, name, "", "", "", last_err


@app.post("/v1/lookup/verify")
async def verify(body: LookupBody) -> dict[str, Any]:
    """UIDAI record check — OTP request (otp=null, captcha=null)."""
    input_name = (body.holder_name or body.name or "").strip()
    if len(input_name) < 2:
        return {"ok": False, "message": "Name required"}

    matched: dict[str, Any] | None = None
    matched_name = ""
    captcha_txn = captcha_val = otp_txn = ""
    last_err = "No Records Found"

    for candidate in uidai_name_candidates(input_name):
        try:
            data, used_name, captcha_txn, captcha_val, otp_txn, err = await _verify_uidai_name(
                body.mobile, candidate
            )
        except UidaiHttpError as e:
            return {"ok": False, "message": str(e)}

        if data is not None:
            matched = data
            matched_name = used_name
            break
        last_err = err or last_err

    if not matched:
        return {"ok": False, "message": "No Records Found", "tried_names": uidai_name_candidates(input_name)}

    sid = store.create(
        mobile=body.mobile,
        name=matched_name,
        gender=body.gender,
        captcha_txn_id=captcha_txn,
        captcha_value=captcha_val,
        otp_txn_id=otp_txn,
        uidai_payload=matched,
        otp_stage=1,
    )
    return {
        "ok": True,
        "message": "Record found",
        "session_id": sid,
        "name": matched_name,
        "matched_name": matched_name,
    }


@app.post("/v1/lookup/start")
async def start(body: LookupBody) -> dict[str, Any]:
    sess = store.get(body.session_id) if body.session_id else None
    if not sess:
        return await verify(body)
    return {"ok": True, "message": "OTP 1 sent", "session_id": body.session_id}


@app.post("/v1/lookup/otp1")
async def otp1(body: OtpBody) -> dict[str, Any]:
    sess = store.get(body.session_id)
    if not sess:
        return {"ok": False, "message": "Session expire"}
    try:
        data = await uidai.retrieve_uid_eid(
            mobile=sess.mobile,
            name=sess.name,
            captcha_txn_id=sess.captcha_txn_id,
            otp_txn_id=sess.otp_txn_id,
            otp=body.otp.strip(),
            captcha=sess.captcha_value,
            dob=None,
            resend_otp=False,
        )
    except Exception as e:
        return {"ok": False, "message": str(e)}

    if is_no_record(data):
        return {"ok": False, "message": "No Records Found"}

    sess.uidai_payload.update(data)

    if uid_retrieved_ok(data) and sess.otp_stage == 1:
        try:
            resend = await uidai.retrieve_uid_eid(
                mobile=sess.mobile,
                name=sess.name,
                captcha_txn_id=sess.captcha_txn_id,
                otp_txn_id=sess.otp_txn_id,
                otp=None,
                captcha=None,
                dob=None,
                resend_otp=True,
            )
            sess.uidai_payload.update(resend)
            sess.otp_stage = 2
        except Exception:
            pass
        return {"ok": True, "message": "OTP 2 sent", "session_id": body.session_id}

    if otp_sent_ok(data):
        return {"ok": True, "message": "OTP 2 sent", "session_id": body.session_id}

    return {"ok": False, "message": "Galat OTP 1"}


@app.post("/v1/lookup/otp2")
async def otp2(body: OtpBody) -> dict[str, Any]:
    sess = store.get(body.session_id)
    if not sess:
        return {"ok": False, "message": "Session expire"}
    try:
        data = await uidai.retrieve_uid_eid(
            mobile=sess.mobile,
            name=sess.name,
            captcha_txn_id=sess.captcha_txn_id,
            otp_txn_id=sess.otp_txn_id,
            otp=body.otp.strip(),
            captcha=sess.captcha_value,
            dob=None,
            resend_otp=False,
        )
    except Exception as e:
        return {"ok": False, "message": str(e)}

    if is_no_record(data) or not uid_retrieved_ok(data):
        return {"ok": False, "message": "Galat OTP 2"}

    masked = extract_uid_masked(data)
    ref = extract_reference_id(data)
    pwd_hint = pdf_password_hint(sess.name, data)

    pdf_bytes = extract_pdf_bytes(data)
    if not pdf_bytes:
        uid = extract_uid_digits(data)
        if uid:
            try:
                pdf_bytes = await uidai.download_eaadhaar_pdf(
                    uid=uid,
                    mobile=sess.mobile,
                    name=sess.name,
                    otp=body.otp.strip(),
                    captcha_txn_id=sess.captcha_txn_id,
                    captcha=sess.captcha_value,
                    otp_txn_id=sess.otp_txn_id,
                )
            except Exception:
                pdf_bytes = None

    pdf_b64 = base64.b64encode(pdf_bytes).decode() if pdf_bytes else ""

    return {
        "ok": True,
        "message": "Done",
        "aadhaar_masked": masked,
        "name": sess.name,
        "numeric_id": ref,
        "pdf_password": pwd_hint,
        "phone": sess.mobile,
        "pdf_base64": pdf_b64,
        "raw": data,
    }
