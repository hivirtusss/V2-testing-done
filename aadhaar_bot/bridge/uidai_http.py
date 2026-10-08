from __future__ import annotations

import uuid
from typing import Any

import httpx

from aadhaar_bot.config import get_settings


class UidaiHttpError(Exception):
    pass


def _gender_code(gender: str) -> str:
    g = (gender or "").lower()
    if g == "female":
        return "F"
    if g == "male":
        return "M"
    return "T"


class UidaiMyAadhaarHttp:
    """HTTP client for UIDAI tathya / myAadhaar services (India network required)."""

    def __init__(self) -> None:
        self.settings = get_settings()
        self.base = self.settings.uidai_tathya_base.rstrip("/")
        self.timeout = self.settings.uidai_http_timeout
        # Override via env if UIDAI changes paths (see README).
        self.captcha_url = self.settings.uidai_captcha_url or (
            f"{self.base}/unifiedAppAuthService/api/v2/get/captcha"
        )
        self.verify_url = self.settings.uidai_verify_mobile_url or (
            f"{self.base}/eAadhaarService/api/v2/otp/verifyDemographicData"
        )
        self.otp1_url = self.settings.uidai_otp1_url or (
            f"{self.base}/eAadhaarService/api/v2/otp/generateOTPForDownload"
        )
        self.otp2_url = self.settings.uidai_otp2_url or self.otp1_url
        self.validate_url = self.settings.uidai_validate_otp_url or (
            f"{self.base}/eAadhaarService/api/v2/otp/validateOTPForDownload"
        )
        self.download_url = self.settings.uidai_download_pdf_url or (
            f"{self.base}/eAadhaarService/api/v2/otp/downloadEAadhaar"
        )

    def _headers_otp(self) -> dict[str, str]:
        return {
            "Content-Type": "application/json",
            "appid": "MYAADHAAR",
            "Accept-Language": "en_in",
            "x-request-id": str(uuid.uuid4()),
        }

    def _headers_portal(self) -> dict[str, str]:
        return {
            "Content-Type": "application/json",
            "appID": "PORTAL",
            "X-Request-ID": str(uuid.uuid4()),
            "transactionId": str(uuid.uuid4()),
        }

    async def fetch_captcha(self) -> dict[str, Any]:
        url = self.captcha_url
        payload = {
            "langCode": "en",
            "captchaLength": self.settings.uidai_captcha_length,
            "captchaType": self.settings.uidai_captcha_type,
        }
        async with httpx.AsyncClient(timeout=self.timeout, verify=True) as client:
            r = await client.post(url, json=payload)
            r.raise_for_status()
            data = r.json()
        if int(data.get("statusCode", 0)) != 200:
            raise UidaiHttpError(f"Captcha fail: {data}")
        return data

    async def verify_mobile_name(
        self,
        *,
        mobile: str,
        name: str,
        gender: str,
        captcha_txn_id: str,
        captcha_value: str,
        transaction_id: str,
    ) -> dict[str, Any]:
        """UIDAI demographic match (mobile + name) before OTP."""
        url = self.verify_url
        payload = {
            "mobileNumber": mobile,
            "fullName": name,
            "name": name,
            "gender": _gender_code(gender),
            "captchaTxnId": captcha_txn_id,
            "captchaValue": captcha_value,
            "transactionId": transaction_id,
            "skipDob": True,
            "langCode": "en",
        }
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            r = await client.post(url, json=payload, headers=self._headers_otp())
            r.raise_for_status()
            return r.json()

    async def send_download_otp(
        self,
        *,
        mobile: str,
        name: str,
        gender: str,
        captcha_txn_id: str,
        captcha_value: str,
        transaction_id: str,
        otp_stage: int = 1,
    ) -> dict[str, Any]:
        url = self.otp1_url if otp_stage == 1 else self.otp2_url
        payload = {
            "mobileNumber": mobile,
            "fullName": name,
            "gender": _gender_code(gender),
            "captchaTxnId": captcha_txn_id,
            "captchaValue": captcha_value,
            "transactionId": transaction_id,
            "otpStage": otp_stage,
            "skipDob": True,
        }
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            r = await client.post(url, json=payload, headers=self._headers_otp())
            r.raise_for_status()
            return r.json()

    async def validate_otp_and_download(
        self,
        *,
        session_payload: dict[str, Any],
        otp: str,
        otp_stage: int,
    ) -> dict[str, Any]:
        url = self.validate_url
        payload = {**session_payload, "otp": otp, "otpStage": otp_stage}
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            r = await client.post(url, json=payload, headers=self._headers_otp())
            r.raise_for_status()
            return r.json()

    async def download_pdf(
        self,
        *,
        session_payload: dict[str, Any],
        otp: str,
    ) -> bytes:
        url = self.download_url
        payload = {**session_payload, "otp": otp, "downloadFormat": "pdf"}
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            r = await client.post(url, json=payload, headers=self._headers_portal())
            r.raise_for_status()
            ctype = r.headers.get("content-type", "")
            if "pdf" in ctype or r.content[:4] == b"%PDF":
                return r.content
            data = r.json()
            import base64

            b64 = data.get("pdfBase64") or data.get("eAadhaarPdf") or data.get("fileBase64")
            if b64:
                return base64.b64decode(b64)
            raise UidaiHttpError(f"Download response missing PDF: {str(data)[:200]}")
