from telegram import BotCommand


BOT_COMMANDS = [
    BotCommand("start", "Welcome & setup guide"),
    BotCommand("help", "User setup & controls"),
    BotCommand("guide", "Detailed guide"),
    BotCommand("key", "License KEY"),
    BotCommand("setfirebase", "Firebase connect"),
    BotCommand("allfirebase", "Bulk Firebase import"),
    BotCommand("fy", "Device find"),
    BotCommand("a", "Device find (KEY)"),
    BotCommand("mynum", "Inject target number"),
    BotCommand("addchannel", "Channel set"),
    BotCommand("startmonitor", "Monitoring ON"),
    BotCommand("stop", "Monitoring OFF"),
]


async def register_bot_commands(bot) -> None:
    await bot.set_my_commands(BOT_COMMANDS)
