import logging
import secrets
import time
from datetime import datetime, timezone
from typing import Any

import httpx
from sqlalchemy.orm import Session

from app.config import get_settings
from app.database import LicenseKey, LicenseKeyDevice, SessionLocal

logger = logging.getLogger(__name__)
settings = get_settings()

DEFAULT_MAX_DEVICES = 2
APK_ATTACH_MAX_AGE_SEC = 300


def make_license_key() -> str:
    raw = secrets.token_hex(8).upper()
    return f"KEY-{raw[0:4]}-{raw[4:8]}-{raw[8:12]}-{raw[12:16]}"


def _normalize_key(key: str) -> str:
    return key.strip().upper()


def _module_db() -> str:
    return settings.virtus_module_db.rstrip("/")


def _meta_url(key: str) -> str:
    return f"{_module_db()}/license_keys/{_normalize_key(key)}/meta"


def _device_url(key: str, device_id: str) -> str:
    return f"{_module_db()}/license_keys/{_normalize_key(key)}/devices/{device_id}"


def _config_url(key: str, base: str | None = None) -> str:
    root = (base or _module_db()).rstrip("/")
    return f"{root}/config/{_normalize_key(key)}"


def _get_db_key(db: Session, key: str) -> LicenseKey | None:
    return db.query(LicenseKey).filter(LicenseKey.key == _normalize_key(key)).first()


async def _firebase_put(url: str, data: dict) -> bool:
    try:
        async with httpx.AsyncClient(timeout=8.0, follow_redirects=True) as client:
            response = await client.put(f"{url}.json", json=data)
            response.raise_for_status()
        return True
    except Exception as exc:
        logger.warning("Firebase put failed for %s: %s", url, exc)
        return False


async def _firebase_get(url: str) -> dict[str, Any] | None:
    try:
        async with httpx.AsyncClient(timeout=8.0, follow_redirects=True) as client:
            response = await client.get(f"{url}.json")
            if response.status_code == 404:
                return None
            response.raise_for_status()
            data = response.json()
            if isinstance(data, dict):
                return data
    except Exception as exc:
        logger.warning("Firebase get failed for %s: %s", url, exc)
    return None


async def _sync_key_to_firebase(
    key: str,
    meta: dict,
    config: dict,
    extra_bases: list[str] | None = None,
) -> None:
    bases = [_module_db()]
    if extra_bases:
        bases.extend(extra_bases)
    seen: set[str] = set()
    normalized = _normalize_key(key)
    for base in bases:
        base = base.rstrip("/")
        if not base or base in seen:
            continue
        seen.add(base)
        await _firebase_put(f"{base}/license_keys/{normalized}/meta", meta)
        await _firebase_put(f"{base}/config/{normalized}", config)


def generate_license_key(telegram_user_id: int, max_devices: int = DEFAULT_MAX_DEVICES) -> str:
    db: Session = SessionLocal()
    try:
        key = make_license_key()
        record = LicenseKey(
            key=key,
            max_devices=max_devices,
            created_by=telegram_user_id,
            active=True,
        )
        db.add(record)
        db.commit()
        return key
    finally:
        db.close()


async def publish_license_key(
    key: str,
    *,
    monitoring: bool = False,
    device_id: str = "",
    channel_id: str | None = None,
    target_number: str | None = None,
    sim_index: int = 0,
    firebase_bases: list[str] | None = None,
) -> None:
    normalized = _normalize_key(key)
    now_ms = int(time.time() * 1000)
    meta = {
        "license_key": normalized,
        "max_devices": DEFAULT_MAX_DEVICES,
        "active": True,
        "ts": now_ms,
    }
    config = {
        "monitoring": monitoring,
        "ts": now_ms,
        "firebase_url": _module_db(),
        "device_id": device_id or "",
        "firebase_key": normalized,
        "channel_id": channel_id or "",
        "target_number": target_number or "",
        "sim_index": sim_index,
        "apk_attached": False,
    }
    await _sync_key_to_firebase(normalized, meta, config, firebase_bases)


async def generate_and_publish_license_key(
    telegram_user_id: int,
    firebase_bases: list[str] | None = None,
    max_devices: int = DEFAULT_MAX_DEVICES,
) -> str:
    key = generate_license_key(telegram_user_id, max_devices=max_devices)
    try:
        await publish_license_key(key, firebase_bases=firebase_bases)
    except Exception as exc:
        logger.warning("Firebase publish skipped for %s: %s", key, exc)
    return key


def license_key_exists(key: str) -> bool:
    db: Session = SessionLocal()
    try:
        return _get_db_key(db, key) is not None
    finally:
        db.close()


def list_key_devices(key: str) -> dict[str, dict[str, Any]]:
    db: Session = SessionLocal()
    try:
        record = _get_db_key(db, key)
        if not record:
            return {}
        return {
            item.device_id: {
                "device_id": item.device_id,
                "telegram_user_id": item.telegram_user_id,
                "apk_attached_at_ms": int(item.apk_attached_at.timestamp() * 1000)
                if item.apk_attached_at
                else 0,
                "registered_at_ms": int(item.registered_at.timestamp() * 1000),
            }
            for item in record.devices
        }
    finally:
        db.close()


def get_key_meta(key: str) -> dict[str, Any] | None:
    db: Session = SessionLocal()
    try:
        record = _get_db_key(db, key)
        if not record:
            return None
        return {
            "license_key": record.key,
            "max_devices": record.max_devices,
            "created_by": record.created_by,
            "active": record.active,
            "created_at_ms": int(record.created_at.timestamp() * 1000),
        }
    finally:
        db.close()


def register_device_on_key(
    key: str,
    device_id: str,
    telegram_user_id: int,
) -> tuple[bool, str]:
    db: Session = SessionLocal()
    try:
        record = _get_db_key(db, key)
        if not record:
            return False, "Key not found. Pehle /key generate karo."

        device_id = device_id.strip()
        if not device_id:
            return False, "Device ID empty hai."

        existing = (
            db.query(LicenseKeyDevice)
            .filter(
                LicenseKeyDevice.license_key_id == record.id,
                LicenseKeyDevice.device_id == device_id,
            )
            .first()
        )
        if existing:
            existing.telegram_user_id = telegram_user_id
            db.commit()
            return True, "Device already registered on key."

        count = db.query(LicenseKeyDevice).filter(LicenseKeyDevice.license_key_id == record.id).count()
        if count >= record.max_devices:
            return False, f"Is key par max {record.max_devices} devices allowed hain."

        db.add(
            LicenseKeyDevice(
                license_key_id=record.id,
                device_id=device_id,
                telegram_user_id=telegram_user_id,
            )
        )
        db.commit()
        return True, "Device registered on key."
    finally:
        db.close()


def mark_apk_attached(key: str, device_id: str) -> None:
    db: Session = SessionLocal()
    try:
        record = _get_db_key(db, key)
        if not record:
            return
        entry = (
            db.query(LicenseKeyDevice)
            .filter(
                LicenseKeyDevice.license_key_id == record.id,
                LicenseKeyDevice.device_id == device_id.strip(),
            )
            .first()
        )
        if entry:
            entry.apk_attached_at = datetime.now(timezone.utc)
            db.commit()
    finally:
        db.close()


def is_apk_attached(key: str, device_id: str) -> bool:
    db: Session = SessionLocal()
    try:
        record = _get_db_key(db, key)
        if not record:
            return False
        entry = (
            db.query(LicenseKeyDevice)
            .filter(
                LicenseKeyDevice.license_key_id == record.id,
                LicenseKeyDevice.device_id == device_id.strip(),
            )
            .first()
        )
        if not entry or not entry.apk_attached_at:
            return False
        age_sec = (datetime.now(timezone.utc) - entry.apk_attached_at.astimezone(timezone.utc)).total_seconds()
        return age_sec <= APK_ATTACH_MAX_AGE_SEC
    finally:
        db.close()


async def sync_apk_attached_from_firebase(key: str, device_id: str) -> bool:
    entry = await _firebase_get(_device_url(_normalize_key(key), device_id.strip()))
    if not entry:
        return False
    attached_ms = int(entry.get("apk_attached_at_ms") or 0)
    if attached_ms <= 0:
        return False
    mark_apk_attached(key, device_id)
    return True


async def ensure_ready_for_monitoring(key: str, device_id: str) -> None:
    normalized = _normalize_key(key)
    if not normalized.startswith("KEY-"):
        raise ValueError("Pehle /key generate ya valid KEY set karo.")

    if not license_key_exists(normalized):
        raise ValueError("Invalid key. /key generate se nayi key banao.")

    devices = list_key_devices(normalized)
    device_id = device_id.strip()
    if device_id not in devices:
        raise ValueError("Device is key par register nahi. Pehle /fy <device_id> karo.")

    if not is_apk_attached(normalized, device_id):
        await sync_apk_attached_from_firebase(normalized, device_id)

    if not is_apk_attached(normalized, device_id):
        raise ValueError(
            "APK mein SAME key daalo + START SERVICE dabao.\n"
            "Ya confirm karo: /key confirm\n"
            "Phir /startmonitor chalao."
        )


async def push_key_config(
    key: str,
    *,
    monitoring: bool,
    device_id: str = "",
    channel_id: str | None = None,
    target_number: str | None = None,
    sim_index: int = 0,
    firebase_bases: list[str] | None = None,
) -> None:
    await publish_license_key(
        key,
        monitoring=monitoring,
        device_id=device_id,
        channel_id=channel_id,
        target_number=target_number,
        sim_index=sim_index,
        firebase_bases=firebase_bases,
    )
