from panel_search_bot.search_engine import SearchParams


def mode_label(mode: str) -> str:
    return {"online": "🟢 Online", "offline": "⚫ Offline", "both": "🔄 Both"}.get(mode, mode)


def sort_label(sort: str) -> str:
    return {
        "high": "💰 High→Low",
        "low": "💰 Low→High",
        "skip": "⏭ date order",
    }.get(sort, sort)


def sort_label_long(sort: str) -> str:
    return {
        "high": "💰 High→Low (70K–1Cr)",
        "low": "💰 Low→High (1K+)",
        "skip": "⏭ date order",
    }.get(sort, sort)


def pin_label(pin: str) -> str:
    return {
        "with": "🔑 With PIN only",
        "without": "🚫 Without PIN only",
        "both": "🔄 Both (mix)",
    }.get(pin, pin)


def days_label(days: int | None) -> str:
    if days is None:
        return "🌐 ∞ ALL TIME"
    return f"📅 Last {days} days"


def days_label_short(days: int | None) -> str:
    if days is None:
        return "∞ All Time"
    return f"Last {days} days"


def confirm_panel_text(flow: dict) -> str:
    kw = ", ".join(f"'{k}'" for k in (flow.get("keywords") or []))
    kw_plain = ", ".join(flow.get("keywords") or [])
    mode = flow.get("mode", "online")
    pin = flow.get("pin_filter", "both")
    sort = flow.get("balance_sort", "high")
    days = flow.get("days")

    return (
        "┌────────────────────────────\n"
        f"│ Keywords: {kw_plain}\n"
        f"│ Mode: {mode_label(mode)}\n"
        f"│ PIN: {pin_label(pin)}\n"
        f"│ Balance: {sort_label(sort)}\n"
        f"│ Days: {days_label(days)}\n"
        "└────────────────────────────\n\n"
        f"Matlab: {kw} wali bank SMS (credit/debit/avl/sent/received) — "
        f"spam/OTP/FASTag skip.\n"
        f"{mode_label(mode)} | {pin_label(pin)} | {sort_label(sort)} | {days_label(days)}\n\n"
        "✅ Start search?"
    )


def search_start_line(params: SearchParams) -> str:
    kw = ", ".join(params.keywords)
    return (
        f"🔍 Search shuru! {kw} | {mode_label(params.mode)} | "
        f"{pin_label(params.pin_filter)} | {sort_label(params.balance_sort)} | "
        f"{days_label(params.days)}"
    )


def search_summary(params: SearchParams, matches: int, elapsed: float, size_kb: int | None = None) -> str:
    kw = ", ".join(params.keywords)
    parts = [
        f"✅ Done! {kw}",
        mode_label(params.mode),
        pin_label(params.pin_filter),
        sort_label(params.balance_sort),
        days_label_short(params.days),
    ]
    head = " | ".join(parts)
    tail = f"📊 {matches} matches in {elapsed:.0f}s"
    if size_kb is not None:
        tail += f"\n📄 File sent above ☝️"
    return f"{head}\n{tail}"


def search_footer(params: SearchParams, matches: int, elapsed: float, size_kb: int) -> str:
    kw = ", ".join(params.keywords)
    return (
        f"✅ {matches} matches | {kw} | {mode_label(params.mode)} | "
        f"{pin_label(params.pin_filter)} | {sort_label(params.balance_sort)} | "
        f"{days_label_short(params.days)} | ⏱️ {elapsed:.0f}s | 📄 {size_kb}KB"
    )
