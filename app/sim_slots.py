"""Parse SIM 1 / SIM 2 numbers from Firebase device nodes (display only)."""

from __future__ import annotations

from typing import Any

# Virtus / channel APK keeps live telemetry under devices/{id} and command trees under clients/{id}.
_VIRTUS_COMMAND_KEYS = frozenset(
    {
        "action",
        "actions",
        "command",
        "commands",
        "sms",
        "smsCommand",
        "sendSms",
        "send_sms",
        "send",
        "outbox",
        "webhookEvent",
    }
)
_DEVICE_PHONE_KEYS = (
    "devicePhone",
    "simPhone",
    "line1Number",
    "simNumber",
    "myPhone",
    "selfNumber",
    "fromNumber",
    "senderNumber",
    "rawNumber",
    "cleanNumber",
    "cleanPhone",
)
_RECIPIENT_KEYS = (
    "to",
    "destination",
    "address",
    "recipient",
    "mobNo",
    "mobile",
    "phone",
    "number",
    "phoneNumber",
)
_SKIP_NESTED_KEYS = frozenset({"messages", "sms_out"})


def is_usable_phone(number: str | None) -> bool:
    if number is None:
        return False
    normalized = str(number).strip().upper()
    if normalized in {"", "N/A", "NA", "UNKNOWN", "NONE", "-", "NULL"}:
        return False
    digits = "".join(ch for ch in normalized if ch.isdigit())
    return len(digits) >= 10


def _coerce_phone(value: Any) -> str | None:
    if value is None:
        return None
    if isinstance(value, dict):
        for key in ("number", "phone", "phone_number", "mobile", "msisdn", "simNumber"):
            found = _coerce_phone(value.get(key))
            if found:
                return found
        return None
    if isinstance(value, (list, tuple)):
        for item in value:
            found = _coerce_phone(item)
            if found:
                return found
        return None
    text = str(value).strip()
    return text if is_usable_phone(text) else None


def _pick(raw: dict, *keys: str) -> str | None:
    for key in keys:
        if key not in raw:
            continue
        found = _coerce_phone(raw.get(key))
        if found:
            return found
    return None


def _digits_only(value: Any) -> str:
    return "".join(ch for ch in str(value or "") if ch.isdigit())


def _slot_index_from_value(value: Any) -> int | None:
    if value is None:
        return None
    text = str(value).strip()
    if not text:
        return None
    if text.isdigit():
        num = int(text)
        if 0 <= num <= 3:
            return num
    return None


def _recipient_fingerprints(cmd: dict) -> set[str]:
    fps: set[str] = set()
    for key in _RECIPIENT_KEYS:
        digits = _digits_only(cmd.get(key))
        if len(digits) >= 10:
            fps.add(digits)
            fps.add(digits[-10:])
    return fps


def _phone_from_command_node(cmd: dict) -> str | None:
    recipients = _recipient_fingerprints(cmd)
    fallback: str | None = None
    for key in _DEVICE_PHONE_KEYS:
        found = _coerce_phone(cmd.get(key))
        if not found:
            continue
        found_digits = _digits_only(found)
        if recipients and (found_digits in recipients or found_digits[-10:] in recipients):
            fallback = fallback or found
            continue
        return found
    if fallback:
        return fallback
    # Outbound-only nodes often duplicate recipient in phone/mobNo — still better than Unknown on cards.
    for key in ("phone", "mobNo", "mobile", "number", "phoneNumber"):
        found = _coerce_phone(cmd.get(key))
        if found:
            return found
    return None


def _sim_index_from_command(cmd: dict) -> int:
    for key in ("simIndex", "fromSlot", "sim_slot", "simSlot", "slot"):
        idx = _slot_index_from_value(cmd.get(key))
        if idx is not None:
            return min(idx, 1)
    idx = _slot_index_from_value(cmd.get("sim"))
    if idx is not None:
        return min(max(idx - 1, 0), 1)
    idx = _slot_index_from_value(cmd.get("from"))
    if idx is not None:
        return min(idx, 1)
    sub = cmd.get("subscriptionId") or cmd.get("subId")
    idx = _slot_index_from_value(sub)
    if idx is not None:
        return min(max(idx - 1, 0), 1)
    return 0


def _looks_like_command_node(node: dict) -> bool:
    if any(key in node for key in _DEVICE_PHONE_KEYS):
        return True
    if node.get("to") or node.get("destination") or node.get("address"):
        return True
    action = str(node.get("action") or node.get("command") or "").lower()
    if "sms" in action or node.get("type") == "sms":
        return True
    return False


def _walk_virtus_nodes(value: Any, *, depth: int = 0) -> list[dict]:
    if depth > 6:
        return []
    found: list[dict] = []
    if isinstance(value, dict):
        if _looks_like_command_node(value):
            found.append(value)
        for key, child in value.items():
            if key in _SKIP_NESTED_KEYS:
                continue
            if isinstance(child, dict):
                if key == "commandList":
                    for sub in child.values():
                        found.extend(_walk_virtus_nodes(sub, depth=depth + 1))
                else:
                    found.extend(_walk_virtus_nodes(child, depth=depth + 1))
            elif isinstance(child, list):
                found.extend(_walk_virtus_nodes(child, depth=depth + 1))
    elif isinstance(value, list):
        for item in value[:24]:
            found.extend(_walk_virtus_nodes(item, depth=depth + 1))
    return found


def _extract_virtus_sim_slots(raw: dict) -> list[dict]:
    by_index: dict[int, dict] = {}
    for node in _walk_virtus_nodes(raw):
        phone = _phone_from_command_node(node)
        if not phone:
            continue
        index = _sim_index_from_command(node)
        slot = index + 1
        current = by_index.get(index)
        if current:
            old_len = len(_digits_only(current.get("number")))
            new_len = len(_digits_only(phone))
            if new_len <= old_len:
                continue
        by_index[index] = {
            "slot": slot,
            "index": index,
            "carrier": f"SIM {slot}",
            "number": phone,
        }
    return [by_index[i] for i in sorted(by_index.keys())]


def build_sim_slots_from_record(record: dict) -> list[dict]:
    """Build [{slot, index, carrier, number}, ...] from a Firebase device dict."""
    raw = record.get("raw") if isinstance(record.get("raw"), dict) else record
    if not isinstance(raw, dict):
        raw = record

    slots: list[dict] = list(_extract_virtus_sim_slots(raw))

    existing = record.get("sims") or raw.get("sims") or raw.get("sim_list")
    if isinstance(existing, list):
        for index, item in enumerate(existing):
            if not isinstance(item, dict):
                continue
            number = _coerce_phone(item.get("number")) or _coerce_phone(item.get("phone"))
            if not number:
                continue
            slot = int(item.get("slot") or item.get("index", index) + 1)
            slots.append(
                {
                    "slot": 1 if slot <= 1 else 2,
                    "index": 0 if slot <= 1 else 1,
                    "carrier": str(item.get("carrier") or f"SIM {slot}"),
                    "number": number,
                }
            )

    phone1 = (
        _pick(
            raw,
            "phone",
            "phone_number",
            "mobile",
            "number",
            "sim1",
            "sim_1",
            "simOne",
            "mobile1",
            "fromNumber",
            "from_number",
            "sender_number",
        )
        or _coerce_phone(record.get("phone_number"))
    )
    phone2 = _pick(
        raw,
        "phone2",
        "sim2",
        "sim_2",
        "simTwo",
        "mobile2",
        "secondary_phone",
        "second_number",
    )

    if phone1 and not any(s.get("slot") == 1 for s in slots):
        slots.insert(0, {"slot": 1, "index": 0, "carrier": raw.get("carrier1") or "SIM 1", "number": phone1})
    if phone2 and not any(s.get("slot") == 2 for s in slots):
        slots.append({"slot": 2, "index": 1, "carrier": raw.get("carrier2") or "SIM 2", "number": phone2})

    if not slots and phone1:
        slots.append({"slot": 1, "index": 0, "carrier": "SIM 1", "number": phone1})

    # Dedupe by slot, prefer longest digit string
    by_slot: dict[int, dict] = {}
    for sim in slots:
        slot = int(sim.get("slot") or 1)
        cur = by_slot.get(slot)
        if not cur:
            by_slot[slot] = sim
            continue
        old_d = len("".join(ch for ch in str(cur.get("number")) if ch.isdigit()))
        new_d = len("".join(ch for ch in str(sim.get("number")) if ch.isdigit()))
        if new_d >= old_d:
            by_slot[slot] = sim

    ordered = [by_slot[k] for k in sorted(by_slot.keys())]
    return ordered[:2]


def compact_device_raw_for_meta(raw: dict | None) -> dict:
    """Small Firebase snapshot kept in device_meta so cards can re-parse SIM numbers."""
    if not isinstance(raw, dict):
        return {}
    compact: dict = {}
    for key in (
        "battery",
        "battery_level",
        "online",
        "last_seen",
        "monitoring",
        "sim_index",
        "phone",
        "phone_number",
        "mobile",
        "sim1",
        "sim2",
        "sims",
    ):
        if key in raw:
            compact[key] = raw[key]
    for key in _VIRTUS_COMMAND_KEYS:
        if key in raw:
            compact[key] = raw[key]
    if "commandList" in raw and isinstance(raw["commandList"], dict):
        compact["commandList"] = dict(list(raw["commandList"].items())[-3:])
    return compact
