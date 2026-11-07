"""Parse SIM 1 / SIM 2 numbers from Firebase device nodes (display only)."""

from __future__ import annotations

from typing import Any


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


def build_sim_slots_from_record(record: dict) -> list[dict]:
    """Build [{slot, index, carrier, number}, ...] from a Firebase device dict."""
    raw = record.get("raw") if isinstance(record.get("raw"), dict) else record
    if not isinstance(raw, dict):
        raw = record

    slots: list[dict] = []

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
