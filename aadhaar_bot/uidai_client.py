from __future__ import annotations

import secrets
from dataclasses import dataclass
from typing import Any

import httpx

from aadhaar_bot.config import get_settings


@dataclass
class LookupResult:
    ok: bool
    message: str
    session_id: str = ""
    aadhaar_masked: str = ""
    name: str = ""
    numeric_id: str = ""
    pdf_password_hint: str = ""
    phone: str = ""
    pdf_bytes: bytes | None = None
    raw: dict[str, Any] | None = None


class UidaiBackend:
    """Talks to YOUR UIDAI bridge (captcha auto + no DOB) — not uidai.gov.in directly."""

    def __init__(self) -> None:
        self.settings = get_settings()
        self._mock_sessions: dict[str, dict] = {}

    def _headers(self) -> dict[str, str]:
        h = {"Content-Type": "application/json"}
        if self.settings.aadhaar_backend_key:
            h["Authorization"] = f"Bearer {self.settings.aadhaar_backend_key}"
        return h

    async def start_lookup(
        self,
        mobile: str,
        gender: str,
        name_display: str,
        name_query: str,
        *,
        manual_name: bool,
    ) -> LookupResult:
        if self.settings.aadhaar_mock_mode or not self.settings.aadhaar_backend_url:
            sid = secrets.token_hex(8)
            self._mock_sessions[sid] = {
                "mobile": mobile,
                "gender": gender,
                "name": name_display,
                "name_query": name_query,
                "manual_name": manual_name,
                "otp1": "541679",
                "otp2": "670299",
            }
            return LookupResult(
                ok=True,
                message="OTP 1 sent (mock)",
                session_id=sid,
                phone=mobile,
            )
        url = self.settings.aadhaar_backend_url.rstrip("/") + "/v1/lookup/start"
        payload = {
            "mobile": mobile,
            "gender": gender,
            "holder_name": name_display,
            "name": name_query,
            "fetch_by_name": True,
            "manual_name": manual_name,
            "skip_dob": True,
        }
        async with httpx.AsyncClient(timeout=120.0) as client:
            r = await client.post(url, json=payload, headers=self._headers())
            r.raise_for_status()
            data = r.json()
        return LookupResult(
            ok=bool(data.get("ok", True)),
            message=str(data.get("message", "OTP 1 sent")),
            session_id=str(data.get("session_id", "")),
            phone=mobile,
            raw=data,
        )

    async def submit_otp1(self, session_id: str, otp: str) -> LookupResult:
        if self.settings.aadhaar_mock_mode or not self.settings.aadhaar_backend_url:
            s = self._mock_sessions.get(session_id)
            if not s or otp.strip() != s["otp1"]:
                return LookupResult(ok=False, message="Galat OTP 1")
            return LookupResult(ok=True, message="OTP 2 sent (mock)", session_id=session_id, phone=s["mobile"])

        url = self.settings.aadhaar_backend_url.rstrip("/") + "/v1/lookup/otp1"
        async with httpx.AsyncClient(timeout=120.0) as client:
            r = await client.post(
                url, json={"session_id": session_id, "otp": otp}, headers=self._headers()
            )
            r.raise_for_status()
            data = r.json()
        return LookupResult(
            ok=bool(data.get("ok", True)),
            message=str(data.get("message", "OTP 2 sent")),
            session_id=session_id,
            raw=data,
        )

    async def submit_otp2(self, session_id: str, otp: str) -> LookupResult:
        if self.settings.aadhaar_mock_mode or not self.settings.aadhaar_backend_url:
            s = self._mock_sessions.get(session_id)
            if not s or otp.strip() != s["otp2"]:
                return LookupResult(ok=False, message="Galat OTP 2")
            name = s["name"]
            return LookupResult(
                ok=True,
                message="Extraction complete (mock)",
                session_id=session_id,
                aadhaar_masked="9815 7689 9641",
                name=name,
                numeric_id="0231191050808620260509095954",
                pdf_password_hint=name[:4].upper() + "2003",
                phone=s["mobile"],
                pdf_bytes=b"%PDF-1.4 mock aadhaar export\n",
                raw={"mock": True},
            )

        url = self.settings.aadhaar_backend_url.rstrip("/") + "/v1/lookup/otp2"
        async with httpx.AsyncClient(timeout=180.0) as client:
            r = await client.post(
                url, json={"session_id": session_id, "otp": otp}, headers=self._headers()
            )
            r.raise_for_status()
            data = r.json()
        pdf_b = None
        if data.get("pdf_base64"):
            import base64

            pdf_b = base64.b64decode(data["pdf_base64"])
        return LookupResult(
            ok=bool(data.get("ok", True)),
            message=str(data.get("message", "Done")),
            session_id=session_id,
            aadhaar_masked=str(data.get("aadhaar_masked", "")),
            name=str(data.get("name", "")),
            numeric_id=str(data.get("numeric_id", "")),
            pdf_password_hint=str(data.get("pdf_password", "")),
            phone=str(data.get("phone", "")),
            pdf_bytes=pdf_b,
            raw=data,
        )
