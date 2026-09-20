import secrets
from datetime import datetime, timezone

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.database import Device, SMSMessage, get_or_create_device


def touch_device(db: Session, device_name: str) -> Device:
    return get_or_create_device(db, device_name)


def register_device(db: Session, name: str, api_key: str | None = None) -> Device:
    existing = db.query(Device).filter(Device.name == name).first()
    if existing:
        if api_key:
            existing.api_key = api_key
        existing.is_active = True
        existing.last_seen = datetime.now(timezone.utc)
        return existing

    device = Device(
        name=name,
        api_key=api_key or secrets.token_urlsafe(24),
        last_seen=datetime.now(timezone.utc),
        is_active=True,
    )
    db.add(device)
    db.flush()
    return device


def save_sms(
    db: Session,
    sender: str,
    message: str,
    device_name: str,
    received_at: datetime | None = None,
) -> SMSMessage:
    device = touch_device(db, device_name)
    sms = SMSMessage(
        sender=sender,
        message=message,
        device_name=device_name,
        device_id=device.id,
        received_at=received_at or datetime.now(timezone.utc),
    )
    db.add(sms)
    db.commit()
    db.refresh(sms)
    return sms


def get_device_by_identifier(db: Session, deviceid: str) -> Device | None:
    if deviceid.isdigit():
        by_id = db.query(Device).filter(Device.id == int(deviceid)).first()
        if by_id:
            return by_id
    return db.query(Device).filter(Device.name == deviceid).first()


def claim_device(db: Session, deviceid: str, owner_telegram_id: int) -> tuple[Device, bool]:
    device = get_device_by_identifier(db, deviceid)
    created = False

    if device:
        if device.owner_telegram_id and device.owner_telegram_id != owner_telegram_id:
            raise PermissionError("Device kisi aur user ki hai")
        device.owner_telegram_id = owner_telegram_id
        device.is_active = True
        device.last_seen = datetime.now(timezone.utc)
    else:
        device = register_device(db, deviceid)
        device.owner_telegram_id = owner_telegram_id
        created = True

    db.commit()
    db.refresh(device)
    return device, created


def list_devices_with_counts(db: Session, owner_telegram_id: int | None = None) -> list[dict]:
    query = db.query(
        Device,
        func.count(SMSMessage.id).label("sms_count"),
    ).outerjoin(SMSMessage, SMSMessage.device_id == Device.id)

    if owner_telegram_id is not None:
        query = query.filter(Device.owner_telegram_id == owner_telegram_id)

    rows = (
        query.group_by(Device.id)
        .order_by(Device.last_seen.desc().nullslast(), Device.name)
        .all()
    )
    return [
        {
            "device": device,
            "sms_count": sms_count,
        }
        for device, sms_count in rows
    ]


def device_status(device: Device) -> str:
    if not device.is_active:
        return "inactive"
    if not device.last_seen:
        return "unknown"
    age = datetime.now(timezone.utc) - device.last_seen.astimezone(timezone.utc)
    if age.total_seconds() < 300:
        return "online"
    if age.total_seconds() < 3600:
        return "idle"
    return "offline"
