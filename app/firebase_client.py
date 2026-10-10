from urllib.parse import urlparse

import httpx

DEVICE_PATHS = ("devices", "device", "clients", "users", "phones")


def normalize_firebase_url(url: str) -> str:
    cleaned = url.strip().rstrip("/")
    if not cleaned:
        raise ValueError("Firebase URL khali hai")
    if not cleaned.startswith(("http://", "https://")):
        cleaned = f"https://{cleaned}"
    if ".firebaseio.com" not in cleaned and ".firebasedatabase.app" not in cleaned:
        raise ValueError("Valid Firebase RTDB URL daalo (firebaseio.com ya firebasedatabase.app)")
    return cleaned


def _fetch_json(url: str) -> dict | list | None:
    response = httpx.get(url, timeout=15.0, follow_redirects=True)
    response.raise_for_status()
    data = response.json()
    if data is None:
        return None
    return data


def _looks_like_device(value: dict) -> bool:
    fields = (
        "name",
        "device_name",
        "phone",
        "phone_number",
        "mobile",
        "model",
        "battery",
        "battery_level",
        "online",
        "status",
        "sim",
        "carrier",
        "device",
    )
    return any(field in value for field in fields)


def _extract_shallow_devices(data: dict, prefix: str = "") -> list[dict]:
    devices: list[dict] = []
    for key, value in data.items():
        if isinstance(value, dict):
            devices.append(_build_device_record(str(key), value, prefix))
    return devices


def _extract_devices(data: dict | list, prefix: str = "") -> list[dict]:
    found: list[dict] = []

    if isinstance(data, list):
        for index, item in enumerate(data):
            if isinstance(item, dict):
                key = str(item.get("id") or item.get("device_id") or index)
                found.append(_build_device_record(key, item, prefix))
        return found

    if not isinstance(data, dict):
        return found

    for key, value in data.items():
        if isinstance(value, dict):
            if _looks_like_device(value):
                found.append(_build_device_record(str(key), value, prefix))
            else:
                nested = [item for item in value.values() if isinstance(item, dict)]
                if nested and len(nested) == len(value):
                    found.extend(_extract_shallow_devices(value, prefix=f"{prefix}{key}/"))
                else:
                    found.extend(_extract_devices(value, prefix=f"{prefix}{key}/"))
        elif isinstance(value, list):
            found.extend(_extract_devices(value, prefix=f"{prefix}{key}/"))

    return found


def _clean_sim_value(raw: object) -> str | None:
    if raw is None:
        return None
    if isinstance(raw, dict):
        for key in ("number", "phone", "phoneNumber", "mobile", "msisdn"):
            if key in raw:
                return _clean_sim_value(raw.get(key))
        return None
    text = str(raw).strip()
    if not text or text.lower() in {"unknown", "n/a", "na", "null", "none", "undefined"}:
        return None
    return text


def build_sim_list_from_record(value: dict, fallback_phone: str | None = None) -> list[dict]:
    """Parse SIM 1 / SIM 2 numbers from Firebase / APK device JSON."""
    if not isinstance(value, dict):
        value = {}

    skip_keys = frozenset({"action", "sendSms", "send_sms", "monitoring"})
    record = {k: v for k, v in value.items() if k not in skip_keys}

    sims = record.get("sims") or record.get("sim_list") or record.get("simList")
    if isinstance(sims, list) and sims:
        parsed: list[dict] = []
        for index, item in enumerate(sims[:2]):
            if not isinstance(item, dict):
                continue
            number = _clean_sim_value(item.get("number") or item.get("phone") or item.get("phoneNumber"))
            parsed.append(
                {
                    "slot": int(item.get("slot") or index + 1),
                    "index": int(item.get("index") if item.get("index") is not None else index),
                    "carrier": str(item.get("carrier") or item.get("operator") or f"SIM {index + 1}"),
                    "number": number or "N/A",
                }
            )
        if parsed and any(p.get("number") not in (None, "N/A") for p in parsed):
            while len(parsed) < 2:
                parsed.append(
                    {"slot": len(parsed) + 1, "index": len(parsed), "carrier": f"SIM {len(parsed) + 1}", "number": "N/A"}
                )
            return parsed[:2]

    sim1 = _clean_sim_value(
        record.get("sim1")
        or record.get("sim_1")
        or record.get("simOne")
        or record.get("sim1Number")
        or record.get("sim1_number")
        or record.get("phone1")
        or record.get("phone_1")
        or record.get("mobile1")
        or record.get("mobile_1")
        or record.get("line1Number")
        or record.get("line1")
        or record.get("phone")
        or record.get("phone_number")
        or record.get("phoneNumber")
        or record.get("mobile")
        or record.get("number")
        or record.get("ownNumber")
        or record.get("fromNumber")
        or record.get("devicePhone")
        or record.get("primaryPhone")
    )
    sim2 = _clean_sim_value(
        record.get("sim2")
        or record.get("sim_2")
        or record.get("simTwo")
        or record.get("sim2Number")
        or record.get("sim2_number")
        or record.get("phone2")
        or record.get("phone_2")
        or record.get("mobile2")
        or record.get("mobile_2")
        or record.get("line2Number")
        or record.get("line2")
        or record.get("secondNumber")
        or record.get("secondaryPhone")
    )

    nested = record.get("sim") or record.get("dualSim") or record.get("simInfo")
    if isinstance(nested, dict):
        if not sim1:
            sim1 = _clean_sim_value(
                nested.get("sim1")
                or nested.get("0")
                or nested.get("slot1")
                or nested.get("phone1")
            )
        if not sim2:
            sim2 = _clean_sim_value(
                nested.get("sim2")
                or nested.get("1")
                or nested.get("slot2")
                or nested.get("phone2")
            )

    if not sim1 and fallback_phone:
        sim1 = _clean_sim_value(fallback_phone)

    return [
        {"slot": 1, "index": 0, "carrier": "SIM 1", "number": sim1 or "N/A"},
        {"slot": 2, "index": 1, "carrier": "SIM 2", "number": sim2 or "N/A"},
    ]


def fetch_merged_device_record(base_url: str, device_id: str) -> dict:
    """Merge device node(s) from Firebase — SIM fields often live under devices/{id}."""
    base = normalize_firebase_url(base_url)
    merged: dict = {}
    for path in (f"devices/{device_id}", f"device/{device_id}", f"clients/{device_id}"):
        try:
            chunk = _fetch_json(f"{base}/{path}.json")
        except httpx.HTTPError:
            continue
        if isinstance(chunk, dict):
            for key, val in chunk.items():
                if key in ("action", "sendSms") and key in merged:
                    continue
                merged[key] = val
    return merged


def is_device_online(device: dict) -> bool:
    raw = device.get("raw") or {}
    online = raw.get("online")
    if online in (True, "true", "True", 1, "1"):
        return True
    if online in (False, "false", "False", 0, "0"):
        return False

    status = str(device.get("status") or raw.get("status") or "").lower()
    if status in {"online", "true", "1", "connected", "active"}:
        return True
    if status in {"offline", "false", "0", "inactive"}:
        return False
    return True


def _build_device_record(key: str, value: dict, prefix: str) -> dict:
    name = (
        value.get("name")
        or value.get("device_name")
        or value.get("model")
        or value.get("device")
        or key
    )
    phone = value.get("phone") or value.get("phone_number") or value.get("mobile") or value.get("number")
    status = value.get("status") or value.get("online")
    sims = build_sim_list_from_record(value, str(phone) if phone else None)

    return {
        "firebase_key": f"{prefix}{key}".strip("/"),
        "name": str(name),
        "phone_number": str(phone) if phone else None,
        "status": str(status) if status is not None else None,
        "battery": value.get("battery") or value.get("battery_level"),
        "model": value.get("model") or value.get("device_model"),
        "sims": sims,
        "raw": value,
    }


async def fetch_firebase_devices(firebase_url: str) -> list[dict]:
    base_url = normalize_firebase_url(firebase_url)
    parsed = urlparse(base_url)
    path = parsed.path.strip("/")
    best_devices: list[dict] = []

    def consider(data: dict | list | None, prefix: str = "") -> list[dict]:
        if not data:
            return []
        if isinstance(data, dict):
            shallow = _extract_shallow_devices(data, prefix)
            if shallow:
                return shallow
        return _extract_devices(data if isinstance(data, (dict, list)) else {}, prefix=prefix)

    if path:
        try:
            devices = consider(_fetch_json(f"{base_url}.json"))
            if devices:
                return devices
        except httpx.HTTPError:
            pass

    for device_path in DEVICE_PATHS:
        try:
            data = _fetch_json(f"{base_url}/{device_path}.json")
        except httpx.HTTPError:
            continue
        devices = consider(data, prefix=device_path)
        if len(devices) > len(best_devices):
            best_devices = devices

    if best_devices:
        return best_devices

    try:
        data = _fetch_json(f"{base_url}.json")
    except httpx.HTTPError as exc:
        raise ValueError(f"Firebase connect nahi hua: {exc}") from exc

    if data is None:
        return []

    return consider(data)
