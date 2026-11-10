#!/usr/bin/env python3
"""Scan firebase pool: device counts, online, PIN yes/no (sample). Output CSV + JSON."""

from __future__ import annotations

import argparse
import asyncio
import csv
import json
import re
from dataclasses import asdict, dataclass
from pathlib import Path

import httpx

from urllib.parse import urlparse

DEVICE_COLLECTION_SUFFIXES = frozenset({"clients", "devices", "device", "users", "phones"})


def normalize_firebase_url(url: str) -> str:
    cleaned = url.strip().rstrip("/")
    while cleaned.endswith("-"):
        cleaned = cleaned[:-1]
    if not cleaned.startswith(("http://", "https://")):
        cleaned = f"https://{cleaned}"
    return cleaned


def firebase_root_url(url: str) -> str:
    normalized = normalize_firebase_url(url)
    parsed = urlparse(normalized)
    parts = [p for p in parsed.path.strip("/").split("/") if p]
    if parts and parts[-1].lower() in DEVICE_COLLECTION_SUFFIXES:
        parts = parts[:-1]
    path = "/".join(parts)
    base = f"{parsed.scheme}://{parsed.netloc}"
    return f"{base}/{path}".rstrip("/") if path else base

PIN_RE = re.compile(
    r"(?:upi\s*pin|mpin|m[- ]?pin|atm\s*pin|pin\s*set|your\s+pin\s+is)\s*(?:is|[:=\-])?\s*([0-9]{4,6})\b",
    re.IGNORECASE,
)
DEVICE_COLLECTIONS = ("clients", "devices", "device", "users", "phones")


@dataclass
class ScanRow:
    url: str
    auth_key: str
    has_auth: bool
    reachable: bool
    auth_ok: bool
    error: str | None
    clients_count: int
    devices_count: int
    total_devices: int
    online_devices: int
    pin_devices_sample: int
    no_pin_devices_sample: int


def load_panels(path: Path) -> list[tuple[str, str]]:
    panels: list[tuple[str, str]] = []
    for line in path.read_text(encoding="utf-8", errors="ignore").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "|" in line:
            url, key = line.split("|", 1)
            panels.append((url.strip(), key.strip()))
        else:
            panels.append((line, ""))
    return panels


def auth_query(secret: str) -> str:
    from urllib.parse import quote

    if not secret:
        return ""
    return f"?auth={quote(secret, safe='')}"


async def fetch_json(
    client: httpx.AsyncClient,
    url: str,
    *,
    timeout: float,
) -> tuple[dict | list | None, int | str]:
    try:
        r = await client.get(url, timeout=timeout)
        if r.status_code == 401 or r.status_code == 403:
            return None, r.status_code
        if r.status_code >= 400:
            return None, r.status_code
        if not r.text or r.text.strip() in ("null", "None"):
            return None, r.status_code
        return r.json(), r.status_code
    except Exception as exc:
        return None, str(exc)


async def shallow_count(client: httpx.AsyncClient, base: str, coll: str, secret: str, timeout: float) -> int:
    from urllib.parse import quote

    qs = "?shallow=true"
    if secret:
        qs += f"&auth={quote(secret, safe='')}"
    data, _ = await fetch_json(client, f"{base}/{coll}.json{qs}", timeout=timeout)
    if isinstance(data, dict):
        return len(data)
    return 0


async def sample_online_pin(
    client: httpx.AsyncClient,
    base: str,
    coll: str,
    keys: list[str],
    secret: str,
    timeout: float,
) -> tuple[int, int, int]:
    online = 0
    pin_yes = 0
    pin_no = 0
    aq = auth_query(secret)

    for key in keys[:40]:
        data, _ = await fetch_json(client, f"{base}/{coll}/{key}.json{aq}", timeout=timeout)
        if not isinstance(data, dict):
            continue
        if data.get("online") is True or str(data.get("status")).lower() in {"true", "online", "1"}:
            online += 1
        blob = json.dumps(data)[:8000]
        if PIN_RE.search(blob):
            pin_yes += 1
        else:
            pin_no += 1
    return online, pin_yes, pin_no


async def scan_one(
    client: httpx.AsyncClient,
    url: str,
    auth_key: str,
    timeout: float,
) -> ScanRow:
    try:
        base = firebase_root_url(normalize_firebase_url(url))
    except ValueError as exc:
        return ScanRow(url, auth_key, bool(auth_key), False, False, str(exc), 0, 0, 0, 0, 0, 0)

    secret = auth_key.strip()
    clients_n = await shallow_count(client, base, "clients", secret, timeout)
    devices_n = await shallow_count(client, base, "devices", secret, timeout)
    reachable = clients_n > 0 or devices_n > 0
    auth_ok = reachable

    if not reachable and secret:
        clients_n = await shallow_count(client, base, "clients", "", timeout)
        devices_n = await shallow_count(client, base, "devices", "", timeout)
        reachable = clients_n > 0 or devices_n > 0
        auth_ok = False

    if not reachable:
        root_data, status = await fetch_json(client, f"{base}/.json{auth_query(secret)}", timeout=timeout)
        reachable = isinstance(root_data, dict) and bool(root_data)
        if reachable and secret and status == 200:
            auth_ok = True

    total = max(clients_n, devices_n, clients_n + devices_n if clients_n and devices_n else 0)
    if clients_n and devices_n:
        total = max(clients_n, devices_n)

    online = pin_y = pin_n = 0
    coll = "clients" if clients_n >= devices_n else "devices"
    count = clients_n if coll == "clients" else devices_n
    use_secret = secret if auth_ok else (secret if not reachable else "")
    if count > 0:
        aq = auth_query(use_secret)
        keys_data, _ = await fetch_json(client, f"{base}/{coll}.json?shallow=true{aq[1:]}", timeout=timeout)
        if isinstance(keys_data, dict):
            keys = list(keys_data.keys())
            online, pin_y, pin_n = await sample_online_pin(client, base, coll, keys, use_secret, timeout)

    err = None if reachable else "empty_or_denied"

    return ScanRow(
        url=base,
        auth_key=secret[:32] + ("…" if len(secret) > 32 else ""),
        has_auth=bool(secret),
        reachable=reachable,
        auth_ok=auth_ok and bool(secret),
        error=err,
        clients_count=clients_n,
        devices_count=devices_n,
        total_devices=total,
        online_devices=online,
        pin_devices_sample=pin_y,
        no_pin_devices_sample=pin_n,
    )


async def run_scan(
    panels: list[tuple[str, str]],
    *,
    workers: int,
    timeout: float,
) -> list[ScanRow]:
    sem = asyncio.Semaphore(workers)
    rows: list[ScanRow] = []

    async with httpx.AsyncClient(follow_redirects=True) as client:

        async def one(panel: tuple[str, str]) -> None:
            async with sem:
                rows.append(await scan_one(client, panel[0], panel[1], timeout))

        await asyncio.gather(*(one(p) for p in panels))

    return rows


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--auth-file", type=Path, default=Path("data/firebase_pool_auth.txt"))
    ap.add_argument("--out-json", type=Path, default=Path("data/firebase_pool_scan.json"))
    ap.add_argument("--out-csv", type=Path, default=Path("data/firebase_pool_scan.csv"))
    ap.add_argument("--workers", type=int, default=48)
    ap.add_argument("--timeout", type=float, default=12.0)
    ap.add_argument("--min-devices", type=int, default=0)
    ap.add_argument("--max-devices", type=int, default=0, help="0 = no max")
    args = ap.parse_args()

    panels = load_panels(args.auth_file)
    print(f"scanning {len(panels)} firebase panels…", flush=True)
    rows = asyncio.run(run_scan(panels, workers=args.workers, timeout=args.timeout))

    if args.min_devices > 0:
        rows = [r for r in rows if r.total_devices >= args.min_devices]
    if args.max_devices > 0:
        rows = [r for r in rows if r.total_devices <= args.max_devices]

    reachable = [r for r in rows if r.reachable]
    rows.sort(key=lambda r: r.total_devices, reverse=True)

    args.out_json.parent.mkdir(parents=True, exist_ok=True)
    args.out_json.write_text(
        json.dumps([asdict(r) for r in rows], indent=2),
        encoding="utf-8",
    )

    with args.out_csv.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(asdict(rows[0]).keys()) if rows else [])
        if rows:
            w.writeheader()
            for r in rows:
                w.writerow(asdict(r))

    total_devices = sum(r.total_devices for r in reachable)
    total_online = sum(r.online_devices for r in reachable)
    with_pin = sum(r.pin_devices_sample for r in reachable)
    without_pin = sum(r.no_pin_devices_sample for r in reachable)

    print(f"reachable={len(reachable)}/{len(panels)}")
    print(f"sum_shallow_devices≈{total_devices} sample_online≈{total_online}")
    print(f"sample pin={with_pin} no_pin={without_pin}")
    print(f"wrote {args.out_json} {args.out_csv}")

    big = [r for r in reachable if r.total_devices >= 30_000]
    if big:
        print(f"DBs with >=30k shallow keys: {len(big)}")
        for r in big[:15]:
            print(f"  {r.total_devices:>8} online_sample={r.online_devices} {r.url}")


if __name__ == "__main__":
    main()
