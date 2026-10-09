from __future__ import annotations

import base64
from typing import Any


def _msg(data: dict[str, Any]) -> str:
    return str(
        data.get("message")
        or data.get("errorMessage")
        or data.get("statusMessage")
        or data.get("responseMessage")
        or ""
    )


def is_no_record(data: dict[str, Any]) -> bool:
    m = _msg(data).lower()
    if any(
        x in m
        for x in (
            "no record",
            "not found",
            "does not exist",
            "invalid",
            "mismatch",
            "fail",
            "error",
        )
    ):
        return True
    code = data.get("statusCode") or data.get("code")
    if code not in (None, 200, "200", 0, "0", "SUCCESS", "Success"):
        if code in (404, "404", 400, "400", 500, "500"):
            return True
    return False


def otp_sent_ok(data: dict[str, Any]) -> bool:
    if is_no_record(data):
        return False
    m = _msg(data).lower()
    if "otp" in m and any(x in m for x in ("sent", "success", "generated")):
        return True
    st = str(data.get("status") or data.get("responseStatus") or "").lower()
    if st in ("success", "y", "ok"):
        return True
    if data.get("statusCode") in (200, "200"):
        if data.get("uid") or data.get("aadhaarNumber"):
            return False
        return True
    return bool(data.get("otpTxnId"))


def uid_retrieved_ok(data: dict[str, Any]) -> bool:
    if is_no_record(data):
        return False
    if data.get("uid") or data.get("aadhaarNumber") or data.get("aadhaar"):
        return True
    m = _msg(data).lower()
    return "success" in m and "otp" not in m


def extract_uid_masked(data: dict[str, Any]) -> str:
    raw = str(
        data.get("uid")
        or data.get("aadhaarNumber")
        or data.get("aadhaar")
        or data.get("maskedAadhaar")
        or ""
    )
    digits = "".join(c for c in raw if c.isdigit())
    if len(digits) >= 12:
        d = digits[-12:]
        return f"{d[0:4]} {d[4:8]} {d[8:12]}"
    return raw or "XXXX XXXX XXXX"


def extract_reference_id(data: dict[str, Any]) -> str:
    return str(
        data.get("referenceId")
        or data.get("refId")
        or data.get("eid")
        or data.get("enrolmentId")
        or data.get("enrollmentId")
        or data.get("numericId")
        or ""
    )


def extract_uid_digits(data: dict[str, Any]) -> str:
    raw = str(
        data.get("uid")
        or data.get("aadhaarNumber")
        or data.get("aadhaar")
        or data.get("uidNumber")
        or ""
    )
    digits = "".join(c for c in raw if c.isdigit())
    if len(digits) >= 12:
        return digits[-12:]
    return digits


def extract_pdf_bytes(data: dict[str, Any]) -> bytes | None:
    for key in (
        "pdfBase64",
        "eAadhaarPdfBase64",
        "eaadhaarPdf",
        "pdf",
        "fileBase64",
        "aadhaarPdf",
    ):
        val = data.get(key)
        if isinstance(val, str) and len(val) > 100:
            try:
                raw = base64.b64decode(val)
                if raw[:4] == b"%PDF":
                    return raw
            except Exception:
                continue
    nested = data.get("responseData") or data.get("data") or data.get("result")
    if isinstance(nested, dict):
        return extract_pdf_bytes(nested)
    return None
