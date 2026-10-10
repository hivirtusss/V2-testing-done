from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker

from panel_search_bot.config import get_settings


class Base(DeclarativeBase):
    pass


def _engine():
    settings = get_settings()
    connect_args = {"check_same_thread": False} if settings.panel_search_database_url.startswith("sqlite") else {}
    return create_engine(settings.panel_search_database_url, connect_args=connect_args)


engine = _engine()
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def init_db() -> None:
    from panel_search_bot import models  # noqa: F401

    Base.metadata.create_all(bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
