from __future__ import annotations

import base64
import uuid
from typing import Any

from fastapi import FastAPI
from pydantic import BaseModel, Field

from aadhaar_bot.bridge.captcha_solver import solve_captcha_image
from aadhaar_bot.bridge.session_store import SessionStore
from aadhaar_bot.bridge.uidai_http import UidaiHttpError, UidaiMyAadhaarHttp

store = SessionStore()
uidai = UidaiMyAadhaarHttp()

app = FastAPI(title="UIDAI MyAadhaar bridge", version="1.0")


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


def _txn_id() -> str:
    return f"MYAADHAAR:{uuid.uuid4()}"


def _uidai_success(data: dict[str, Any]) -> bool:
    if not data:
        return False
    for key in ("ok", "success", "status"):
        val = data.get(key)
        if isinstance(val, bool):
            return val
        if isinstance(val, str) and val.lower() in ("success", "ok", "200"):
            return True
    code = data.get("statusCode") or data.get("code")
    if code in (200, "200", 0, "0"):
        return True
    err = str(data.get("message") or data.get("errorMessage") or "").lower()
    if err and any(x in err for x in ("invalid", "not found", "no record", "fail")):
        return False
    return bool(data.get("txnId") or data.get("transactionId"))


def _fail_message(data: dict[str, Any]) -> str:
    return str(
        data.get("message")
        or data.get("errorMessage")
        or data.get("statusMessage")
        or "UIDAI ne record reject kiya — mobile/name match nahi."
    )


async def _prepare_captcha() -> tuple[str, str, str]:
    cap = await uidai.fetch_captcha()
    txn = cap.get("captchaTxnId") or cap.get("txnId") or ""
    b64 = cap.get("captchaBase64String") or cap.get("captchaImage") or ""
    if not txn or not b64:
        raise UidaiHttpError(f"Captcha response incomplete: {str(cap)[:120]}")
    solved = solve_captcha_image(b64)
    return txn, solved, _txn_id()


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok", "provider": "uidai_myaadhaar"}


@app.post("/v1/lookup/verify")
async def verify(body: LookupBody) -> dict[str, Any]:
    name = body.holder_name or body.name
    try:
        captcha_txn, captcha_val, transaction_id = await _prepare_captcha()
        data = await uidai.verify_mobile_name(
            mobile=body.mobile,
            name=name,
            gender=body.gender,
            captcha_txn_id=captcha_txn,
            captcha_value=captcha_val,
            transaction_id=transaction_id,
        )
    except UidaiHttpError as e:
        return {"ok": False, "message": str(e)}
    except Exception as e:
        return {"ok": False, "message": f"UIDAI connect fail (India VPS?): {e}"}

    if not _uidai_success(data):
        return {"ok": False, "message": _fail_message(data)}

    sid = store.create(
        mobile=body.mobile,
        name=name,
        gender=body.gender,
        captcha_txn_id=captcha_txn,
        captcha_value=captcha_val,
        transaction_id=transaction_id,
        uidai_payload=data,
    )
    return {"ok": True, "message": "Record found on UIDAI", "session_id": sid}


@app.post("/v1/lookup/start")
async def start(body: LookupBody) -> dict[str, Any]:
    sess = store.get(body.session_id) if body.session_id else None
    if not sess:
        v = await verify(body)
        if not v.get("ok"):
            return v
        body.session_id = str(v.get("session_id", ""))
        sess = store.get(body.session_id)
    assert sess is not None
    try:
        data = await uidai.send_download_otp(
            mobile=sess.mobile,
            name=sess.name,
            gender=sess.gender,
            captcha_txn_id=sess.captcha_txn_id,
            captcha_value=sess.captcha_value,
            transaction_id=sess.transaction_id,
            otp_stage=1,
        )
    except Exception as e:
        return {"ok": False, "message": str(e)}
    if not _uidai_success(data):
        return {"ok": False, "message": _fail_message(data)}
    sess.otp1_txn = str(data.get("txnId") or data.get("transactionId") or "")
    sess.uidai_payload.update(data)
    return {"ok": True, "message": "OTP 1 sent", "session_id": body.session_id}


@app.post("/v1/lookup/otp1")
async def otp1(body: OtpBody) -> dict[str, Any]:
    sess = store.get(body.session_id)
    if not sess:
        return {"ok": False, "message": "Session expire — dubara shuru karo"}
    try:
        data = await uidai.validate_otp_and_download(
            session_payload={
                "mobileNumber": sess.mobile,
                "fullName": sess.name,
                "transactionId": sess.transaction_id,
                "txnId": sess.otp1_txn,
            },
            otp=body.otp,
            otp_stage=1,
        )
    except Exception as e:
        return {"ok": False, "message": str(e)}
    if not _uidai_success(data):
        return {"ok": False, "message": _fail_message(data)}
    sess.uidai_payload.update(data)
    try:
        otp2 = await uidai.send_download_otp(
            mobile=sess.mobile,
            name=sess.name,
            gender=sess.gender,
            captcha_txn_id=sess.captcha_txn_id,
            captcha_value=sess.captcha_value,
            transaction_id=sess.transaction_id,
            otp_stage=2,
        )
        sess.uidai_payload.update(otp2)
    except Exception as e:
        return {"ok": False, "message": f"OTP2 send fail: {e}"}
    return {"ok": True, "message": "OTP 2 sent", "session_id": body.session_id}


@app.post("/v1/lookup/otp2")
async def otp2(body: OtpBody) -> dict[str, Any]:
    sess = store.get(body.session_id)
    if not sess:
        return {"ok": False, "message": "Session expire"}
    try:
        data = await uidai.validate_otp_and_download(
            session_payload={
                "mobileNumber": sess.mobile,
                "fullName": sess.name,
                "transactionId": sess.transaction_id,
            },
            otp=body.otp,
            otp_stage=2,
        )
        pdf = await uidai.download_pdf(
            session_payload={
                "mobileNumber": sess.mobile,
                "fullName": sess.name,
                "transactionId": sess.transaction_id,
            },
            otp=body.otp,
        )
    except Exception as e:
        return {"ok": False, "message": str(e)}

    masked = str(data.get("aadhaarNumber") or data.get("maskedAadhaar") or "XXXX XXXX XXXX")
    return {
        "ok": True,
        "message": "Done",
        "aadhaar_masked": masked,
        "name": sess.name.title(),
        "numeric_id": str(data.get("referenceId") or data.get("refId") or ""),
        "pdf_password": str(data.get("pdfPasswordHint") or ""),
        "phone": sess.mobile,
        "pdf_base64": base64.b64encode(pdf).decode(),
    }
