from __future__ import annotations

import asyncio

from telegram import Message
from telegram.error import BadRequest

DEV_LINE = "DEV: @ifeelrichhh | Dynamo"


def progress_bar(filled: int, total: int = 8) -> str:
    filled = max(0, min(filled, total))
    return "🟩" * filled + "⬜" * (total - filled)


def holder_name_prompt(mobile: str, *, manual: bool = False) -> str:
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


async def safe_edit(message: Message, text: str, **kwargs) -> None:
    """Ignore Telegram 'message is not modified' (same edit twice)."""
    try:
        await message.edit_text(text, **kwargs)
    except BadRequest as e:
        if "message is not modified" in str(e).lower():
            return
        raise


async def run_search_with_verify(
    message: Message,
    mobile: str,
    verify_coro,
) -> tuple[bool, object]:
    """Dynamo-style search animation while UIDAI verify runs."""
    task = asyncio.create_task(verify_coro)
    step = 0
    last_step = -1

    while not task.done():
        step = min(step + 1, 8)
        if step != last_step:
            await safe_edit(message, find_record_searching(mobile, step), parse_mode="Markdown")
            last_step = step
        await asyncio.sleep(0.35)

    result = await task

    for i in range(last_step + 1, 5):
        await safe_edit(message, find_record_searching(mobile, i), parse_mode="Markdown")
        await asyncio.sleep(0.2)

    return True, result
