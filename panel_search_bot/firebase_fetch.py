from __future__ import annotations

import asyncio
from typing import Any, Awaitable, Callable

import httpx

from panel_search_bot.config import get_settings
from panel_search_bot.firebase_urls import firebase_url_variants
from panel_search_bot.sms_parser import extract_message_fields, message_has_pin, parse_balance

SMS_SUBPATHS = (
    "",
    "messages",
    "sms",
    "inbox",
    "sms_list",
    "smsList",
    "all_sms",
    "allSms",
    "logs",
    "data",
    "devices",
    "device",
    "clients",
    "users",
    "phones",
)

MESSAGE_KEYS = frozenset({"message", "body", "text", "content", "sms"})


def _json_url(base: str, path: str = "") -> str:
    base = base.rstrip("/")
    if path:
        path = path.strip("/")
        return f"{base}/{path}.json"
    return f"{base}/.json"


def _walk_sms(node: Any, path: str, out: list[dict], depth: int = 0) -> None:
    if depth > 14:
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


async def _fetch_json(client: httpx.AsyncClient, url: str, timeout: float) -> Any | None:
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


async def fetch_sms_from_firebase(client: httpx.AsyncClient, base_url: str) -> tuple[bool, list[dict], str]:
    settings = get_settings()
    timeout = settings.panel_search_fetch_timeout
    collected: list[dict] = []
    working_url = base_url

    for variant in firebase_url_variants(base_url):
        variant_ok = False
        for sub in SMS_SUBPATHS:
            data = await _fetch_json(client, _json_url(variant, sub), timeout)
            if data is None:
                continue
            variant_ok = True
            before = len(collected)
            _walk_sms(data, sub or "root", collected)
            if len(collected) > before and sub:
                working_url = variant
        if variant_ok and collected:
            working_url = variant
            break
        if variant_ok and not collected:
            # Full tree at root
            data = await _fetch_json(client, _json_url(variant), timeout)
            if data is not None:
                _walk_sms(data, "root", collected)
                working_url = variant
                if collected:
                    break

    if not collected:
        # Last resort shallow keys then fetch child
        for variant in firebase_url_variants(base_url):
            shallow = await _fetch_json(client, _json_url(variant) + "?shallow=true", timeout)
            if not isinstance(shallow, dict):
                continue
            for key in list(shallow.keys())[:12]:
                if key in ("metadata", "config"):
                    continue
                data = await _fetch_json(client, _json_url(variant, key), timeout)
                if data is not None:
                    _walk_sms(data, key, collected)
            if collected:
                working_url = variant
                break

    online = bool(collected)
    if not online:
        for variant in firebase_url_variants(base_url)[:4]:
            if await _fetch_json(client, _json_url(variant), timeout) is not None:
                online = True
                working_url = variant
                break
    # Dedupe bodies
    seen: set[str] = set()
    unique: list[dict] = []
    for row in collected:
        sig = row["body"][:300]
        if sig in seen:
            continue
        seen.add(sig)
        unique.append(row)

    return online, unique, working_url


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
    limits = httpx.Limits(max_connections=workers + 5, max_keepalive_connections=workers)

    async with httpx.AsyncClient(follow_redirects=True, limits=limits) as client:

        async def one(url: str, index: int) -> None:
            if cancel_event and cancel_event.is_set():
                return
            async with sem:
                if cancel_event and cancel_event.is_set():
                    return
                online, sms_list, resolved = await fetch_sms_from_firebase(client, url)
                results[url] = (online, sms_list, resolved)
                if on_progress:
                    await on_progress(index + 1, total, url, online, len(sms_list), resolved)

        await asyncio.gather(*(one(url, i) for i, url in enumerate(urls)))

    return results
