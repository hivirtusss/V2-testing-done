from __future__ import annotations

import asyncio
from datetime import datetime
from typing import Any, Awaitable, Callable

import httpx

from panel_search_bot.config import get_settings
from panel_search_bot.sms_parser import extract_message_fields, looks_like_sms, message_has_pin, parse_balance

SMS_PATH_HINTS = (
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


def _json_url(base: str, path: str = "") -> str:
    base = base.rstrip("/")
    if path:
        path = path.strip("/")
        return f"{base}/{path}.json"
    return f"{base}/.json"


def _walk_sms(node: Any, path: str, out: list[dict]) -> None:
    if isinstance(node, dict):
        if looks_like_sms(node):
            sender, body, ts = extract_message_fields(node)
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
            return
        for key, value in node.items():
            _walk_sms(value, f"{path}/{key}" if path else str(key), out)
    elif isinstance(node, list):
        for index, item in enumerate(node):
            _walk_sms(item, f"{path}/{index}", out)


async def check_online(client: httpx.AsyncClient, base_url: str) -> bool:
    try:
        response = await client.get(_json_url(base_url), timeout=get_settings().panel_search_fetch_timeout)
        if response.status_code == 401:
            return False
        response.raise_for_status()
        return True
    except Exception:
        return False


async def fetch_sms_from_firebase(client: httpx.AsyncClient, base_url: str) -> tuple[bool, list[dict]]:
    settings = get_settings()
    timeout = settings.panel_search_fetch_timeout
    try:
        response = await client.get(_json_url(base_url), timeout=timeout)
        if response.status_code in (401, 403):
            return False, []
        response.raise_for_status()
        root = response.json()
    except Exception:
        return False, []

    if root is None:
        return True, []

    collected: list[dict] = []
    if isinstance(root, dict):
        # Try common top-level paths first (faster)
        for hint in SMS_PATH_HINTS:
            if hint in root:
                _walk_sms(root[hint], hint, collected)
        if not collected:
            _walk_sms(root, "", collected)
    else:
        _walk_sms(root, "", collected)

    return True, collected


async def fetch_many(
    urls: list[str],
    *,
    on_progress: Callable[..., Awaitable[None]] | None = None,
    cancel_event: asyncio.Event | None = None,
) -> dict[str, tuple[bool, list[dict]]]:
    settings = get_settings()
    sem = asyncio.Semaphore(settings.panel_search_concurrency)
    results: dict[str, tuple[bool, list[dict]]] = {}
    total = len(urls)

    async with httpx.AsyncClient(follow_redirects=True) as client:

        async def one(url: str, index: int) -> None:
            if cancel_event and cancel_event.is_set():
                return
            async with sem:
                if cancel_event and cancel_event.is_set():
                    return
                online, sms_list = await fetch_sms_from_firebase(client, url)
                results[url] = (online, sms_list)
                if on_progress:
                    await on_progress(index + 1, total, url, online, len(sms_list))

        await asyncio.gather(*(one(url, i) for i, url in enumerate(urls)))

    return results
