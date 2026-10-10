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
