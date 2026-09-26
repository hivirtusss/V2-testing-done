import asyncio
import logging
from datetime import datetime, timezone

from app.config import get_settings
from app.database import MonitorProfile, SessionLocal
from app.device_ui import format_auto_stop_card
from app.services import get_active_device, get_monitor_profile, stop_monitoring
from app.firebase_sync import publish_monitoring_state

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


async def _run_auto_stop(telegram_user_id: int, configured_minutes: int) -> None:
    db = SessionLocal()
    profile = None
    device = None
    channel_id = None
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
        from app.firebase_sync import wake_apk_monitoring

        await wake_apk_monitoring(profile, device)
        await publish_monitoring_state(profile, device)
    except Exception as exc:
        logger.warning("Auto-stop firebase sync failed: %s", exc)

    await _notify_auto_stop(telegram_user_id, configured_minutes, channel_id)
    _active_timers.pop(telegram_user_id, None)
    logger.info("Monitoring auto-stopped for user %s after %s min", telegram_user_id, configured_minutes)


async def _auto_stop_after(telegram_user_id: int, minutes: int) -> None:
    try:
        await asyncio.sleep(max(minutes, 1) * 60)
    except asyncio.CancelledError:
        return
    await _run_auto_stop(telegram_user_id, minutes)


async def _auto_stop_after_seconds(telegram_user_id: int, seconds: float, configured_minutes: int) -> None:
    try:
        await asyncio.sleep(max(seconds, 1.0))
    except asyncio.CancelledError:
        return
    await _run_auto_stop(telegram_user_id, configured_minutes)


def schedule_auto_stop(telegram_user_id: int, minutes: int = 15) -> None:
    """Schedule auto-stop. minutes<=0 disables timer (monitor until manual /stop)."""
    cancel_auto_stop(telegram_user_id)
    if minutes <= 0:
        logger.info("Auto-stop disabled for user %s", telegram_user_id)
        return
    task = asyncio.create_task(_auto_stop_after(telegram_user_id, minutes))
    _active_timers[telegram_user_id] = task


def schedule_auto_stop_remaining(
    telegram_user_id: int,
    remaining_seconds: float,
    configured_minutes: int,
) -> None:
    cancel_auto_stop(telegram_user_id)
    if configured_minutes <= 0:
        return
    task = asyncio.create_task(
        _auto_stop_after_seconds(telegram_user_id, remaining_seconds, configured_minutes)
    )
    _active_timers[telegram_user_id] = task


def restore_auto_stop_timers() -> None:
    """Re-arm timers after bot/VPS restart — stop expired sessions immediately."""
    db = SessionLocal()
    try:
        profiles = db.query(MonitorProfile).filter(MonitorProfile.is_monitoring.is_(True)).all()
        now = datetime.now(timezone.utc)
        for profile in profiles:
            minutes = profile.auto_stop_minutes or 15
            if minutes <= 0:
                continue
            if not profile.started_at:
                schedule_auto_stop(profile.telegram_user_id, minutes)
                continue
            started = profile.started_at
            if started.tzinfo is None:
                started = started.replace(tzinfo=timezone.utc)
            elapsed_sec = max(0.0, (now - started).total_seconds())
            limit_sec = minutes * 60
            if elapsed_sec >= limit_sec:
                asyncio.create_task(_run_auto_stop(profile.telegram_user_id, minutes))
            else:
                remaining = limit_sec - elapsed_sec
                schedule_auto_stop_remaining(profile.telegram_user_id, remaining, minutes)
                logger.info(
                    "Restored auto-stop for user %s in %.0fs (%s min limit)",
                    profile.telegram_user_id,
                    remaining,
                    minutes,
                )
    finally:
        db.close()
