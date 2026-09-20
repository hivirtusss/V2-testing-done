from urllib.parse import urlparse

import httpx

DEVICE_PATHS = ("clients", "devices", "device", "users", "phones")


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


def _join_firebase_path(prefix: str, key: str) -> str:
    cleaned_prefix = (prefix or "").strip("/")
    if cleaned_prefix:
        return f"{cleaned_prefix}/{key}"
    return str(key)


def _build_device_record(key: str, value: dict, prefix: str) -> dict:
    # Node key (e.g. f0577ffa536dde46) is the canonical device id for /fdy lookup.
    name = str(key)
    display_name = (
        value.get("name")
        or value.get("device_name")
        or value.get("model")
        or value.get("device")
        or key
    )
    phone = value.get("phone") or value.get("phone_number") or value.get("mobile") or value.get("number")
    status = value.get("status") or value.get("online")
    sims = value.get("sims") or value.get("sim_list")
    if not sims and phone:
        sims = [
            {"slot": 1, "index": 0, "carrier": value.get("carrier1", "SIM 1"), "number": str(phone)},
        ]
        if value.get("phone2") or value.get("sim2"):
            sims.append(
                {
                    "slot": 2,
                    "index": 1,
                    "carrier": value.get("carrier2", "SIM 2"),
                    "number": str(value.get("phone2") or value.get("sim2")),
                }
            )

    return {
        "firebase_key": _join_firebase_path(prefix, key),
        "name": name,
        "display_name": str(display_name),
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
        devices = consider(data, prefix=f"{device_path}/")
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
