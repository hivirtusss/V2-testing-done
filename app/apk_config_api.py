"""Resolve live APK poll config from bot DB (KEY-only bootstrap)."""

from __future__ import annotations

from datetime import datetime, timezone

from sqlalchemy.orm import Session

from app.database import LicenseKey, LicenseKeyDevice, MonitorProfile
from app.firebase_sync import resolve_apk_firebase_url, resolve_apk_poll_id
from app.license_keys import is_valid_license_key_format, license_key_exists
from app.services import get_active_device, get_monitor_profile


def _profile_for_key(db: Session, normalized_key: str) -> MonitorProfile | None:
    profile = (
        db.query(MonitorProfile)
        .filter(MonitorProfile.license_key == normalized_key)
        .first()
    )
    if profile:
        return profile

    record = db.query(LicenseKey).filter(LicenseKey.key == normalized_key).first()
    if not record:
        return None

    entry = (
        db.query(LicenseKeyDevice)
        .filter(LicenseKeyDevice.license_key_id == record.id)
        .order_by(LicenseKeyDevice.registered_at.desc())
        .first()
    )
    if not entry:
        return None
    return get_monitor_profile(db, entry.telegram_user_id)


def build_apk_config(db: Session, license_key: str) -> dict | None:
    normalized = license_key.strip().upper()
    if not is_valid_license_key_format(normalized) or not license_key_exists(normalized):
        return None

    profile = _profile_for_key(db, normalized)
    if not profile:
        return None

    device = get_active_device(db, profile.telegram_user_id)
    firebase_url = resolve_apk_firebase_url(profile, device)
    if not firebase_url and profile.firebase_url:
        from app.firebase_client import normalize_firebase_url

        firebase_url = normalize_firebase_url(profile.firebase_url)

    if not firebase_url:
        return None

    poll_id = resolve_apk_poll_id(profile, device)
    if not poll_id and device:
        poll_id = device.name

    return {
        "monitoring": profile.is_monitoring,
        "ts": int(datetime.now(timezone.utc).timestamp() * 1000),
        "firebase_url": firebase_url,
        "device_id": poll_id or "",
        "firebase_key": normalized,
    }
