"""APK phone bootstrap — KEY-only flow registers /mynum automatically."""

from __future__ import annotations

from sqlalchemy.orm import Session

from app.apk_config_api import _profile_for_key, build_apk_config
from app.firebase_sync import mynum_device_id, push_module_config, push_virtus_apk_config
from app.license_keys import is_valid_license_key_format, license_key_exists, register_device_on_key
from app.services import get_active_device, normalize_phone, set_profile_phone


def register_apk_phone(db: Session, license_key: str, phone: str) -> dict | None:
    """APK reports its SIM number — links num-{phone} to KEY for inject queue."""
    normalized = license_key.strip().upper()
    if not is_valid_license_key_format(normalized) or not license_key_exists(normalized):
        return None

    profile = _profile_for_key(db, normalized)
    if not profile:
        return None

    clean = normalize_phone(phone)
    if len(clean) < 10:
        return None

    set_profile_phone(db, profile.telegram_user_id, clean)
    poll_id = mynum_device_id(clean)
    register_device_on_key(normalized, poll_id, profile.telegram_user_id)

    device = get_active_device(db, profile.telegram_user_id)
    if device:
        db.commit()
        return build_apk_config(db, normalized)

    db.commit()
    return build_apk_config(db, normalized)


async def publish_apk_live_config(db: Session, license_key: str) -> None:
    profile = _profile_for_key(db, license_key.strip().upper())
    if not profile:
        return
    device = get_active_device(db, profile.telegram_user_id)
    await push_virtus_apk_config(profile, device)
    await push_module_config(profile, device)
