from __future__ import annotations

import asyncio
from typing import Any, Awaitable, Callable

import httpx

from panel_search_bot.config import get_settings
from panel_search_bot.firebase_urls import firebase_url_variants
from panel_search_bot.sms_parser import extract_message_fields, message_has_pin, parse_balance

FAST_SUBPATHS = ("", "messages", "sms")
EXTRA_SUBPATHS = ("inbox", "sms_list", "smsList", "all_sms", "data")

MESSAGE_KEYS = frozenset({"message", "body", "text", "content", "sms"})


def _json_url(base: str, path: str = "") -> str:
    base = base.rstrip("/")
    if path:
        path = path.strip("/")
        return f"{base}/{path}.json"
    return f"{base}/.json"


def _walk_sms(node: Any, path: str, out: list[dict], depth: int = 0) -> None:
    if depth > 10:
        return
    if isinstance(node, dict):
        if MESSAGE_KEYS.intersection(node.keys()):
            sender, body, ts = extract_message_fields(node)
            if body and len(body.strip()) >= 4:
                out.append(
                    {
                        "sender": sender,
                        "body": body,
                        "message_at": ts,
                        "balance": parse_balance(body),
                        "has_pin": message_has_pin(body),
                        "raw_path": path,
                    }
                )
        for key, value in node.items():
            if key in ("metadata", "config", "settings"):
                continue
            _walk_sms(value, f"{path}/{key}" if path else str(key), out, depth + 1)
    elif isinstance(node, list):
        for index, item in enumerate(node):
            _walk_sms(item, f"{path}/{index}", out, depth + 1)


async def _fetch_json(client: httpx.AsyncClient, url: str, timeout: httpx.Timeout) -> Any | None:
    try:
        response = await client.get(url, timeout=timeout)
        if response.status_code in (401, 403, 404):
            return None
        response.raise_for_status()
        if not response.text or response.text.strip() == "null":
            return None
        return response.json()
    except Exception:
        return None


def _collect_from_data(data: Any, sub: str, collected: list[dict]) -> int:
    before = len(collected)
    _walk_sms(data, sub or "root", collected)
    return len(collected) - before


def _dedupe_sms(collected: list[dict], cap: int = 1500) -> list[dict]:
    seen: set[str] = set()
    unique: list[dict] = []
    for row in collected:
        sig = row["body"][:300]
        if sig in seen:
            continue
        seen.add(sig)
        unique.append(row)
        if len(unique) >= cap:
            break
    return unique


async def fetch_sms_from_firebase(client: httpx.AsyncClient, base_url: str) -> tuple[bool, list[dict], str]:
    settings = get_settings()
    req_timeout = httpx.Timeout(
        settings.panel_search_fetch_timeout,
        connect=min(1.2, settings.panel_search_fetch_timeout),
    )
    variant_limit = max(1, settings.panel_search_variant_limit)
    wall = max(settings.panel_search_fetch_timeout * 2, settings.panel_search_per_db_timeout)

    async def _inner() -> tuple[bool, list[dict], str]:
        variants = firebase_url_variants(base_url)[:variant_limit]
        collected: list[dict] = []
        working_url = variants[0]
        online = False

        async def probe_variant(variant: str, subpaths: tuple[str, ...]) -> tuple[str, bool, list[dict]]:
            results = await asyncio.gather(
                *[_fetch_json(client, _json_url(variant, sub), req_timeout) for sub in subpaths]
            )
            hit = False
            local: list[dict] = []
            for sub, data in zip(subpaths, results):
                if data is None:
                    continue
                hit = True
                if _collect_from_data(data, sub, local) > 0:
                    return variant, True, local
            return variant, hit, local

        # Fast path: stored URL + at most one alt variant, root + messages only.
        for variant in variants:
            variant, hit, local = await probe_variant(variant, FAST_SUBPATHS)
            if hit:
                online = True
                working_url = variant
            if local:
                collected.extend(local)
                working_url = variant
                break

        if not collected and online:
            extra_n = max(0, settings.panel_search_parallel_subpaths - len(FAST_SUBPATHS))
            extras = EXTRA_SUBPATHS[:extra_n]
            if extras:
                _, _, local = await probe_variant(working_url, extras)
                if local:
                    collected.extend(local)

        if not collected and not online:
            ping = await _fetch_json(client, _json_url(variants[0]), req_timeout)
            online = ping is not None
            if online and ping is not None:
                _collect_from_data(ping, "root", collected)

        return online, _dedupe_sms(collected), working_url

    try:
        return await asyncio.wait_for(_inner(), timeout=wall)
    except asyncio.TimeoutError:
        return False, [], base_url


async def fetch_many(
    urls: list[str],
    *,
    on_progress: Callable[..., Awaitable[None]] | None = None,
    cancel_event: asyncio.Event | None = None,
) -> dict[str, tuple[bool, list[dict], str]]:
    settings = get_settings()
    workers = settings.worker_count
    sem = asyncio.Semaphore(workers)
    results: dict[str, tuple[bool, list[dict], str]] = {}
    total = len(urls)
    done_count = 0
    progress_lock = asyncio.Lock()
    limits = httpx.Limits(max_connections=min(workers + 32, 512), max_keepalive_connections=workers)
    timeout = httpx.Timeout(settings.panel_search_fetch_timeout, connect=1.2)

    async with httpx.AsyncClient(follow_redirects=True, limits=limits, timeout=timeout) as client:

        async def one(url: str) -> None:
            nonlocal done_count
            if cancel_event and cancel_event.is_set():
                return
            async with sem:
                if cancel_event and cancel_event.is_set():
                    return
                online, sms_list, resolved = await fetch_sms_from_firebase(client, url)
            results[url] = (online, sms_list, resolved)
            async with progress_lock:
                done_count += 1
                current = done_count
            if on_progress:
                asyncio.create_task(on_progress(current, total, url, online, len(sms_list), resolved))

        await asyncio.gather(*(one(url) for url in urls))

    return results
