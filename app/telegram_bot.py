import logging
from datetime import datetime, timezone

from sqlalchemy.orm import Session
from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes

from app.config import get_settings
from app.database import SMSMessage, SessionLocal

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
        "This bot monitors SMS forwarded from your Android phone.\n\n"
        "*Setup:*\n"
        "1. Deploy this server with a public URL\n"
        "2. Install 'SMS Forwarder' app on Android\n"
        "3. Set webhook URL to:\n"
        "`POST /api/sms?key=YOUR_API_KEY`\n\n"
        "*Commands:*\n"
        "/recent - Show recent SMS\n"
        "/search otp - Find OTP messages\n"
        "/stats - Message statistics",
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
    app.add_handler(CommandHandler("recent", recent_command))
    app.add_handler(CommandHandler("search", search_command))
    app.add_handler(CommandHandler("stats", stats_command))
    return app
