import logging
import re
from pathlib import Path

from sqlalchemy.orm import Session

from app.database import FirebaseSource
from app.firebase_client import normalize_firebase_url

logger = logging.getLogger(__name__)

POOL_FILE = Path(__file__).resolve().parent.parent / "data" / "firebase_pool.txt"

URL_PATTERN = re.compile(
    r"https?://[^\s<>\"']+?(?:firebaseio\.com|firebasedatabase\.app)[^\s<>\"']*|"
    r"(?:[a-z0-9][a-z0-9-]*-default-rtdb\.firebaseio\.com|"
    r"[a-z0-9][a-z0-9-]*(?:-[a-z0-9]+)?\.firebasedatabase\.app)",
    re.IGNORECASE,
)


def _clean_url(raw: str) -> str | None:
    cleaned = raw.strip().rstrip(".,;)-_")
    while cleaned.endswith("-"):
        cleaned = cleaned[:-1]
    if not cleaned:
        return None
    if not cleaned.startswith(("http://", "https://")):
        cleaned = f"https://{cleaned}"
    try:
        return normalize_firebase_url(cleaned)
    except ValueError:
        return None


def extract_firebase_urls(content: str) -> list[str]:
    seen: set[str] = set()
    urls: list[str] = []
    for match in URL_PATTERN.findall(content):
        url = _clean_url(match)
        if url and url not in seen:
            seen.add(url)
            urls.append(url)
    return urls


def load_bundled_pool_urls() -> list[str]:
    if not POOL_FILE.exists():
        return []
    return extract_firebase_urls(POOL_FILE.read_text(encoding="utf-8", errors="ignore"))


def upsert_pool_urls(db: Session, urls: list[str]) -> int:
    added = 0
    for url in urls:
        existing = db.query(FirebaseSource).filter(FirebaseSource.url == url).first()
        if existing:
            continue
        db.add(FirebaseSource(url=url))
        added += 1
    if added:
        db.commit()
    return added


def ensure_pool_loaded(db: Session) -> int:
    bundled = load_bundled_pool_urls()
    if not bundled:
        return 0
    added = upsert_pool_urls(db, bundled)
    if added:
        logger.info("Firebase pool loaded: %s new URLs (%s bundled total)", added, len(bundled))
    return added


def get_pool_urls(db: Session) -> list[str]:
    return [
        row[0]
        for row in db.query(FirebaseSource.url).order_by(FirebaseSource.id.asc()).all()
        if row[0]
    ]
