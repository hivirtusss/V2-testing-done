from __future__ import annotations

import base64
import uuid
from typing import Any

from fastapi import FastAPI
from pydantic import BaseModel

from aadhaar_bot.bridge.captcha_solver import solve_captcha_image
from aadhaar_bot.bridge.retrieve_parse import (
    extract_reference_id,
    extract_uid_masked,
    is_no_record,
    otp_sent_ok,
    uid_retrieved_ok,
)
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
    dob: str | None = None
    fetch_by_name: bool = True
    manual_name: bool = False
    skip_dob: bool = True
    session_id: str = ""


class OtpBody(BaseModel):
    session_id: str
    otp: str


def _dob(body: LookupBody) -> str | None:
    if body.skip_dob and not body.dob:
        return None
    return body.dob


async def _prepare_captcha() -> tuple[str, str]:
    cap = await uidai.fetch_captcha()
    txn = cap.get("captchaTxnId") or cap.get("txnId") or ""
    b64 = cap.get("captchaBase64String") or cap.get("captchaImage") or ""
    if not txn or not b64:
        raise UidaiHttpError(f"Captcha incomplete: {str(cap)[:120]}")
    solved = solve_captcha_image(b64)
    return txn, solved


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok", "api": "retrieveuideid"}


@app.post("/v1/lookup/verify")
async def verify(body: LookupBody) -> dict[str, Any]:
    """UIDAI record check — OTP request (otp=null, captcha=null)."""
    name = body.holder_name or body.name
    try:
        captcha_txn, captcha_val = await _prepare_captcha()
        otp_txn = UidaiMyAadhaarHttp.new_otp_txn_id()
        data = await uidai.retrieve_uid_eid(
            mobile=body.mobile,
            name=name,
            captcha_txn_id=captcha_txn,
            otp_txn_id=otp_txn,
            otp=None,
            captcha=None,
            dob=_dob(body),
            resend_otp=False,
        )
    except UidaiHttpError as e:
        return {"ok": False, "message": str(e)}
    except Exception as e:
        return {"ok": False, "message": f"UIDAI connect fail (India VPS?): {e}"}

    if is_no_record(data) or not otp_sent_ok(data):
        return {"ok": False, "message": "No Records Found"}

    sid = store.create(
        mobile=body.mobile,
        name=name,
        gender=body.gender,
        captcha_txn_id=captcha_txn,
        captcha_value=captcha_val,
        otp_txn_id=otp_txn,
        dob=_dob(body),
        uidai_payload=data,
        otp_stage=1,
    )
    return {"ok": True, "message": "Record found", "session_id": sid}


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
            dob=sess.dob,
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
                dob=sess.dob,
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
            dob=sess.dob,
            resend_otp=False,
        )
    except Exception as e:
        return {"ok": False, "message": str(e)}

    if is_no_record(data) or not uid_retrieved_ok(data):
        return {"ok": False, "message": "Galat OTP 2"}

    masked = extract_uid_masked(data)
    ref = extract_reference_id(data)
    pdf_stub = b"%PDF-1.4\n% UIDAI retrieve OK\n"
    pwd_hint = (sess.name.replace(" ", "")[:4].upper() if sess.name else "AADH") + "2003"

    return {
        "ok": True,
        "message": "Done",
        "aadhaar_masked": masked,
        "name": sess.name,
        "numeric_id": ref,
        "pdf_password": pwd_hint,
        "phone": sess.mobile,
        "pdf_base64": base64.b64encode(pdf_stub).decode(),
        "raw": data,
    }
