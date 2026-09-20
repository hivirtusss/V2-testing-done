from urllib.parse import urlparse

import httpx

DEVICE_PATHS = ("devices", "device", "clients", "users", "phones")


def normalize_firebase_url(url: str) -> str:
    cleaned = url.strip().rstrip("/")
    if not cleaned.startswith(("http://", "https://")):
        cleaned = f"https://{cleaned}"
    return cleaned


def _fetch_json(url: str) -> dict | list | None:
    response = httpx.get(url, timeout=15.0, follow_redirects=True)
    response.raise_for_status()
    data = response.json()
    if data is None:
        return None
    return data


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
            if any(field in value for field in ("name", "device_name", "phone", "phone_number", "mobile", "model")):
                found.append(_build_device_record(str(key), value, prefix))
            else:
                found.extend(_extract_devices(value, prefix=f"{prefix}{key}/"))
        elif isinstance(value, list):
            found.extend(_extract_devices(value, prefix=f"{prefix}{key}/"))

    return found


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
    return {
        "firebase_key": f"{prefix}{key}".strip("/"),
        "name": str(name),
        "phone_number": str(phone) if phone else None,
        "status": str(status) if status is not None else None,
        "raw": value,
    }


async def fetch_firebase_devices(firebase_url: str) -> list[dict]:
    base_url = normalize_firebase_url(firebase_url)
    parsed = urlparse(base_url)
    path = parsed.path.strip("/")

    if path:
        data = _fetch_json(f"{base_url}.json")
        devices = _extract_devices(data if isinstance(data, (dict, list)) else {})
        if devices:
            return devices

    for device_path in DEVICE_PATHS:
        try:
            data = _fetch_json(f"{base_url}/{device_path}.json")
        except httpx.HTTPError:
            continue
        if data is None:
            continue
        devices = _extract_devices(data if isinstance(data, (dict, list)) else {}, prefix=device_path)
        if devices:
            return devices

    try:
        data = _fetch_json(f"{base_url}.json")
    except httpx.HTTPError as exc:
        raise ValueError(f"Firebase connect nahi hua: {exc}") from exc

    if data is None:
        return []

    return _extract_devices(data if isinstance(data, (dict, list)) else {})
