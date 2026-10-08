from __future__ import annotations

import asyncio

from telegram import InlineKeyboardMarkup, Message
from telegram.ext import ContextTypes

DEV_LINE = "DEV: @ifeelrichhh | Dynamo"


def progress_bar(filled: int, total: int = 8) -> str:
    filled = max(0, min(filled, total))
    return "🟩" * filled + "⬜" * (total - filled)


def holder_name_prompt(mobile: str, *, manual: bool = False) -> str:
    if manual:
        body = "👇 Type the **full name** exactly as printed on the card."
    else:
        body = "👇 Type the **full name** exactly as printed on the card."
    return (
        "📌 **STEP 2/4 — Holder Name**\n\n"
        f"{body}\n\n"
        f"📱 Mobile: `{mobile}`\n\n"
        "⭐ Cancel Anytime :- /cancel"
    )


def find_record_looking() -> str:
    return (
        "📌 **STEP 3/4 — Find Record**\n\n"
        "⌛ Looking up this record... Please wait.\n\n"
        "⭐ Cancel Anytime :- /cancel"
    )


def find_record_searching(mobile: str, filled: int) -> str:
    return (
        "📱 **STEP 3/4: Find Record**\n\n"
        "🔍 Searching database...\n\n"
        f"📞 `{mobile}`\n\n"
        f"{progress_bar(filled)}\n\n"
        f"{DEV_LINE}"
    )


def record_not_found_text() -> str:
    return f"❌ **Fail: No Records Found**\n\n{DEV_LINE}"


def is_record_missing_message(message: str) -> bool:
    m = message.lower()
    return any(
        x in m
        for x in (
            "no record",
            "not found",
            "nahi mila",
            "reject",
            "invalid",
            "fail",
            "no aadhaar",
        )
    )


async def animate_database_search(message: Message, mobile: str, *, min_steps: int = 3) -> None:
    await message.edit_text(find_record_looking(), parse_mode="Markdown")
    await asyncio.sleep(0.6)
    for i in range(1, min_steps + 1):
        await message.edit_text(find_record_searching(mobile, i), parse_mode="Markdown")
        await asyncio.sleep(0.45)


async def run_search_with_verify(
    message: Message,
    mobile: str,
    verify_coro,
) -> tuple[bool, object]:
    """Show Dynamo-style search animation while verify runs."""
    task = asyncio.create_task(verify_coro)
    await message.edit_text(find_record_looking(), parse_mode="Markdown")
    step = 0
    while not task.done():
        step = min(step + 1, 8)
        await message.edit_text(find_record_searching(mobile, step), parse_mode="Markdown")
        await asyncio.sleep(0.4)
    result = await task
    if step < 4:
        for i in range(step + 1, 5):
            await message.edit_text(find_record_searching(mobile, i), parse_mode="Markdown")
            await asyncio.sleep(0.25)
    return True, result
