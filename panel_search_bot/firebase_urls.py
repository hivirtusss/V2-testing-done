import re
from urllib.parse import urlparse

FIREBASE_URL_RE = re.compile(
    r"https?://[a-zA-Z0-9._-]+(?:\.firebaseio\.com|\.firebasedatabase\.app)(?:/[^\s,|\"']*)?",
    re.I,
)
BARE_HOST_RE = re.compile(
    r"(?<![/\w@])([a-zA-Z0-9._-]+(?:-default-rtdb)?(?:\.[a-z0-9-]+)?\.(?:firebaseio\.com|firebasedatabase\.app))(?![/\w])",
    re.I,
)

FIREBASE_REGIONS = (
    "",
    "asia-southeast1",
    "europe-west1",
    "us-central1",
    "asia-south1",
)


def normalize_firebase_url(url: str) -> str:
    cleaned = url.strip().rstrip("/").strip("\"'")
    if not cleaned.startswith(("http://", "https://")):
        cleaned = f"https://{cleaned}"
    if ".firebaseio.com" not in cleaned and ".firebasedatabase.app" not in cleaned:
        raise ValueError("Not a Firebase RTDB URL")
    parsed = urlparse(cleaned)
    return f"{parsed.scheme}://{parsed.netloc}".rstrip("/")


def _project_id_from_host(host: str) -> str | None:
    host = host.lower()
    if host.endswith(".firebaseio.com"):
        project = host.replace(".firebaseio.com", "").split(".")[0]
    elif ".firebasedatabase.app" in host:
        part = host.split(".firebasedatabase.app")[0]
        if part.endswith("-default-rtdb"):
            project = part[: -len("-default-rtdb")].split(".")[-1]
        else:
            project = part.split(".")[-1]
    else:
        return None
    # Host is often already "{id}-default-rtdb.firebaseio.com" — don't double suffix.
    if project.endswith("-default-rtdb"):
        project = project[: -len("-default-rtdb")]
    return project or None


def firebase_url_variants(base: str) -> list[str]:
    """Try stored URL first, then legacy firebaseio.com and regional app URLs."""
    base = normalize_firebase_url(base)
    parsed = urlparse(base)
    host = parsed.netloc.lower()
    project = _project_id_from_host(host)
    if not project:
        return [base]

    variants: list[str] = []
    seen: set[str] = set()

    def add(url: str) -> None:
        if url not in seen:
            seen.add(url)
            variants.append(url)

    add(base)
    add(f"https://{project}-default-rtdb.firebaseio.com")
    for region in FIREBASE_REGIONS:
        if region:
            add(f"https://{project}-default-rtdb.{region}.firebasedatabase.app")
        else:
            add(f"https://{project}-default-rtdb.firebasedatabase.app")
    return variants


_DEVICE_MARKERS = frozenset(
    {
        "devices",
        "device",
        "phones",
        "phone",
        "clients",
        "client",
        "users",
        "user",
        "imei",
        "android",
    }
)
_SMS_MARKERS = frozenset({"messages", "sms", "inbox", "sms_list", "smslist", "data"})


def firebase_db_label(url: str) -> str:
    try:
        norm = normalize_firebase_url(url)
    except ValueError:
        return url[:80]
    host = urlparse(norm).netloc.lower()
    project = _project_id_from_host(host)
    if project:
        return project[:120]
    return host[:120]


def device_id_from_raw_path(raw_path: str) -> str:
    if not raw_path or raw_path in ("root", "/"):
        return "unknown"
    parts = [p for p in raw_path.replace("\\", "/").split("/") if p and p != "."]
    if not parts:
        return "unknown"
    lowered = [p.lower() for p in parts]
    for marker in _DEVICE_MARKERS:
        if marker in lowered:
            idx = lowered.index(marker)
            if idx + 1 < len(parts):
                candidate = parts[idx + 1]
                if candidate.lower() not in _SMS_MARKERS and not candidate.isdigit():
                    return candidate[:128]
    if lowered[0] in _SMS_MARKERS and len(parts) >= 2:
        candidate = parts[1]
        if candidate.lower() not in _SMS_MARKERS and not candidate.isdigit():
            return candidate[:128]
    for i, part in enumerate(lowered):
        if part in _SMS_MARKERS and i > 0:
            prev = parts[i - 1]
            if prev.lower() not in _SMS_MARKERS and not prev.isdigit():
                return prev[:128]
    for p in parts:
        if len(p) >= 8 and not p.isdigit() and p.lower() not in _DEVICE_MARKERS:
            return p[:128]
    return parts[-1][:128] if parts else "unknown"


def extract_firebase_urls(text: str) -> list[str]:
    found: list[str] = []
    seen: set[str] = set()
    for match in FIREBASE_URL_RE.finditer(text):
        try:
            norm = normalize_firebase_url(match.group(0))
        except ValueError:
            continue
        if norm not in seen:
            seen.add(norm)
            found.append(norm)
    for match in BARE_HOST_RE.finditer(text):
        try:
            norm = normalize_firebase_url(match.group(1))
        except ValueError:
            continue
        if norm not in seen:
            seen.add(norm)
            found.append(norm)
    return found
