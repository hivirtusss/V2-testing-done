import secrets
from datetime import datetime, timezone

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.database import Device, MonitorProfile, SMSMessage, get_or_create_device
from app.firebase_client import fetch_firebase_devices, normalize_firebase_url


def normalize_phone(number: str) -> str:
    digits = "".join(char for char in number if char.isdigit())
    if len(digits) == 10:
        return f"91{digits}"
    return digits


def get_monitor_profile(db: Session, telegram_user_id: int) -> MonitorProfile | None:
    return db.query(MonitorProfile).filter(MonitorProfile.telegram_user_id == telegram_user_id).first()


def get_or_create_monitor_profile(db: Session, telegram_user_id: int) -> MonitorProfile:
    profile = get_monitor_profile(db, telegram_user_id)
    if profile:
        return profile
    profile = MonitorProfile(telegram_user_id=telegram_user_id)
    db.add(profile)
    db.flush()
    return profile


def set_user_phone(db: Session, telegram_user_id: int, phone_number: str) -> tuple[MonitorProfile, Device]:
    normalized = normalize_phone(phone_number)
    if len(normalized) < 10:
        raise ValueError("Invalid phone number")

    profile = get_or_create_monitor_profile(db, telegram_user_id)
    profile.phone_number = normalized

    device_name = f"num-{normalized}"
    device = db.query(Device).filter(Device.phone_number == normalized).first()
    if not device:
        device = db.query(Device).filter(Device.name == device_name).first()

    if device:
        if device.owner_telegram_id and device.owner_telegram_id != telegram_user_id:
            raise PermissionError("Ye number kisi aur user ka hai")
        device.phone_number = normalized
        device.owner_telegram_id = telegram_user_id
        device.is_active = True
    else:
        device = register_device(db, device_name)
        device.phone_number = normalized
        device.owner_telegram_id = telegram_user_id

    db.commit()
    db.refresh(profile)
    db.refresh(device)
    return profile, device


def start_monitoring(db: Session, telegram_user_id: int) -> MonitorProfile:
    profile = get_monitor_profile(db, telegram_user_id)
    if not profile or not profile.phone_number:
        raise ValueError("Pehle /mynum <number> set karo")

    profile.is_monitoring = True
    profile.started_at = datetime.now(timezone.utc)
    db.commit()
    db.refresh(profile)
    return profile


def stop_monitoring(db: Session, telegram_user_id: int) -> MonitorProfile:
    profile = get_monitor_profile(db, telegram_user_id)
    if not profile:
        raise ValueError("Monitor profile nahi mili")

    profile.is_monitoring = False
    db.commit()
    db.refresh(profile)
    return profile


def get_monitoring_user_ids(db: Session, sms: SMSMessage) -> set[int]:
    targets: set[int] = set()

    if sms.device_id:
        device = db.query(Device).filter(Device.id == sms.device_id).first()
        if device and device.owner_telegram_id:
            profile = get_monitor_profile(db, device.owner_telegram_id)
            if profile and profile.is_monitoring:
                targets.add(device.owner_telegram_id)

    active_profiles = db.query(MonitorProfile).filter(MonitorProfile.is_monitoring.is_(True)).all()
    for profile in active_profiles:
        if not profile.phone_number:
            continue
        if sms.device_id:
            device = db.query(Device).filter(Device.id == sms.device_id).first()
            if device and device.phone_number == profile.phone_number:
                targets.add(profile.telegram_user_id)
        elif profile.phone_number in sms.device_name:
            targets.add(profile.telegram_user_id)

    return targets


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
    phone_number: str | None = None,
) -> SMSMessage:
    device = touch_device(db, device_name)
    if phone_number:
        device.phone_number = normalize_phone(phone_number)
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


async def set_firebase_url(db: Session, telegram_user_id: int, firebase_url: str) -> tuple[MonitorProfile, list[Device]]:
    normalized_url = normalize_firebase_url(firebase_url)
    remote_devices = await fetch_firebase_devices(normalized_url)
    if not remote_devices:
        raise ValueError("Firebase se koi device nahi mili. URL ya path check karo.")

    profile = get_or_create_monitor_profile(db, telegram_user_id)
    profile.firebase_url = normalized_url

    synced_devices: list[Device] = []
    for remote in remote_devices:
        device_name = str(remote["name"])[:128]
        device = db.query(Device).filter(Device.firebase_key == remote["firebase_key"]).first()
        if not device:
            device = db.query(Device).filter(Device.name == device_name).first()

        if device:
            if device.owner_telegram_id and device.owner_telegram_id != telegram_user_id:
                continue
            device.name = device_name
            device.owner_telegram_id = telegram_user_id
            device.firebase_key = remote["firebase_key"]
            device.is_active = True
            if remote.get("phone_number"):
                device.phone_number = normalize_phone(remote["phone_number"])
        else:
            existing_name = db.query(Device).filter(Device.name == device_name).first()
            if existing_name:
                device_name = f"{device_name}-{remote['firebase_key']}"[:128]
            device = register_device(db, device_name)
            device.owner_telegram_id = telegram_user_id
            device.firebase_key = remote["firebase_key"]
            if remote.get("phone_number"):
                device.phone_number = normalize_phone(remote["phone_number"])

        synced_devices.append(device)

    db.commit()
    for device in synced_devices:
        db.refresh(device)
    db.refresh(profile)
    return profile, synced_devices


async def resync_firebase_devices(db: Session, telegram_user_id: int) -> list[Device]:
    profile = get_monitor_profile(db, telegram_user_id)
    if not profile or not profile.firebase_url:
        raise ValueError("Pehle /setfirebase <url> use karo")
    _, devices = await set_firebase_url(db, telegram_user_id, profile.firebase_url)
    return devices


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
