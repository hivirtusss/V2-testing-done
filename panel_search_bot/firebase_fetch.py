from __future__ import annotations

import asyncio
from typing import Any, Awaitable, Callable

import httpx

from panel_search_bot.config import get_settings
from panel_search_bot.firebase_urls import device_id_from_raw_path, firebase_url_variants
from panel_search_bot.sms_parser import (
    extract_message_fields,
    is_spam_sms,
    message_has_pin,
    parse_balance,
)

# Most panels store SMS under these — try first and stop early when data is found.
SMS_SUBPATHS_PRIORITY = (
    "messages",
    "sms",
    "devices",
    "device",
    "inbox",
    "sms_list",
    "smsList",
    "all_sms",
    "allSms",
    "",
    "data",
    "logs",
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


def _walk_sms(
    node: Any,
    path: str,
    out: list[dict],
    depth: int = 0,
    *,
    max_items: int | None = None,
) -> bool:
    if max_items is not None and len(out) >= max_items:
        return True
    if depth > 12:
        return False
    if isinstance(node, dict):
        if MESSAGE_KEYS.intersection(node.keys()):
            sender, body, ts = extract_message_fields(node)
            if body and len(body.strip()) >= 4 and not is_spam_sms(body, sender):
                out.append(
                    {
                        "sender": sender,
                        "body": body,
                        "message_at": ts,
                        "balance": parse_balance(body),
                        "has_pin": message_has_pin(body),
                        "raw_path": path,
                        "device_id": device_id_from_raw_path(path),
                    }
                )
                if max_items is not None and len(out) >= max_items:
                    return True
        for key, value in node.items():
            if key in ("metadata", "config", "settings"):
                continue
            if _walk_sms(value, f"{path}/{key}" if path else str(key), out, depth + 1, max_items=max_items):
                return True
    elif isinstance(node, list):
        for index, item in enumerate(node):
            if _walk_sms(item, f"{path}/{index}", out, depth + 1, max_items=max_items):
                return True
    return False


async def _fetch_json(
    client: httpx.AsyncClient,
    url: str,
    timeout: float,
    *,
    max_bytes: int | None = None,
) -> Any | None:
    try:
        response = await client.get(url, timeout=timeout)
        if response.status_code in (401, 403, 404):
            return None
        response.raise_for_status()
        raw = response.content
        if max_bytes and len(raw) > max_bytes:
            return None
        if not raw or raw.strip() == b"null":
            return None
        return response.json()
    except Exception:
        return None


async def _fetch_subpath(
    client: httpx.AsyncClient,
    variant: str,
    sub: str,
    timeout: float,
    max_bytes: int,
) -> tuple[str, Any | None]:
    data = await _fetch_json(client, _json_url(variant, sub), timeout, max_bytes=max_bytes)
    return sub, data


async def fetch_sms_from_firebase(client: httpx.AsyncClient, base_url: str) -> tuple[bool, list[dict], str]:
    settings = get_settings()
    timeout = settings.panel_search_fetch_timeout
    max_sms = settings.panel_search_max_sms_per_db
    max_bytes = settings.panel_search_max_fetch_bytes
    collected: list[dict] = []
    working_url = base_url
    variants = firebase_url_variants(base_url)[: max(1, settings.panel_search_max_url_variants)]

    def cap_walk(data: Any, path: str) -> None:
        _walk_sms(data, path, collected, max_items=max_sms)

    for variant in variants:
        variant_ok = False
        shallow = await _fetch_json(
            client,
            _json_url(variant) + "?shallow=true",
            min(timeout, 6.0),
            max_bytes=max_bytes,
        )
        subpaths: list[str] = list(SMS_SUBPATHS_PRIORITY)
        if isinstance(shallow, dict) and shallow:
            extra = [k for k in shallow.keys() if k not in ("metadata", "config", "settings")]
            subpaths = extra[:10] + [s for s in subpaths if s not in extra]

        hot = [s for s in ("messages", "sms", "devices", "device") if s in subpaths or not subpaths]
        if hot:
            probes = await asyncio.gather(
                *[_fetch_subpath(client, variant, sub, timeout, max_bytes) for sub in hot[:4]]
            )
            for sub, data in probes:
                if data is None:
                    continue
                variant_ok = True
                working_url = variant
                before = len(collected)
                cap_walk(data, sub or "root")
                if len(collected) > before:
                    break
        for sub in subpaths:
            if len(collected) >= max_sms:
                break
            if sub in ("messages", "sms", "devices", "device"):
                continue
            data = await _fetch_json(client, _json_url(variant, sub), timeout, max_bytes=max_bytes)
            if data is None:
                continue
            variant_ok = True
            working_url = variant
            before = len(collected)
            cap_walk(data, sub or "root")
            if len(collected) > before and sub in ("inbox", ""):
                break
        if collected:
            break
        if variant_ok and not collected:
            data = await _fetch_json(client, _json_url(variant), timeout, max_bytes=max_bytes)
            if data is not None:
                cap_walk(data, "root")
                working_url = variant
                if collected:
                    break

    if not collected:
        for variant in variants:
            shallow = await _fetch_json(
                client,
                _json_url(variant) + "?shallow=true",
                min(timeout, 6.0),
                max_bytes=max_bytes,
            )
            if not isinstance(shallow, dict):
                continue
            for key in list(shallow.keys())[:8]:
                if key in ("metadata", "config", "settings"):
                    continue
                if len(collected) >= max_sms:
                    break
                data = await _fetch_json(client, _json_url(variant, key), timeout, max_bytes=max_bytes)
                if data is not None:
                    cap_walk(data, key)
            if collected:
                working_url = variant
                break

    online = bool(collected)
    if not online:
        for variant in variants:
            if await _fetch_json(client, _json_url(variant), min(timeout, 5.0), max_bytes=256_000) is not None:
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
    skip_urls: set[str] | None = None,
    progress_total: int | None = None,
) -> dict[str, tuple[bool, list[dict], str]]:
    settings = get_settings()
    workers = settings.worker_count
    sem = asyncio.Semaphore(workers)
    results: dict[str, tuple[bool, list[dict], str]] = {}
    skip_urls = skip_urls or set()
    total = progress_total if progress_total is not None else len(urls)
    limits = httpx.Limits(
        max_connections=min(workers + 32, 288),
        max_keepalive_connections=min(workers + 16, 256),
    )
    done_counter = {"n": 0}

    async with httpx.AsyncClient(follow_redirects=True, limits=limits) as client:

        url_timeout = settings.panel_search_url_timeout

        async def one(url: str) -> None:
            if cancel_event and cancel_event.is_set():
                return
            if url in skip_urls:
                results[url] = (True, [], url)
                done_counter["n"] += 1
                if on_progress:
                    await on_progress(
                        done_counter["n"],
                        total,
                        url,
                        True,
                        0,
                        "cached (skip live)",
                    )
                return
            async with sem:
                if cancel_event and cancel_event.is_set():
                    return
                try:
                    online, sms_list, resolved = await asyncio.wait_for(
                        fetch_sms_from_firebase(client, url),
                        timeout=url_timeout,
                    )
                except asyncio.TimeoutError:
                    online, sms_list, resolved = False, [], url
                results[url] = (online, sms_list, resolved)
                done_counter["n"] += 1
                if on_progress:
                    await on_progress(
                        done_counter["n"],
                        total,
                        url,
                        online,
                        len(sms_list),
                        resolved,
                    )

        await asyncio.gather(*(one(url) for url in urls))

    return results
