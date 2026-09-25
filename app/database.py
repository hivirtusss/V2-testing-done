from datetime import datetime, timezone

from sqlalchemy import Boolean, DateTime, ForeignKey, Integer, String, Text, create_engine, inspect, text
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship, sessionmaker

from app.config import get_settings


class Base(DeclarativeBase):
    pass


class MonitorProfile(Base):
    __tablename__ = "monitor_profiles"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    telegram_user_id: Mapped[int] = mapped_column(Integer, unique=True, index=True)
    phone_number: Mapped[str | None] = mapped_column(String(20), nullable=True, index=True)
    firebase_url: Mapped[str | None] = mapped_column(String(512), nullable=True)
    license_key: Mapped[str | None] = mapped_column(String(512), nullable=True)
    active_device_id: Mapped[int | None] = mapped_column(Integer, nullable=True)
    selected_sim_index: Mapped[int] = mapped_column(Integer, default=0)
    sim_selected: Mapped[bool] = mapped_column(Boolean, default=False)
    mynum_selected: Mapped[bool] = mapped_column(Boolean, default=False)
    channel_id: Mapped[str | None] = mapped_column(String(64), nullable=True)
    auto_stop_minutes: Mapped[int] = mapped_column(Integer, default=15)
    is_monitoring: Mapped[bool] = mapped_column(Boolean, default=False)
    started_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
    )


class Device(Base):
    __tablename__ = "devices"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(128), unique=True, index=True)
    phone_number: Mapped[str | None] = mapped_column(String(20), nullable=True, index=True)
    firebase_key: Mapped[str | None] = mapped_column(String(256), nullable=True, index=True)
    firebase_source_url: Mapped[str | None] = mapped_column(String(512), nullable=True)
    device_meta: Mapped[str | None] = mapped_column(Text, nullable=True)
    api_key: Mapped[str | None] = mapped_column(String(128), nullable=True, index=True)
    last_seen: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    owner_telegram_id: Mapped[int | None] = mapped_column(Integer, nullable=True, index=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
    )

    messages: Mapped[list["SMSMessage"]] = relationship(back_populates="device")


class OutboundSMS(Base):
    __tablename__ = "outbound_sms"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    device_id: Mapped[int] = mapped_column(ForeignKey("devices.id"), index=True)
    telegram_user_id: Mapped[int] = mapped_column(Integer, index=True)
    sim_index: Mapped[int] = mapped_column(Integer, default=0)
    sim_slot: Mapped[int] = mapped_column(Integer, default=1)
    to_number: Mapped[str] = mapped_column(String(20))
    spoof_sender: Mapped[str | None] = mapped_column(String(64), nullable=True)
    message: Mapped[str] = mapped_column(Text)
    channel_message_id: Mapped[int | None] = mapped_column(Integer, nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="pending", index=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        index=True,
    )
    sent_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)


class FirebaseSource(Base):
    __tablename__ = "firebase_sources"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    url: Mapped[str] = mapped_column(String(512), unique=True, index=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
    )


class ApprovedUser(Base):
    __tablename__ = "approved_users"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    telegram_user_id: Mapped[int] = mapped_column(Integer, unique=True, index=True)
    username: Mapped[str | None] = mapped_column(String(128), nullable=True)
    approved_by: Mapped[int] = mapped_column(Integer, index=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
    )


class LicenseKey(Base):
    __tablename__ = "license_keys"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    key: Mapped[str] = mapped_column(String(64), unique=True, index=True)
    max_devices: Mapped[int] = mapped_column(Integer, default=9999)
    created_by: Mapped[int] = mapped_column(Integer, index=True)
    active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
    )

    devices: Mapped[list["LicenseKeyDevice"]] = relationship(back_populates="license_key")


class LicenseKeyDevice(Base):
    __tablename__ = "license_key_devices"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    license_key_id: Mapped[int] = mapped_column(ForeignKey("license_keys.id"), index=True)
    device_id: Mapped[str] = mapped_column(String(128), index=True)
    telegram_user_id: Mapped[int] = mapped_column(Integer, index=True)
    apk_attached_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    registered_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
    )

    license_key: Mapped["LicenseKey"] = relationship(back_populates="devices")


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
        if "phone_number" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE devices ADD COLUMN phone_number VARCHAR(20)"))
        if "firebase_key" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE devices ADD COLUMN firebase_key VARCHAR(256)"))
        if "firebase_source_url" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE devices ADD COLUMN firebase_source_url VARCHAR(512)"))

    if "monitor_profiles" in table_names:
        columns = {col["name"] for col in inspector.get_columns("monitor_profiles")}
        if "firebase_url" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE monitor_profiles ADD COLUMN firebase_url VARCHAR(512)"))
        if "license_key" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE monitor_profiles ADD COLUMN license_key VARCHAR(512)"))
        if "active_device_id" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE monitor_profiles ADD COLUMN active_device_id INTEGER"))
        if "selected_sim_index" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE monitor_profiles ADD COLUMN selected_sim_index INTEGER DEFAULT 0"))
        if "channel_id" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE monitor_profiles ADD COLUMN channel_id VARCHAR(64)"))
        if "auto_stop_minutes" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE monitor_profiles ADD COLUMN auto_stop_minutes INTEGER DEFAULT 15"))
        if "sim_selected" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE monitor_profiles ADD COLUMN sim_selected BOOLEAN DEFAULT 0"))
        if "mynum_selected" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE monitor_profiles ADD COLUMN mynum_selected BOOLEAN DEFAULT 0"))

    if "devices" in table_names:
        columns = {col["name"] for col in inspector.get_columns("devices")}
        if "device_meta" not in columns:
            with engine.begin() as conn:
                conn.execute(text("ALTER TABLE devices ADD COLUMN device_meta TEXT"))


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
