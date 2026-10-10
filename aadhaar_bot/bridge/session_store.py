from __future__ import annotations

import secrets
import time
from dataclasses import dataclass, field
from typing import Any


@dataclass
class BridgeSession:
    mobile: str
    name: str
    gender: str
    captcha_txn_id: str
    captcha_value: str
    otp_txn_id: str
    uidai_payload: dict[str, Any] = field(default_factory=dict)
    otp_stage: int = 1
    created_at: float = field(default_factory=time.time)


class SessionStore:
    def __init__(self) -> None:
        self._sessions: dict[str, BridgeSession] = {}

    def create(self, **kwargs: Any) -> str:
        sid = secrets.token_hex(12)
        self._sessions[sid] = BridgeSession(**kwargs)
        return sid

    def get(self, sid: str) -> BridgeSession | None:
        return self._sessions.get(sid)
