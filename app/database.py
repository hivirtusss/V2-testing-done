from datetime import datetime, timezone

from sqlalchemy import Boolean, DateTime, ForeignKey, Integer, String, Text, create_engine, inspect, text
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship, sessionmaker

from app.config import get_settings


class Base(DeclarativeBase):
    pass


class Device(Base):
    __tablename__ = "devices"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(128), unique=True, index=True)
    api_key: Mapped[str | None] = mapped_column(String(128), nullable=True, index=True)
    last_seen: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    owner_telegram_id: Mapped[int | None] = mapped_column(Integer, nullable=True, index=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
    )

    messages: Mapped[list["SMSMessage"]] = relationship(back_populates="device")


class SMSMessage(Base):
    __tablename__ = "sms_messages"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    sender: Mapped[str] = mapped_column(String(64), index=True)
    message: Mapped[str] = mapped_column(Text)
    device_name: Mapped[str] = mapped_column(String(128), default="unknown", index=True)
    device_id: Mapped[int | None] = mapped_column(ForeignKey("devices.id"), nullable=True, index=True)
    received_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        index=True,
    )

    device: Mapped[Device | None] = relationship(back_populates="messages")


settings = get_settings()


def _engine_kwargs(url: str) -> dict:
    if url.startswith("sqlite"):
        return {"connect_args": {"check_same_thread": False}}
    return {}


engine = create_engine(settings.database_url, **_engine_kwargs(settings.database_url))
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)


def _migrate_existing_tables() -> None:
    inspector = inspect(engine)
    table_names = inspector.get_table_names()

    if "sms_messages" in table_names:
        columns = {col["name"] for col in inspector.get_columns("sms_messages")}
        if "device_id" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE sms_messages ADD COLUMN device_id INTEGER"))

    if "devices" in table_names:
        columns = {col["name"] for col in inspector.get_columns("devices")}
        if "owner_telegram_id" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE devices ADD COLUMN owner_telegram_id INTEGER"))


def init_db() -> None:
    Base.metadata.create_all(bind=engine)
    _migrate_existing_tables()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_or_create_device(db, device_name: str) -> Device:
    device = db.query(Device).filter(Device.name == device_name).first()
    if device:
        device.last_seen = datetime.now(timezone.utc)
        device.is_active = True
        return device

    device = Device(name=device_name, last_seen=datetime.now(timezone.utc), is_active=True)
    db.add(device)
    db.flush()
    return device
