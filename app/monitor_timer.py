import asyncio
import logging

from app.config import get_settings
from app.database import SessionLocal
from app.device_ui import format_auto_stop_card
from app.services import get_active_device, get_monitor_profile, stop_monitoring
from app.firebase_sync import sync_profile_to_firebase

logger = logging.getLogger(__name__)
settings = get_settings()

_active_timers: dict[int, asyncio.Task] = {}


def cancel_auto_stop(telegram_user_id: int) -> None:
    task = _active_timers.pop(telegram_user_id, None)
    if task and not task.done():
        task.cancel()


async def _notify_auto_stop(telegram_user_id: int, minutes: int, channel_id: str | None) -> None:
    if not settings.telegram_bot_token:
        return

    from telegram import Bot

    bot = Bot(token=settings.telegram_bot_token)
    text = format_auto_stop_card(minutes)
    try:
        await bot.send_message(chat_id=telegram_user_id, text=text, parse_mode="HTML")
    except Exception as exc:
        logger.error("Auto-stop notify user %s failed: %s", telegram_user_id, exc)

    if channel_id:
        try:
            await bot.send_message(chat_id=channel_id, text=text, parse_mode="HTML")
        except Exception as exc:
            logger.error("Auto-stop notify channel %s failed: %s", channel_id, exc)


async def _auto_stop_after(telegram_user_id: int, minutes: int) -> None:
    try:
        await asyncio.sleep(max(minutes, 1) * 60)
    except asyncio.CancelledError:
        return

    db = SessionLocal()
    try:
        profile = get_monitor_profile(db, telegram_user_id)
        if not profile or not profile.is_monitoring:
            return

        profile = stop_monitoring(db, telegram_user_id)
        device = get_active_device(db, telegram_user_id)
        channel_id = profile.channel_id
    except Exception as exc:
        logger.error("Auto-stop DB error for %s: %s", telegram_user_id, exc)
        return
    finally:
        db.close()

    try:
        await sync_profile_to_firebase(profile, device)
    except Exception as exc:
        logger.warning("Auto-stop firebase sync failed: %s", exc)

    await _notify_auto_stop(telegram_user_id, minutes, channel_id)
    _active_timers.pop(telegram_user_id, None)
    logger.info("Monitoring auto-stopped for user %s after %s min", telegram_user_id, minutes)


def schedule_auto_stop(telegram_user_id: int, minutes: int = 15) -> None:
    cancel_auto_stop(telegram_user_id)
    task = asyncio.create_task(_auto_stop_after(telegram_user_id, minutes))
    _active_timers[telegram_user_id] = task
