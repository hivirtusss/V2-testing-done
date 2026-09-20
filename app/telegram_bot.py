import logging
from datetime import datetime, timezone

from sqlalchemy.orm import Session
from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes

from app.config import get_settings
from app.database import Device, SMSMessage, SessionLocal
from app.services import device_status, list_devices_with_counts, register_device

logger = logging.getLogger(__name__)
settings = get_settings()


def is_authorized(user_id: int | None) -> bool:
    if user_id is None:
        return False
    allowed = settings.allowed_user_ids
    if not allowed:
        return True
    return user_id in allowed


def format_sms(sms: SMSMessage) -> str:
    received = sms.received_at.astimezone(timezone.utc).strftime("%d %b %Y, %H:%M UTC")
    return (
        f"📱 *Device:* `{sms.device_name}`\n"
        f"📞 *From:* `{sms.sender}`\n"
        f"🕐 *Time:* {received}\n"
        f"💬 *Message:*\n{sms.message}"
    )


def format_device_line(device: Device, sms_count: int) -> str:
    status = device_status(device)
    icon = {"online": "🟢", "idle": "🟡", "offline": "🔴", "inactive": "⚫"}.get(status, "⚪")
    last_seen = (
        device.last_seen.astimezone(timezone.utc).strftime("%d %b %H:%M")
        if device.last_seen
        else "Never"
    )
    return f"{icon} `{device.name}` — {sms_count} SMS | last: {last_seen}"


async def notify_new_sms(sms: SMSMessage) -> None:
    if not settings.telegram_bot_token:
        return

    allowed_users = settings.allowed_user_ids
    if not allowed_users:
        logger.warning("No TELEGRAM_ALLOWED_USERS set; skipping notification")
        return

    from telegram import Bot

    bot = Bot(token=settings.telegram_bot_token)
    text = "🆕 *New SMS Received*\n\n" + format_sms(sms)

    for user_id in allowed_users:
        try:
            await bot.send_message(chat_id=user_id, text=text, parse_mode="Markdown")
        except Exception as exc:
            logger.error("Failed to notify user %s: %s", user_id, exc)


async def start_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        await update.message.reply_text("❌ Unauthorized. Contact admin.")
        return

    await update.message.reply_text(
        "👋 *SMS Monitor Bot*\n\n"
        "Commands:\n"
        "/devices - Apni saari devices dekho\n"
        "/device <name> - Ek device ke SMS dekho\n"
        "/adddevice <name> - Nayi device add karo\n"
        "/recent - Last 10 SMS\n"
        "/search <keyword> - Search messages\n"
        "/stats - Total SMS count\n"
        "/help - Show help",
        parse_mode="Markdown",
    )


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    await update.message.reply_text(
        "📖 *Help*\n\n"
        "Apna database `.env` mein `DATABASE_URL` se connect karo.\n"
        "Device SMS bhejti hai to automatically bot mein aa jati hai.\n\n"
        "*Device commands:*\n"
        "/devices - Saari devices list\n"
        "/device redmi - Us device ke recent SMS\n"
        "/adddevice samsung - Manual device add\n\n"
        "*SMS commands:*\n"
        "/recent - Last 10 SMS\n"
        "/search otp - OTP dhundho\n"
        "/stats - Statistics",
        parse_mode="Markdown",
    )


async def devices_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    db: Session = SessionLocal()
    try:
        items = list_devices_with_counts(db)
    finally:
        db.close()

    if not items:
        await update.message.reply_text(
            "📭 Abhi koi device nahi hai.\n\n"
            "Add karo: `/adddevice my-phone`\n"
            "Ya SMS forward karo — device auto add ho jayegi.",
            parse_mode="Markdown",
        )
        return

    lines = ["📱 *Tumhari Devices*\n"]
    for item in items:
        lines.append(format_device_line(item["device"], item["sms_count"]))

    await update.message.reply_text("\n".join(lines), parse_mode="Markdown")


async def device_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    if not context.args:
        await update.message.reply_text("Usage: /device <device-name>")
        return

    device_name = " ".join(context.args)
    db: Session = SessionLocal()
    try:
        device = db.query(Device).filter(Device.name == device_name).first()
        if not device:
            await update.message.reply_text(
                f"❌ Device `{device_name}` nahi mili.\n/devices se list dekho.",
                parse_mode="Markdown",
            )
            return

        messages = (
            db.query(SMSMessage)
            .filter(SMSMessage.device_name == device_name)
            .order_by(SMSMessage.received_at.desc())
            .limit(10)
            .all()
        )
    finally:
        db.close()

    if not messages:
        await update.message.reply_text(f"📭 `{device_name}` par abhi koi SMS nahi.", parse_mode="Markdown")
        return

    parts = [f"📱 *Device:* `{device_name}`\n"]
    for sms in messages:
        parts.append(format_sms(sms))
        parts.append("—" * 20)

    await update.message.reply_text("\n".join(parts), parse_mode="Markdown")


async def adddevice_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    if not context.args:
        await update.message.reply_text("Usage: /adddevice <device-name>")
        return

    device_name = " ".join(context.args)
    db: Session = SessionLocal()
    try:
        device = register_device(db, device_name)
        db.commit()
        db.refresh(device)
    finally:
        db.close()

    await update.message.reply_text(
        f"✅ Device added: `{device.name}`\n"
        f"🔑 Device API key: `{device.api_key}`\n\n"
        f"Phone par ye key use karo webhook mein.",
        parse_mode="Markdown",
    )


async def recent_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    db: Session = SessionLocal()
    try:
        messages = (
            db.query(SMSMessage)
            .order_by(SMSMessage.received_at.desc())
            .limit(10)
            .all()
        )
    finally:
        db.close()

    if not messages:
        await update.message.reply_text("📭 No SMS messages yet.")
        return

    parts = ["📬 *Recent SMS (last 10)*\n"]
    for sms in messages:
        parts.append(format_sms(sms))
        parts.append("—" * 20)

    await update.message.reply_text("\n".join(parts), parse_mode="Markdown")


async def search_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    if not context.args:
        await update.message.reply_text("Usage: /search <keyword>")
        return

    keyword = " ".join(context.args).lower()
    db: Session = SessionLocal()
    try:
        messages = (
            db.query(SMSMessage)
            .filter(SMSMessage.message.ilike(f"%{keyword}%"))
            .order_by(SMSMessage.received_at.desc())
            .limit(10)
            .all()
        )
    finally:
        db.close()

    if not messages:
        await update.message.reply_text(f"🔍 No messages found for: `{keyword}`", parse_mode="Markdown")
        return

    parts = [f"🔍 *Search results for:* `{keyword}`\n"]
    for sms in messages:
        parts.append(format_sms(sms))
        parts.append("—" * 20)

    await update.message.reply_text("\n".join(parts), parse_mode="Markdown")


async def stats_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    db: Session = SessionLocal()
    try:
        total = db.query(SMSMessage).count()
        device_count = db.query(Device).count()
        latest = (
            db.query(SMSMessage)
            .order_by(SMSMessage.received_at.desc())
            .first()
        )
    finally:
        db.close()

    latest_text = "Never"
    if latest:
        latest_text = latest.received_at.astimezone(timezone.utc).strftime("%d %b %Y, %H:%M UTC")

    await update.message.reply_text(
        f"📊 *SMS Monitor Stats*\n\n"
        f"Total messages: *{total}*\n"
        f"Total devices: *{device_count}*\n"
        f"Last received: {latest_text}",
        parse_mode="Markdown",
    )


def build_telegram_app() -> Application | None:
    if not settings.telegram_bot_token:
        logger.warning("TELEGRAM_BOT_TOKEN not set; Telegram bot disabled")
        return None

    app = Application.builder().token(settings.telegram_bot_token).build()
    app.add_handler(CommandHandler("start", start_command))
    app.add_handler(CommandHandler("help", help_command))
    app.add_handler(CommandHandler("devices", devices_command))
    app.add_handler(CommandHandler("device", device_command))
    app.add_handler(CommandHandler("adddevice", adddevice_command))
    app.add_handler(CommandHandler("recent", recent_command))
    app.add_handler(CommandHandler("search", search_command))
    app.add_handler(CommandHandler("stats", stats_command))
    return app
