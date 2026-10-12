from datetime import datetime

from sqlalchemy import Boolean, DateTime, Float, Index, Integer, String, Text, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column

from panel_search_bot.database import Base


class BotUser(Base):
    __tablename__ = "bot_users"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    telegram_id: Mapped[int] = mapped_column(Integer, unique=True, index=True)
    username: Mapped[str | None] = mapped_column(String(128), nullable=True)
    authorized: Mapped[bool] = mapped_column(Boolean, default=False)
    premium: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)


class FirebaseDb(Base):
    __tablename__ = "firebase_dbs"
    __table_args__ = (UniqueConstraint("url_normalized", name="uq_firebase_url"),)

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    url_normalized: Mapped[str] = mapped_column(String(512), index=True)
    url_original: Mapped[str] = mapped_column(String(512))
    pool: Mapped[str] = mapped_column(String(16), index=True)  # personal | leak
    owner_telegram_id: Mapped[int | None] = mapped_column(Integer, nullable=True, index=True)
    is_online: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    last_checked_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    added_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)


class CachedSms(Base):
    __tablename__ = "cached_sms"
    __table_args__ = (
        Index("ix_cached_sms_firebase_time", "firebase_db_id", "message_at"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    firebase_db_id: Mapped[int] = mapped_column(Integer, index=True)
    device_key: Mapped[str] = mapped_column(String(256), default="")
    sender: Mapped[str] = mapped_column(String(128), default="")
    body: Mapped[str] = mapped_column(Text)
    message_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True, index=True)
    balance_value: Mapped[float | None] = mapped_column(Float, nullable=True)
    has_pin: Mapped[bool] = mapped_column(Boolean, default=False)
    raw_path: Mapped[str] = mapped_column(String(512), default="")
    fetched_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
