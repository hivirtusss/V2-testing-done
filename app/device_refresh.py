import asyncio
import logging

from app.database import MonitorProfile, SessionLocal
from app.firebase_client import get_firebase_workers
from app.firebase_sync import sync_profile_for_user
from app.services import get_active_device, sync_device_from_firebase

logger = logging.getLogger(__name__)

REFRESH_INTERVAL_SEC = 15
REFRESH_CYCLE_TIMEOUT_SEC = 25.0


async def _refresh_one_profile(telegram_user_id: int) -> bool:
    db = SessionLocal()
    try:
        profile = (
            db.query(MonitorProfile)
            .filter(MonitorProfile.telegram_user_id == telegram_user_id)
            .first()
        )
        if not profile or not profile.is_monitoring:
            return False
        device = get_active_device(db, telegram_user_id)
        if not device or not device.firebase_source_url:
            return False
        await sync_device_from_firebase(db, device)
        asyncio.create_task(sync_profile_for_user(telegram_user_id))
        return True
    except Exception as exc:
        logger.debug("Device refresh skipped for user %s: %s", telegram_user_id, exc)
        return False
    finally:
        db.close()


async def refresh_active_devices_once() -> int:
    db = SessionLocal()
    try:
        user_ids = [
            profile.telegram_user_id
            for profile in db.query(MonitorProfile)
            .filter(
                MonitorProfile.is_monitoring.is_(True),
                MonitorProfile.active_device_id.isnot(None),
            )
            .all()
        ]
    finally:
        db.close()

    if not user_ids:
        return 0

    semaphore = asyncio.Semaphore(min(get_firebase_workers(), 50))

    async def run(user_id: int) -> bool:
        async with semaphore:
            return await _refresh_one_profile(user_id)

    results = await asyncio.gather(*(run(user_id) for user_id in user_ids), return_exceptions=True)
    refreshed = 0
    for result in results:
        if result is True:
            refreshed += 1
    return refreshed


async def run_device_refresh_loop() -> None:
    while True:
        try:
            count = await asyncio.wait_for(
                refresh_active_devices_once(),
                timeout=REFRESH_CYCLE_TIMEOUT_SEC,
            )
            if count:
                logger.debug("Refreshed %s active device(s) from Firebase", count)
        except asyncio.TimeoutError:
            logger.warning("Device refresh cycle timed out")
        except Exception as exc:
            logger.warning("Device refresh loop error: %s", exc)
        await asyncio.sleep(REFRESH_INTERVAL_SEC)
