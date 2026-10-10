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
    firebase_ids_with_cache,
    load_cached_sms,
    load_cached_sms_for_keywords,
    match_keywords,
    update_firebase_status,
    upsert_cached_sms,
    wants_bank_filter,
    within_days,
)
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


def _finalize_search(
    firebase_rows: list[FirebaseDb],
    params: SearchParams,
    live: dict[str, tuple[bool, list[dict], str]],
    skipped_cached: set[str],
) -> SearchResult:
    db = SessionLocal()
    started = time.time()
    matches: list[SearchMatch] = []
    url_to_row = {row.url_normalized: row for row in firebase_rows}
    urls = list(url_to_row.keys())
    result = SearchResult(dbs_scanned=len(urls))

    try:
        if params.mode in ("online", "both") and urls:
            for url, (online, sms_list, _resolved) in live.items():
                if online:
                    result.dbs_online += 1
                row = url_to_row.get(url)
                if not row:
                    continue
                if online and sms_list:
                    upsert_cached_sms(db, row.id, row.url_normalized, sms_list)
                update_firebase_status(db, row.id, online)
                for item in sms_list:
                    if _filter_row(
                        item.get("sender", ""),
                        item.get("body", ""),
                        item.get("message_at"),
                        item.get("balance"),
                        item.get("has_pin", False),
                        params,
                    ):
                        matches.append(
                            SearchMatch(
                                firebase_url=url,
                                sender=item.get("sender", ""),
                                body=item.get("body", ""),
                                message_at=effective_message_at(
                                    item.get("message_at"), item.get("body", "")
                                ),
                                balance=item.get("balance"),
                                has_pin=item.get("has_pin", False),
                                source="live",
                            )
                        )

            if params.mode == "online" and skipped_cached:
                skip_ids = [url_to_row[u].id for u in skipped_cached if u in url_to_row]
                for row in load_cached_sms_for_keywords(db, skip_ids, params.keywords):
                    fb = db.query(FirebaseDb).filter(FirebaseDb.id == row.firebase_db_id).first()
                    url = fb.url_normalized if fb else "unknown"
                    if _filter_row(
                        row.sender, row.body, row.message_at, row.balance_value, row.has_pin, params
                    ):
                        matches.append(
                            SearchMatch(
                                firebase_url=url,
                                sender=row.sender,
                                body=row.body,
                                message_at=effective_message_at(row.message_at, row.body),
                                balance=row.balance_value,
                                has_pin=row.has_pin,
                                source="cache",
                            )
                        )

        if params.mode in ("offline", "both"):
            ids = [row.id for row in firebase_rows]
            if params.mode == "both":
                cache_ids = list(firebase_ids_with_cache(db, ids))
                cached = load_cached_sms_for_keywords(db, cache_ids, params.keywords)
            else:
                cached = load_cached_sms_for_keywords(db, ids, params.keywords)
            if params.mode == "offline":
                result.dbs_scanned = len(firebase_rows)
            for row in cached:
                fb = db.query(FirebaseDb).filter(FirebaseDb.id == row.firebase_db_id).first()
                url = fb.url_normalized if fb else "unknown"
                if _filter_row(row.sender, row.body, row.message_at, row.balance_value, row.has_pin, params):
                    matches.append(
                        SearchMatch(
                            firebase_url=url,
                            sender=row.sender,
                            body=row.body,
                            message_at=effective_message_at(row.message_at, row.body),
                            balance=row.balance_value,
                            has_pin=row.has_pin,
                            source="cache",
                        )
                    )

        if params.mode == "both":
            seen: set[tuple] = set()
            unique: list[SearchMatch] = []
            for m in matches:
                key = (m.firebase_url, m.body[:200], m.message_at)
                if key in seen:
                    continue
                seen.add(key)
                unique.append(m)
            matches = unique

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
    skipped_n = 0

    def _cached_ids() -> set[int]:
        session = SessionLocal()
        try:
            return firebase_ids_with_cache(session, [row.id for row in firebase_rows])
        finally:
            session.close()

    # Cached DBs hold most SMS; skipping live is OK for both/offline (cache pass runs below).
    # For online-only + day filter, still skip live on cache — dates are often missing in cache anyway.
    if settings.panel_search_skip_live_if_cached:
        cached_ids = await asyncio.to_thread(_cached_ids)
        if cached_ids:
            fetch_urls = [u for u in urls if url_to_row[u].id not in cached_ids]
            skipped_cached = {u for u in urls if u not in fetch_urls}
            skipped_n = len(skipped_cached)

    live_total = len(fetch_urls)
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
            await on_progress(skipped_n + done, len(urls), url, online, sms_count, resolved)

    if params.mode == "both" and settings.panel_search_both_skip_uncached_live:
        fetch_urls = []
        skipped_n = len(urls)

    live: dict[str, tuple[bool, list[dict], str]] = {}
    if fetch_urls:
        if cancel_event and cancel_event.is_set():
            return SearchResult()
        live = await fetch_many(fetch_urls, on_progress=progress, cancel_event=cancel_event)

    if cancel_event and cancel_event.is_set():
        return SearchResult(elapsed_sec=time.time() - started)

    if on_progress:
        await on_progress(len(urls), len(urls), "finalize", True, 0, "Matching & saving…")

    result = await asyncio.to_thread(_finalize_search, firebase_rows, params, live, skipped_cached)
    result.elapsed_sec = time.time() - started
    return result
