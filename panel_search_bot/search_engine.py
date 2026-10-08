from __future__ import annotations

import asyncio
import time
from dataclasses import dataclass, field
from datetime import datetime

from sqlalchemy.orm import Session

from panel_search_bot.firebase_fetch import fetch_many
from panel_search_bot.models import CachedSms, FirebaseDb
from panel_search_bot.services import (
    load_cached_sms,
    match_keywords,
    update_firebase_status,
    upsert_cached_sms,
    within_days,
)


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


def _filter_row(
    sender: str,
    body: str,
    message_at: datetime | None,
    balance: float | None,
    has_pin: bool,
    params: SearchParams,
) -> bool:
    blob = f"{sender} {body}"
    if not match_keywords(blob, params.keywords):
        return False
    if not _pin_ok(has_pin, params.pin_filter):
        return False
    if not within_days(message_at, params.days):
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

    if params.mode in ("online", "both") and urls:

        async def progress(done, total, url, online, sms_count):
            row = url_to_row.get(url)
            if row:
                update_firebase_status(db, row.id, online)
            if on_progress:
                await on_progress(done, total, url, online, sms_count)

        live = await fetch_many(urls, on_progress=progress, cancel_event=cancel_event)
        result.dbs_scanned = len(urls)
        for url, (online, sms_list) in live.items():
            if online:
                result.dbs_online += 1
            row = url_to_row[url]
            if online and sms_list:
                upsert_cached_sms(db, row.id, row.url_normalized, sms_list)
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
                            message_at=item.get("message_at"),
                            balance=item.get("balance"),
                            has_pin=item.get("has_pin", False),
                            source="live",
                        )
                    )

    if params.mode in ("offline", "both"):
        ids = [row.id for row in firebase_rows]
        cached: list[CachedSms] = load_cached_sms(db, ids)
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
                        message_at=row.message_at,
                        balance=row.balance_value,
                        has_pin=row.has_pin,
                        source="cache",
                    )
                )

    # Dedupe live+cache in both mode
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
