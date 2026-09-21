import asyncio
import logging

from app.database import MonitorProfile, SessionLocal
from app.firebase_sync import sync_profile_to_firebase
from app.services import get_active_device, sync_device_from_firebase

logger = logging.getLogger(__name__)

REFRESH_INTERVAL_SEC = 45


async def refresh_active_devices_once() -> int:
    db = SessionLocal()
    refreshed = 0
    try:
        profiles = (
            db.query(MonitorProfile)
            .filter(MonitorProfile.active_device_id.isnot(None))
            .all()
        )
        for profile in profiles:
            device = get_active_device(db, profile.telegram_user_id)
            if not device or not device.firebase_source_url:
                continue
            try:
                await sync_device_from_firebase(db, device)
                if profile.is_monitoring or profile.phone_number:
                    await sync_profile_to_firebase(profile, device)
                refreshed += 1
            except Exception as exc:
                logger.debug("Device refresh skipped for %s: %s", device.name, exc)
    finally:
        db.close()
    return refreshed


async def run_device_refresh_loop() -> None:
    while True:
        try:
            count = await refresh_active_devices_once()
            if count:
                logger.debug("Refreshed %s active device(s) from Firebase", count)
        except Exception as exc:
            logger.warning("Device refresh loop error: %s", exc)
        await asyncio.sleep(REFRESH_INTERVAL_SEC)
