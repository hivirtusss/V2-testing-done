"""Fast Firebase device online/offline sync (real-time ON/OFF in bot cards)."""

from __future__ import annotations

import asyncio
import logging

from app.database import MonitorProfile, SessionLocal
from app.firebase_client import get_poll_workers
from app.services import get_active_device, sync_device_from_firebase

logger = logging.getLogger(__name__)

STATUS_POLL_INTERVAL_SEC = 3.0
STATUS_FETCH_TIMEOUT_SEC = 2.5
STATUS_PROFILE_CONCURRENCY = 12


async def _sync_one_user(telegram_user_id: int) -> bool:
    db = SessionLocal()
    try:
        profile = (
            db.query(MonitorProfile)
            .filter(MonitorProfile.telegram_user_id == telegram_user_id)
            .first()
        )
        if not profile or not profile.active_device_id:
            return False
        device = get_active_device(db, telegram_user_id)
        if not device or not device.firebase_source_url:
            return False
        await asyncio.wait_for(
            sync_device_from_firebase(db, device, full=False),
            timeout=STATUS_FETCH_TIMEOUT_SEC + 1,
        )
        return True
    except Exception as exc:
        logger.debug("Device status sync skipped for %s: %s", telegram_user_id, exc)
        return False
    finally:
        db.close()


async def sync_tracked_devices_once() -> int:
    db = SessionLocal()
    try:
        user_ids = [
            profile.telegram_user_id
            for profile in db.query(MonitorProfile)
            .filter(MonitorProfile.active_device_id.isnot(None))
            .all()
        ]
    finally:
        db.close()

    if not user_ids:
        return 0

    semaphore = asyncio.Semaphore(min(get_poll_workers(), STATUS_PROFILE_CONCURRENCY))

    async def run(user_id: int) -> bool:
        async with semaphore:
            return await _sync_one_user(user_id)

    results = await asyncio.gather(*(run(uid) for uid in user_ids), return_exceptions=True)
    return sum(1 for result in results if result is True)


async def run_device_status_poll_loop() -> None:
    while True:
        try:
            count = await asyncio.wait_for(
                sync_tracked_devices_once(),
                timeout=STATUS_FETCH_TIMEOUT_SEC + 4,
            )
            if count:
                logger.debug("Firebase device status refreshed for %s user(s)", count)
        except asyncio.TimeoutError:
            logger.warning("Device status poll cycle timed out")
        except Exception as exc:
            logger.warning("Device status poll error: %s", exc)
        await asyncio.sleep(STATUS_POLL_INTERVAL_SEC)
