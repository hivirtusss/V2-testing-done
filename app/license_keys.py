import logging
import secrets
import time
from typing import Any

import httpx

from app.config import get_settings

logger = logging.getLogger(__name__)
settings = get_settings()

DEFAULT_MAX_DEVICES = 2
APK_ATTACH_MAX_AGE_SEC = 300


def make_license_key() -> str:
    raw = secrets.token_hex(8).upper()
    return f"KEY-{raw[0:4]}-{raw[4:8]}-{raw[8:12]}-{raw[12:16]}"


def _module_db() -> str:
    return settings.virtus_module_db.rstrip("/")


def _normalize_key(key: str) -> str:
    return key.strip().upper()


def _meta_url(key: str) -> str:
    return f"{_module_db()}/license_keys/{_normalize_key(key)}/meta"


def _device_url(key: str, device_id: str) -> str:
    return f"{_module_db()}/license_keys/{_normalize_key(key)}/devices/{device_id}"


def _config_url(key: str) -> str:
    return f"{_module_db()}/config/{_normalize_key(key)}"


async def _firebase_put(url: str, data: dict) -> None:
    async with httpx.AsyncClient(timeout=8.0, follow_redirects=True) as client:
        response = await client.put(f"{url}.json", json=data)
        response.raise_for_status()


async def _firebase_get(url: str) -> dict[str, Any] | None:
    async with httpx.AsyncClient(timeout=8.0, follow_redirects=True) as client:
        response = await client.get(f"{url}.json")
        if response.status_code == 404:
            return None
        response.raise_for_status()
        data = response.json()
        if data is None:
            return None
        if isinstance(data, dict):
            return data
        return None


async def generate_license_key(telegram_user_id: int, max_devices: int = DEFAULT_MAX_DEVICES) -> str:
    key = make_license_key()
    now_ms = int(time.time() * 1000)
    meta = {
        "license_key": key,
        "max_devices": max_devices,
        "created_by": telegram_user_id,
        "created_at_ms": now_ms,
        "active": True,
    }
    config = {
        "monitoring": False,
        "ts": now_ms,
        "firebase_url": _module_db(),
        "device_id": "",
        "firebase_key": key,
        "channel_id": "",
        "target_number": "",
        "sim_index": 0,
        "apk_attached": False,
    }
    await _firebase_put(_meta_url(key), meta)
    await _firebase_put(_config_url(key), config)
    return key


async def license_key_exists(key: str) -> bool:
    normalized = _normalize_key(key)
    if not normalized.startswith("KEY-"):
        return False
    meta = await _firebase_get(_meta_url(normalized))
    return bool(meta and meta.get("active", True))


async def list_key_devices(key: str) -> dict[str, dict[str, Any]]:
    normalized = _normalize_key(key)
    data = await _firebase_get(f"{_module_db()}/license_keys/{normalized}/devices")
    if not isinstance(data, dict):
        return {}
    return {device_id: value for device_id, value in data.items() if isinstance(value, dict)}


async def get_key_meta(key: str) -> dict[str, Any] | None:
    return await _firebase_get(_meta_url(_normalize_key(key)))


async def register_device_on_key(
    key: str,
    device_id: str,
    telegram_user_id: int,
) -> tuple[bool, str]:
    normalized = _normalize_key(key)
    meta = await get_key_meta(normalized)
    if not meta:
        return False, "Key not found. Pehle /key generate karo."

    max_devices = int(meta.get("max_devices", DEFAULT_MAX_DEVICES))
    devices = await list_key_devices(normalized)
    device_id = device_id.strip()
    if not device_id:
        return False, "Device ID empty hai."

    if device_id in devices:
        await _firebase_put(
            _device_url(normalized, device_id),
            {
                **devices[device_id],
                "telegram_user_id": telegram_user_id,
                "updated_at_ms": int(time.time() * 1000),
            },
        )
        return True, "Device already registered on key."

    if len(devices) >= max_devices:
        return False, f"Is key par max {max_devices} devices allowed hain."

    now_ms = int(time.time() * 1000)
    await _firebase_put(
        _device_url(normalized, device_id),
        {
            "device_id": device_id,
            "telegram_user_id": telegram_user_id,
            "registered_at_ms": now_ms,
            "apk_attached_at_ms": 0,
        },
    )
    return True, "Device registered on key."


async def is_apk_attached(key: str, device_id: str) -> bool:
    normalized = _normalize_key(key)
    entry = await _firebase_get(_device_url(normalized, device_id.strip()))
    if not entry:
        return False
    attached_ms = int(entry.get("apk_attached_at_ms") or 0)
    if attached_ms <= 0:
        return False
    age_sec = time.time() - (attached_ms / 1000)
    return age_sec <= APK_ATTACH_MAX_AGE_SEC


async def ensure_ready_for_monitoring(key: str, device_id: str) -> None:
    normalized = _normalize_key(key)
    if not normalized.startswith("KEY-"):
        raise ValueError("Pehle /key generate ya valid KEY set karo.")

    meta = await get_key_meta(normalized)
    if not meta:
        raise ValueError("Invalid key. /key generate se nayi key banao.")

    devices = await list_key_devices(normalized)
    device_id = device_id.strip()
    if device_id not in devices:
        raise ValueError("Device is key par register nahi. Pehle /fy <device_id> karo.")

    if not await is_apk_attached(normalized, device_id):
        raise ValueError(
            "APK mein SAME key daalo + START SERVICE dabao.\n"
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
) -> None:
    normalized = _normalize_key(key)
    payload = {
        "monitoring": monitoring,
        "ts": int(time.time() * 1000),
        "firebase_url": _module_db(),
        "device_id": device_id or "",
        "firebase_key": normalized,
        "channel_id": channel_id or "",
        "target_number": target_number or "",
        "sim_index": sim_index,
        "apk_attached": False,
    }
    await _firebase_put(_config_url(normalized), payload)
