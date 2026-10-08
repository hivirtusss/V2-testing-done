from panel_search_bot.search_engine import SearchParams


def mode_label(mode: str) -> str:
    return {"online": "🟢 Online", "offline": "⚫ Offline", "both": "🔄 Both"}.get(mode, mode)


def sort_label(sort: str) -> str:
    return {
        "high": "💰 High → Low",
        "low": "💰 Low → High",
        "skip": "⏭ date order",
    }.get(sort, sort)


def pin_label(pin: str) -> str:
    return {"with": "🔑 With PIN", "without": "🚫 Without PIN", "both": "🔄 Both"}.get(pin, pin)


def days_label(days: int | None) -> str:
    if days is None:
        return "∞ All Time"
    return f"📅 Last {days} days"


def search_summary(params: SearchParams, matches: int, elapsed: float, size_kb: int | None = None) -> str:
    kw = ", ".join(params.keywords)
    parts = [
        f"✅ Done! {kw}",
        mode_label(params.mode),
        pin_label(params.pin_filter),
        sort_label(params.balance_sort),
        days_label(params.days),
    ]
    head = " | ".join(parts)
    tail = f"📊 {matches} matches in {elapsed:.0f}s"
    if size_kb is not None:
        tail += f"\n📄 {size_kb}KB"
    return f"{head}\n{tail}"


def search_footer(params: SearchParams, matches: int, elapsed: float, size_kb: int) -> str:
    kw = ", ".join(params.keywords)
    return (
        f"✅ {matches} matches | {kw} | {mode_label(params.mode)} | "
        f"{pin_label(params.pin_filter)} | {sort_label(params.balance_sort)} | "
        f"{days_label(params.days)} | ⏱️ {elapsed:.0f}s | 📄 {size_kb}KB"
    )
