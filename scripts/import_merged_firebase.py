#!/usr/bin/env python3
"""Import data/firebase_merged_dedup.txt into Panel Search + Virtus SMS (deduped URLs)."""
from __future__ import annotations

import sys
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from panel_search_bot.firebase_urls import extract_firebase_urls


def main() -> None:
    src = ROOT / "data" / "firebase_merged_dedup.txt"
    if not src.exists():
        print(f"Missing {src}")
        sys.exit(1)
    text = src.read_text(encoding="utf-8", errors="ignore")
    urls = extract_firebase_urls(text)
    print(f"URLs in file: {len(urls)}")

    from panel_search_bot.database import SessionLocal, init_db
    from panel_search_bot.services import add_firebase_urls

    init_db()
    db = SessionLocal()
    added, skipped = add_firebase_urls(db, urls, pool="leak", owner_telegram_id=None)
    print(f"Panel Search leak pool: +{added} new, {skipped} duplicate/skip")
    db.close()

    from app.database import Device, SessionLocal as SmsSession
    from app.bulk_firebase import upsert_pool_device
    from app.firebase_client import normalize_firebase_url

    db2 = SmsSession()
    seen: set[str] = set()
    added_sms = 0
    for url in urls:
        try:
            norm = normalize_firebase_url(url)
        except ValueError:
            continue
        if norm in seen:
            continue
        seen.add(norm)
        if db2.query(Device).filter(Device.firebase_source_url == norm).first():
            continue
        slug = urlparse(norm).netloc.split(".")[0][:128]
        upsert_pool_device(db2, device_id=slug, firebase_url=norm, firebase_key=slug)
        added_sms += 1
    db2.commit()
    total = db2.query(Device).count()
    db2.close()
    print(f"Virtus SMS devices: +{added_sms} new, pool total ~{total}")


if __name__ == "__main__":
    main()
