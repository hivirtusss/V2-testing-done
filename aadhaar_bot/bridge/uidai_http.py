from __future__ import annotations

import uuid
from typing import Any

import httpx

from aadhaar_bot.config import get_settings


class UidaiHttpError(Exception):
    pass


class UidaiMyAadhaarHttp:
    """UIDAI tathya MyAadhaar — retrieveEidUid / generic retrieveuideid."""

    def __init__(self) -> None:
        self.settings = get_settings()
        self.base = self.settings.uidai_tathya_base.rstrip("/")
        self.timeout = self.settings.uidai_http_timeout
        self.captcha_url = self.settings.uidai_captcha_url or (
            f"{self.base}/unifiedAppAuthService/api/v2/get/captcha"
        )
        self.retrieve_url = self.settings.uidai_retrieve_url or (
            f"{self.base}/retrieveEidUid/ext/v1/generic/retrieveuideid"
        )

    def _headers_myaadhaar(self) -> dict[str, str]:
        return {
            "User-Agent": self.settings.uidai_user_agent,
            "Accept": "application/json, text/plain, */*",
            "Content-Type": "application/json",
            "appID": "MYAADHAAR",
            "X-Request-ID": str(uuid.uuid4()),
            "Accept-Language": "en_IN",
            "Origin": "https://myaadhaar.uidai.gov.in",
            "Referer": "https://myaadhaar.uidai.gov.in/",
        }

    @staticmethod
    def new_otp_txn_id() -> str:
        return f"mAadhaar:{uuid.uuid4()}"

    async def fetch_captcha(self) -> dict[str, Any]:
        payload = {
            "langCode": "en",
            "captchaLength": self.settings.uidai_captcha_length,
            "captchaType": self.settings.uidai_captcha_type,
        }
        async with httpx.AsyncClient(timeout=self.timeout, verify=True) as client:
            r = await client.post(
                self.captcha_url,
                json=payload,
                headers={"Content-Type": "application/json"},
            )
            r.raise_for_status()
            data = r.json()
        if int(data.get("statusCode", 0)) != 200:
            raise UidaiHttpError(f"Captcha fail: {data}")
        return data

    async def retrieve_uid_eid(
        self,
        *,
        mobile: str,
        name: str,
        captcha_txn_id: str,
        otp_txn_id: str,
        otp: str | None = None,
        captcha: str | None = None,
        dob: str | None = None,
        resend_otp: bool = False,
    ) -> dict[str, Any]:
        payload: dict[str, Any] = {
            "mobileNumber": mobile,
            "email": None,
            "dob": dob,
            "name": name,
            "option": "UID",
            "otp": otp,
            "otpTxnId": otp_txn_id,
            "captchaTxnId": captcha_txn_id,
            "captcha": captcha,
            "resendOtp": resend_otp,
        }
        async with httpx.AsyncClient(timeout=self.timeout, verify=True) as client:
            r = await client.post(
                self.retrieve_url,
                content=__import__("json").dumps(payload),
                headers=self._headers_myaadhaar(),
            )
            r.raise_for_status()
            try:
                return r.json()
            except Exception as e:
                raise UidaiHttpError(f"Invalid JSON: {r.text[:300]}") from e
