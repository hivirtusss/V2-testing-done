from __future__ import annotations

import secrets
from dataclasses import dataclass
from typing import Any

import httpx

from aadhaar_bot.config import get_settings
from aadhaar_bot.pdf_password import pdf_password_hint

# Demo pair only when no live backend (mock strict mode)
_MOCK_DEMO_MOBILE = "9520728207"
_MOCK_DEMO_NAME = "SHADAB"


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
    """UIDAI / Umang bridge on your server (captcha auto, no DOB)."""

    def __init__(self) -> None:
        self.settings = get_settings()
        self._mock_sessions: dict[str, dict] = {}

    def _live(self) -> bool:
        if self.settings.aadhaar_mock_mode and self.settings.aadhaar_provider.lower() != "uidai":
            return False
        return bool(self.settings.effective_backend_url)

    def _headers(self) -> dict[str, str]:
        h = {"Content-Type": "application/json"}
        if self.settings.aadhaar_backend_key:
            h["Authorization"] = f"Bearer {self.settings.aadhaar_backend_key}"
        return h

    def _http_timeout(self) -> httpx.Timeout:
        t = float(self.settings.aadhaar_verify_timeout)
        return httpx.Timeout(connect=12.0, read=t, write=30.0, pool=12.0)

    async def ping_bridge(self) -> tuple[bool, str]:
        if not self._live():
            return True, "mock"
        url = self.settings.effective_backend_url.rstrip("/") + "/health"
        try:
            async with httpx.AsyncClient(timeout=httpx.Timeout(8.0)) as client:
                r = await client.get(url, headers=self._headers())
                r.raise_for_status()
            return True, "ok"
        except httpx.ConnectError:
            return False, "Bridge tak connect nahi ho paya (process band? galat port?)."
        except Exception as e:
            return False, str(e)

    def _payload_base(
        self,
        mobile: str,
        gender: str,
        name_display: str,
        name_query: str,
        *,
        manual_name: bool,
    ) -> dict[str, Any]:
        return {
            "mobile": mobile,
            "gender": gender,
            "holder_name": name_display,
            "name": name_display,
            "fetch_by_name": True,
            "manual_name": manual_name,
            "skip_dob": True,
            "source": "retrieveuideid",
        }

    def _mock_record_exists(self, mobile: str, name_query: str) -> bool:
        return mobile == _MOCK_DEMO_MOBILE and name_query == _MOCK_DEMO_NAME

    async def verify_record(
        self,
        mobile: str,
        gender: str,
        name_display: str,
        name_query: str,
        *,
        manual_name: bool,
    ) -> LookupResult:
        """Live UIDAI retrieveuideid — record check + OTP trigger (no DOB)."""
        payload = self._payload_base(mobile, gender, name_display, name_query, manual_name=manual_name)

        if self._live():
            url = self.settings.effective_backend_url.rstrip("/") + "/v1/lookup/verify"
            async with httpx.AsyncClient(timeout=self._http_timeout()) as client:
                r = await client.post(url, json=payload, headers=self._headers())
                r.raise_for_status()
                data = r.json()
            if not data.get("ok", False):
                return LookupResult(
                    ok=False,
                    message=str(
                        data.get("message", "Is mobile par is naam se Aadhaar record nahi mila.")
                    ),
                    raw=data,
                )
            return LookupResult(
                ok=True,
                message=str(data.get("message", "Record found")),
                session_id=str(data.get("session_id", "")),
                phone=mobile,
                raw=data,
            )

        if self.settings.aadhaar_mock_mode:
            if self._mock_record_exists(mobile, name_query):
                return LookupResult(ok=True, message="Record found (demo)", phone=mobile)
            return LookupResult(
                ok=False,
                message=(
                    "❌ Is mobile par is naam se **koi Aadhaar nahi mila**.\n\n"
                    "Live UIDAI ke liye `.env.aadhaar` me `AADHAAR_BACKEND_URL` set karo "
                    "(Umang/Aadhaar bridge)."
                ),
            )

        return LookupResult(
            ok=False,
            message="UIDAI bridge configure nahi — owner se `AADHAAR_BACKEND_URL` set karwao.",
        )

    async def start_lookup(
        self,
        mobile: str,
        gender: str,
        name_display: str,
        name_query: str,
        *,
        manual_name: bool,
        preverified_session: str = "",
    ) -> LookupResult:
        payload = self._payload_base(mobile, gender, name_display, name_query, manual_name=manual_name)
        if preverified_session:
            payload["session_id"] = preverified_session

        if self._live():
            url = self.settings.effective_backend_url.rstrip("/") + "/v1/lookup/start"
            async with httpx.AsyncClient(timeout=self._http_timeout()) as client:
                r = await client.post(url, json=payload, headers=self._headers())
                r.raise_for_status()
                data = r.json()
            if not data.get("ok", False):
                return LookupResult(
                    ok=False,
                    message=str(data.get("message", "OTP bhejne me fail")),
                    raw=data,
                )
            return LookupResult(
                ok=True,
                message=str(data.get("message", "OTP 1 sent")),
                session_id=str(data.get("session_id", preverified_session)),
                phone=mobile,
                raw=data,
            )

        if self.settings.aadhaar_mock_mode and self._mock_record_exists(mobile, name_query):
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
                message="OTP 1 sent (demo)",
                session_id=sid,
                phone=mobile,
            )

        return LookupResult(ok=False, message="Record verify fail — OTP nahi bheja.")

    async def submit_otp1(self, session_id: str, otp: str) -> LookupResult:
        if self._live():
            url = self.settings.effective_backend_url.rstrip("/") + "/v1/lookup/otp1"
            async with httpx.AsyncClient(timeout=self._http_timeout()) as client:
                r = await client.post(
                    url, json={"session_id": session_id, "otp": otp}, headers=self._headers()
                )
                r.raise_for_status()
                data = r.json()
            return LookupResult(
                ok=bool(data.get("ok", False)),
                message=str(data.get("message", "OTP 2 sent")),
                session_id=session_id,
                raw=data,
            )

        s = self._mock_sessions.get(session_id)
        if not s or otp.strip() != s["otp1"]:
            return LookupResult(ok=False, message="Galat OTP 1")
        return LookupResult(ok=True, message="OTP 2 sent (demo)", session_id=session_id, phone=s["mobile"])

    async def submit_otp2(self, session_id: str, otp: str) -> LookupResult:
        if self._live():
            url = self.settings.effective_backend_url.rstrip("/") + "/v1/lookup/otp2"
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
            inner = data.get("raw")
            uidai_raw = inner if isinstance(inner, dict) else {}
            return LookupResult(
                ok=bool(data.get("ok", False)),
                message=str(data.get("message", "Done")),
                session_id=session_id,
                aadhaar_masked=str(data.get("aadhaar_masked", "")),
                name=str(data.get("name", "")),
                numeric_id=str(data.get("numeric_id", "")),
                pdf_password_hint=str(data.get("pdf_password", "")),
                phone=str(data.get("phone", "")),
                pdf_bytes=pdf_b,
                raw=uidai_raw,
            )

        s = self._mock_sessions.get(session_id)
        if not s or otp.strip() != s["otp2"]:
            return LookupResult(ok=False, message="Galat OTP 2")
        name = s["name"]
        return LookupResult(
            ok=True,
            message="Extraction complete (demo)",
            session_id=session_id,
            aadhaar_masked="9815 7689 9641",
            name=name,
            numeric_id="0231191050808620260509095954",
            pdf_password_hint=pdf_password_hint(name, s),
            phone=s["mobile"],
            pdf_bytes=b"%PDF-1.4 mock aadhaar export\n",
            raw={"mock": True},
        )
