"""Telegram DM notifications — kept separate to avoid circular imports."""

from __future__ import annotations

import logging

from app.config import get_settings
from app.device_ui import format_inject_stream_card

logger = logging.getLogger(__name__)
settings = get_settings()


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
