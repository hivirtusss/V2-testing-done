from __future__ import annotations

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from aadhaar_bot.config import get_settings
from aadhaar_bot.models import Base

_engine = None
SessionLocal: sessionmaker[Session] | None = None


def init_db() -> None:
    global _engine, SessionLocal
    settings = get_settings()
    url = settings.aadhaar_db_url
    _engine = create_engine(url, connect_args={"check_same_thread": False} if url.startswith("sqlite") else {})
    SessionLocal = sessionmaker(bind=_engine, autoflush=False, autocommit=False)
    Base.metadata.create_all(_engine)


def db_session() -> Session:
    if SessionLocal is None:
        init_db()
    assert SessionLocal is not None
    return SessionLocal()
