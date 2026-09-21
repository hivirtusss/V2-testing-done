import asyncio
import logging
import re
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
APK_ATTACH_MAX_AGE_SEC = 259200  # 72 hours
LICENSE_KEY_RE = re.compile(
    r"^KEY-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}$"
)


def make_license_key() -> str:
    raw = secrets.token_hex(8).upper()
    return f"KEY-{raw[0:4]}-{raw[4:8]}-{raw[8:12]}-{raw[12:16]}"


def _normalize_key(key: str) -> str:
    return key.strip().upper()


def is_valid_license_key_format(key: str) -> bool:
    return bool(LICENSE_KEY_RE.match(_normalize_key(key)))


def assert_license_key_format(key: str) -> str:
    normalized = _normalize_key(key)
    if not is_valid_license_key_format(normalized):
        raise ValueError("invalid_format")
    return normalized


def assert_license_key_registered(key: str) -> str:
    normalized = assert_license_key_format(key)
    db: Session = SessionLocal()
    try:
        record = _get_db_key(db, normalized)
        if not record or not record.active:
            raise ValueError("invalid_key")
        return normalized
    finally:
        db.close()


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
    normalized = assert_license_key_registered(key)
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
    if not is_valid_license_key_format(key):
        return False
    db: Session = SessionLocal()
    try:
        record = _get_db_key(db, key)
        return record is not None and record.active
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


def mark_apk_attached(
    key: str,
    device_id: str,
    telegram_user_id: int | None = None,
) -> bool:
    device_id = device_id.strip()
    if not device_id:
        return False

    db: Session = SessionLocal()
    try:
        record = _get_db_key(db, key)
        if not record:
            return False
        entry = (
            db.query(LicenseKeyDevice)
            .filter(
                LicenseKeyDevice.license_key_id == record.id,
                LicenseKeyDevice.device_id == device_id,
            )
            .first()
        )
        if not entry and telegram_user_id is not None:
            ok, _message = register_device_on_key(key, device_id, telegram_user_id)
            if not ok:
                return False
            entry = (
                db.query(LicenseKeyDevice)
                .filter(
                    LicenseKeyDevice.license_key_id == record.id,
                    LicenseKeyDevice.device_id == device_id,
                )
                .first()
            )
        if not entry:
            return False
        entry.apk_attached_at = datetime.now(timezone.utc)
        db.commit()
        return True
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


def _apk_entry_is_valid(entry: dict[str, Any], normalized_key: str) -> bool:
    apk_key = str(entry.get("license_key") or entry.get("key") or "").strip()
    if apk_key:
        if _normalize_key(apk_key) != normalized_key:
            return False
    attached_ms = int(entry.get("apk_attached_at_ms") or 0)
    if attached_ms <= 0:
        return False
    age_ms = int(time.time() * 1000) - attached_ms
    return age_ms <= APK_ATTACH_MAX_AGE_SEC * 1000


async def _list_firebase_apk_devices(key: str) -> list[tuple[str, dict[str, Any]]]:
    normalized = assert_license_key_registered(key)
    found: list[tuple[str, dict[str, Any]]] = []
    all_devices = await _firebase_get(f"{_module_db()}/license_keys/{normalized}/devices")
    if not isinstance(all_devices, dict):
        return found

    for dev_id, entry in all_devices.items():
        dev_id = str(dev_id).strip()
        if not dev_id:
            continue
        if isinstance(entry, dict) and _apk_entry_is_valid(entry, normalized):
            found.append((dev_id, entry))
            continue
        remote = await _firebase_get(_device_url(normalized, dev_id))
        if isinstance(remote, dict) and _apk_entry_is_valid(remote, normalized):
            found.append((dev_id, remote))
    return found


async def sync_apk_attached_from_firebase(
    key: str,
    device_id: str,
    telegram_user_id: int | None = None,
) -> tuple[bool, str | None]:
    normalized = assert_license_key_registered(key)
    preferred = device_id.strip()

    for dev_id, _entry in await _list_firebase_apk_devices(normalized):
        if mark_apk_attached(normalized, dev_id, telegram_user_id):
            if preferred and dev_id != preferred and telegram_user_id is not None:
                copy_apk_attach_between_devices(
                    normalized,
                    dev_id,
                    preferred,
                    telegram_user_id,
                )
            return True, dev_id

    return False, None


async def verify_apk_for_device(
    key: str,
    device_id: str,
    telegram_user_id: int,
) -> tuple[bool, str | None]:
    """Verify APK attach — APK reports android_id, bot uses Firebase device id."""
    normalized = assert_license_key_registered(key)
    device_id = device_id.strip()
    if not device_id:
        return False, None

    register_device_on_key(normalized, device_id, telegram_user_id)

    for attempt in range(3):
        attached, apk_device_id = await sync_apk_attached_from_firebase(
            normalized,
            device_id,
            telegram_user_id,
        )
        if attached and is_apk_attached(normalized, device_id):
            return True, apk_device_id or device_id

        for dev_id, _entry in await _list_firebase_apk_devices(normalized):
            if mark_apk_attached(normalized, dev_id, telegram_user_id):
                if dev_id != device_id:
                    copy_apk_attach_between_devices(
                        normalized,
                        dev_id,
                        device_id,
                        telegram_user_id,
                    )
                if is_apk_attached(normalized, device_id):
                    return True, dev_id

        for dev_id, meta in list_key_devices(normalized).items():
            if not is_apk_attached(normalized, dev_id):
                continue
            if dev_id != device_id:
                copy_apk_attach_between_devices(
                    normalized,
                    dev_id,
                    device_id,
                    telegram_user_id,
                )
            if is_apk_attached(normalized, device_id):
                return True, dev_id

        if attempt < 2:
            await asyncio.sleep(1.0)

    return is_apk_attached(normalized, device_id), None


def copy_apk_attach_between_devices(
    key: str,
    from_device_id: str,
    to_device_id: str,
    telegram_user_id: int,
) -> bool:
    from_device_id = from_device_id.strip()
    to_device_id = to_device_id.strip()
    if not from_device_id or not to_device_id or from_device_id == to_device_id:
        return is_apk_attached(key, to_device_id)

    db: Session = SessionLocal()
    try:
        record = _get_db_key(db, key)
        if not record:
            return False
        from_entry = (
            db.query(LicenseKeyDevice)
            .filter(
                LicenseKeyDevice.license_key_id == record.id,
                LicenseKeyDevice.device_id == from_device_id,
            )
            .first()
        )
        if not from_entry or not from_entry.apk_attached_at:
            return False
        register_device_on_key(key, to_device_id, telegram_user_id)
        to_entry = (
            db.query(LicenseKeyDevice)
            .filter(
                LicenseKeyDevice.license_key_id == record.id,
                LicenseKeyDevice.device_id == to_device_id,
            )
            .first()
        )
        if not to_entry:
            return False
        to_entry.apk_attached_at = from_entry.apk_attached_at
        db.commit()
        return True
    finally:
        db.close()


async def ensure_ready_for_monitoring(
    key: str,
    device_id: str,
    telegram_user_id: int | None = None,
) -> None:
    normalized = assert_license_key_registered(key)
    device_id = device_id.strip()

    if telegram_user_id is not None:
        register_device_on_key(normalized, device_id, telegram_user_id)
    elif device_id not in list_key_devices(normalized):
        raise ValueError("Pehle /fdy <device_id> ya /a <device_id> se device select karo.")

    if not is_apk_attached(normalized, device_id) and telegram_user_id is not None:
        verified, _apk_id = await verify_apk_for_device(
            normalized,
            device_id,
            telegram_user_id,
        )
        if verified:
            return

    if not is_apk_attached(normalized, device_id):
        for dev_id, meta in list_key_devices(normalized).items():
            if telegram_user_id is not None and meta.get("telegram_user_id") not in (
                None,
                telegram_user_id,
            ):
                continue
            if is_apk_attached(normalized, dev_id):
                if dev_id != device_id and telegram_user_id is not None:
                    copy_apk_attach_between_devices(
                        normalized, dev_id, device_id, telegram_user_id
                    )
                if is_apk_attached(normalized, device_id):
                    return

        raise ValueError(
            "APK mein SAME key daalo + START SERVICE ON karo.\n"
            "Phir /key confirm — ya Monitoring ON dubara dabao."
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
