from urllib.parse import urlparse

import httpx

from app.config import get_settings

_http_client: httpx.AsyncClient | None = None
_fast_client: httpx.AsyncClient | None = None
_client_workers: int | None = None


def get_firebase_workers() -> int:
    """Parallel Firebase HTTP workers (device find, SMS poll, bulk import)."""
    return max(1, min(get_settings().firebase_workers, 512))


def get_poll_workers() -> int:
    """Hot-path SMS poll workers — capped so Telegram bot stays responsive."""
    return max(4, min(get_settings().firebase_workers, 12))


def _httpx_limits() -> httpx.Limits:
    workers = get_firebase_workers()
    return httpx.Limits(
        max_connections=workers,
        max_keepalive_connections=workers,
    )


def _get_client(timeout: float = 8.0) -> httpx.AsyncClient:
    global _http_client, _fast_client, _client_workers
    workers = get_firebase_workers()
    if _client_workers != workers:
        if _http_client and not _http_client.is_closed:
            _http_client = None
        if _fast_client and not _fast_client.is_closed:
            _fast_client = None
        _client_workers = workers

    limits = _httpx_limits()
    if timeout <= 3.0:
        if _fast_client is None or _fast_client.is_closed:
            _fast_client = httpx.AsyncClient(
                timeout=timeout,
                follow_redirects=True,
                limits=limits,
            )
        return _fast_client
    if _http_client is None or _http_client.is_closed:
        _http_client = httpx.AsyncClient(
            timeout=timeout,
            follow_redirects=True,
            limits=limits,
        )
    return _http_client

DEVICE_PATHS = ("clients", "devices", "device", "users", "phones")
QUICK_DEVICE_PATHS = ("clients", "devices")
COLLECTION_SUFFIXES = frozenset(DEVICE_PATHS)


def normalize_firebase_url(url: str) -> str:
    cleaned = url.strip().rstrip("/")
    if not cleaned:
        raise ValueError("Firebase URL khali hai")
    if not cleaned.startswith(("http://", "https://")):
        cleaned = f"https://{cleaned}"
    if ".firebaseio.com" not in cleaned and ".firebasedatabase.app" not in cleaned:
        raise ValueError("Valid Firebase RTDB URL daalo (firebaseio.com ya firebasedatabase.app)")
    return cleaned


def firebase_root_url(url: str) -> str:
    """Strip trailing collection paths so pool URLs like .../clients resolve correctly."""
    normalized = normalize_firebase_url(url)
    parsed = urlparse(normalized)
    parts = [part for part in parsed.path.strip("/").split("/") if part]
    if parts and parts[-1].lower() in COLLECTION_SUFFIXES:
        parts = parts[:-1]
    root = f"{parsed.scheme}://{parsed.netloc}"
    if parts:
        return f"{root}/{'/'.join(parts)}".rstrip("/")
    return root


DEVICE_COLLECTION_PREFIXES = ("clients", "client", "devices", "device", "users", "phones")


def canonical_device_id(value: str) -> str:
    """Normalize device ids like clients/f0577... or clientsf0577... -> f0577..."""
    text = (value or "").strip().lower()
    if not text:
        return ""
    if "/" in text:
        text = text.split("/")[-1]
    for prefix in DEVICE_COLLECTION_PREFIXES:
        if text.startswith(prefix) and len(text) > len(prefix):
            tail = text[len(prefix) :]
            if tail and tail[0].isalnum():
                text = tail
                break
    return text


def device_ids_equivalent(query: str, candidate: str) -> bool:
    q = canonical_device_id(query)
    c = canonical_device_id(candidate)
    if not q or not c:
        return False
    if q == c:
        return True
    if c.endswith(q) or q.endswith(c):
        return True
    if f"f{q}" == c or f"f{c}" == q:
        return True
    return False


def device_id_matches(query: str, candidate: str) -> bool:
    q = (query or "").strip().lower()
    c = (candidate or "").strip().lower()
    if not q or not c:
        return False
    if q == c or device_ids_equivalent(q, c):
        return True
    if len(q) < 4:
        return False
    return c.startswith(q) or c.endswith(q) or q in c


def _pick_matching_key(query: str, keys: list[str]) -> str | None:
    if not keys:
        return None
    exact = [key for key in keys if key.lower() == query.lower()]
    if len(exact) == 1:
        return exact[0]
    if len(query) < 4:
        return None
    prefix = [key for key in keys if key.lower().startswith(query.lower())]
    if len(prefix) == 1:
        return prefix[0]
    suffix = [key for key in keys if key.lower().endswith(query.lower())]
    if len(suffix) == 1:
        return suffix[0]
    contains = [key for key in keys if query.lower() in key.lower()]
    if len(contains) == 1:
        return contains[0]
    return None


async def _fetch_json(url: str, *, timeout: float = 8.0) -> dict | list | None:
    client = _get_client(timeout)
    response = await client.get(url)
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


def _parse_last_seen_ms(raw: dict) -> float | None:
    from datetime import datetime, timezone

    for field in ("last_seen", "lastSeen", "last_seen_at", "updated_at", "ts"):
        value = raw.get(field)
        if value is None:
            continue
        if isinstance(value, (int, float)):
            ts = float(value)
            if ts > 1_000_000_000_000:
                ts /= 1000.0
            return ts
        text = str(value).strip()
        if not text:
            continue
        if text.isdigit():
            ts = float(text)
            if ts > 1_000_000_000_000:
                ts /= 1000.0
            return ts
        try:
            normalized = text.replace("Z", "+00:00")
            return datetime.fromisoformat(normalized).astimezone(timezone.utc).timestamp()
        except ValueError:
            continue
    return None


def is_device_online(device: dict, *, max_age_sec: float = 120.0) -> bool:
    raw = device.get("raw") or {}
    online = raw.get("online")
    if online is None:
        online = device.get("online")
    if online in (True, "true", "True", 1, "1"):
        return True
    if online in (False, "false", "False", 0, "0"):
        return False

    status = str(device.get("status") or raw.get("status") or "").lower()
    if status in {"online", "true", "1", "connected", "active"}:
        return True
    if status in {"offline", "false", "0", "inactive", "disconnected"}:
        return False

    last_seen = _parse_last_seen_ms(raw)
    if last_seen is not None:
        import time

        return (time.time() - last_seen) <= max_age_sec
    return False


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

    if not _looks_like_device(value) and value:
        if any(
            field in value
            for field in (
                "battery",
                "battery_level",
                "phone",
                "phone_number",
                "mobile",
                "number",
                "sim",
                "sim1",
                "sim2",
                "carrier",
                "carrier1",
                "online",
                "last_seen",
                "model",
            )
        ):
            pass
        elif len(value) <= 2:
            return {
                "firebase_key": _join_firebase_path(prefix, key),
                "name": name,
                "display_name": str(key),
                "phone_number": None,
                "status": None,
                "battery": None,
                "model": None,
                "sims": None,
                "raw": value,
            }

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


def _record_from_path(root: str, path: str, data: dict) -> dict:
    if "/" in path:
        prefix, key = path.rsplit("/", 1)
        prefix = f"{prefix}/"
    else:
        prefix, key = "", path
    return _build_device_record(key, data, prefix=prefix)


async def _fetch_device_node(root: str, path: str, timeout: float) -> dict | None:
    try:
        data = await _fetch_json(f"{root}/{path}.json", timeout=timeout)
    except httpx.HTTPError:
        return None
    if isinstance(data, dict):
        return _record_from_path(root, path, data)
    return None


async def _shallow_collection_keys(root: str, collection: str, timeout: float) -> list[str]:
    try:
        data = await _fetch_json(f"{root}/{collection}.json?shallow=true", timeout=timeout)
    except httpx.HTTPError:
        return []
    if isinstance(data, dict):
        return [str(key) for key in data.keys()]
    return []


async def fast_find_device_in_url(
    firebase_url: str,
    device_id: str,
    *,
    timeout: float = 2.0,
) -> dict | None:
    """Fast Astik-style lookup: direct node fetch, then shallow clients/devices key scan."""
    root = firebase_root_url(firebase_url)
    query = (device_id or "").strip()
    if not query:
        return None

    direct_paths = [query]
    for collection in DEVICE_PATHS:
        direct_paths.append(f"{collection}/{query}")

    seen_paths: set[str] = set()
    for path in direct_paths:
        if path in seen_paths:
            continue
        seen_paths.add(path)
        record = await _fetch_device_node(root, path, timeout)
        if record:
            return record

    shallow_timeout = min(timeout, 1.5)
    for collection in DEVICE_PATHS:
        keys = await _shallow_collection_keys(root, collection, shallow_timeout)
        matched = _pick_matching_key(query, keys)
        if not matched:
            continue
        record = await _fetch_device_node(root, f"{collection}/{matched}", timeout)
        if record:
            return record

    return None


async def fetch_firebase_device_live(
    firebase_url: str,
    *,
    firebase_key: str | None = None,
    device_name: str | None = None,
    quick_only: bool = False,
    timeout: float = 8.0,
) -> dict | None:
    """Fetch one device node live from Firebase (battery, sims, online)."""
    root = firebase_root_url(firebase_url)
    if device_name and not firebase_key:
        found = await fast_find_device_in_url(firebase_url, device_name, timeout=timeout)
        if found:
            return found

    candidates: list[str] = []
    if firebase_key:
        candidates.append(firebase_key.strip("/"))
    if device_name:
        name = device_name.strip("/")
        candidates.append(name)
        path_list = QUICK_DEVICE_PATHS if quick_only else DEVICE_PATHS
        for path in path_list:
            candidates.append(f"{path}/{name}")

    seen: set[str] = set()
    for path in candidates:
        if not path or path in seen:
            continue
        seen.add(path)
        record = await _fetch_device_node(root, path, timeout)
        if record:
            return record

    if quick_only:
        return None

    all_devices = await fetch_firebase_devices(firebase_url)
    query = (device_name or "").strip()
    key_query = (firebase_key or "").strip()
    for item in all_devices:
        item_key = str(item.get("firebase_key") or "")
        item_name = str(item.get("name") or "")
        if key_query and device_id_matches(key_query, item_key):
            return item
        if query and (device_id_matches(query, item_name) or device_id_matches(query, item_key)):
            return item
    return None


async def fetch_firebase_devices(firebase_url: str) -> list[dict]:
    base_url = normalize_firebase_url(firebase_url)
    root = firebase_root_url(firebase_url)
    parsed = urlparse(base_url)
    path = parsed.path.strip("/")
    if path.split("/")[-1].lower() in COLLECTION_SUFFIXES:
        path = path.split("/")[-1].lower()
    else:
        path = ""
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
            devices = consider(await _fetch_json(f"{root}/{path}.json"))
            if devices:
                return devices
        except httpx.HTTPError:
            pass

    for device_path in DEVICE_PATHS:
        try:
            data = await _fetch_json(f"{root}/{device_path}.json")
        except httpx.HTTPError:
            continue
        devices = consider(data, prefix=f"{device_path}/")
        if len(devices) > len(best_devices):
            best_devices = devices

    if best_devices:
        return best_devices

    try:
        data = await _fetch_json(f"{root}.json")
    except httpx.HTTPError as exc:
        raise ValueError(f"Firebase connect nahi hua: {exc}") from exc

    if data is None:
        return []

    return consider(data)
