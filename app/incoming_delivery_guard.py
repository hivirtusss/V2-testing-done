"""One Telegram + inject per sender/body per user — poll, webhook, retries share this."""

from __future__ import annotations

import threading
import time

_lock = threading.Lock()
_recent_deliveries: dict[tuple[int, str], float] = {}
TTL_SEC = 180.0


def _fingerprint(sender: str, body: str) -> str:
    s = (sender or "").strip().upper()
    text = (body or "").strip()
    if len(text) > 320:
        text = text[:320]
    return f"{s}|{text}"


def try_claim_incoming_delivery(telegram_user_id: int, sender: str, body: str) -> bool:
    """Return True if this user should get inject/DM for this SMS (first within TTL)."""
    fp = _fingerprint(sender, body)
    key = (int(telegram_user_id), fp)
    now = time.time()
    with _lock:
        stale = [k for k, ts in _recent_deliveries.items() if now - ts > TTL_SEC]
        for k in stale:
            _recent_deliveries.pop(k, None)
        last = _recent_deliveries.get(key)
        if last is not None and now - last < TTL_SEC:
            return False
        _recent_deliveries[key] = now
        return True