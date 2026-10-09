from __future__ import annotations

import asyncio
import time
from typing import Any, Awaitable, Callable

from telegram import Message
from telegram.error import BadRequest

DEV_LINE = "DEV: @ifeelrichhh | Dynamo"

SEARCH_STATUSES = (
    "Connecting UIDAI gateway…",
    "Fetching secure captcha…",
    "Matching mobile + name…",
    "Querying Aadhaar database…",
    "Validating enrollment record…",
    "Preparing OTP dispatch…",
)


def _frame(title: str, body: str, *, footer: bool = True) -> str:
    lines = [
        "╭──────────────────────╮",
        f"│ {title}",
        "╰──────────────────────╯",
        "",
        body,
    ]
    if footer:
        lines.extend(["", DEV_LINE])
    return "\n".join(lines)


def progress_bar(filled: int, total: int = 10) -> str:
    filled = max(0, min(filled, total))
    return "▰" * filled + "▱" * (total - filled)


def step_header(step: int, total: int, label: str) -> str:
    return f"📌 **STEP {step}/{total} — {label}**"


def holder_name_prompt(mobile: str, *, manual: bool = False) -> str:
    hint = "Type the **full name** exactly as on the Aadhaar card."
    if manual:
        hint = "✏️ Manual entry — " + hint
    return (
        f"{step_header(2, 4, 'Holder Name')}\n\n"
        f"👇 {hint}\n\n"
        f"📱 Mobile · `{mobile}`"
        "\n\n⭐ Cancel anytime · /cancel"
    )


def find_record_searching(
    mobile: str,
    filled: int,
    *,
    status: str,
    name: str = "",
) -> str:
    bar = progress_bar(filled, 10)
    pct = min(100, int(filled / 10 * 100))
    name_line = f"👤 `{name}`\n" if name else ""
    body = (
        f"🔍 **Database search**\n\n"
        f"📞 `{mobile}`\n"
        f"{name_line}\n"
        f"`{bar}`  {pct}%\n\n"
        f"⏳ _{status}_"
    )
    return _frame("STEP 3/4 · FIND RECORD", body)


def find_record_otp_pending(mobile: str, name: str) -> str:
    body = (
        "✅ **Record matched**\n\n"
        f"📞 `{mobile}`\n"
        f"👤 **{name}**\n\n"
        "📨 Sending **OTP 1** to registered mobile…"
    )
    return _frame("STEP 3/4 · OTP DISPATCH", body)


def record_not_found_text() -> str:
    body = "❌ **No records found**\n\nMobile + name UIDAI se match nahi hue."
    return _frame("SEARCH FAILED", body)


def bridge_down_text(detail: str) -> str:
    body = (
        "❌ **UIDAI bridge offline**\n\n"
        f"{detail}\n\n"
        "VPS par bridge chalu karo: `./start_uidai_bridge.sh`"
    )
    return _frame("CONNECTION ERROR", body)


def verify_timeout_text(seconds: int) -> str:
    body = (
        f"⏱ UIDAI ne **{seconds}s** me jawab nahi diya.\n\n"
        "India VPS + bridge check karo, phir dubara try karo."
    )
    return _frame("TIMEOUT", body)


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
    verify_coro: Awaitable[Any],
    *,
    name: str = "",
    timeout_sec: float = 150.0,
) -> tuple[bool, Any]:
    """Dynamo-style search animation while UIDAI verify runs (never freeze silently)."""
    task = asyncio.create_task(asyncio.wait_for(verify_coro, timeout=timeout_sec))
    step = 0
    last_text = ""
    t0 = time.monotonic()
    pulse = 0

    while not task.done():
        elapsed = time.monotonic() - t0
        step = min(int(elapsed / 1.2) + 1, 10)
        if step >= 10:
            pulse = (pulse + 1) % 2
            display_step = 9 + pulse
        else:
            display_step = step
        status_idx = int(elapsed / 4) % len(SEARCH_STATUSES)
        status = SEARCH_STATUSES[status_idx]
        if elapsed > 45:
            status = f"{status} (UIDAI slow — wait karo…)"
        text = find_record_searching(mobile, display_step, status=status, name=name)
        if text != last_text:
            await safe_edit(message, text, parse_mode="Markdown")
            last_text = text
        await asyncio.sleep(0.45)

    try:
        result = task.result()
    except asyncio.TimeoutError:
        return False, None
    except Exception as e:
        return False, e

    for i in range(step, 11):
        text = find_record_searching(
            mobile, min(i, 10), status="Finalizing match…", name=name
        )
        await safe_edit(message, text, parse_mode="Markdown")
        await asyncio.sleep(0.12)

    return True, result
