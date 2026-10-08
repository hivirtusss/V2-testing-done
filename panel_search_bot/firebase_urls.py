import re

FIREBASE_URL_RE = re.compile(
    r"https?://[a-zA-Z0-9._-]+(?:\.firebaseio\.com|\.firebasedatabase\.app)(?:/[^\s,|\"']*)?",
    re.IGNORECASE,
)
BARE_HOST_RE = re.compile(
    r"(?<![/\w@])([a-zA-Z0-9._-]+(?:-default-rtdb)?\.(?:firebaseio\.com|firebasedatabase\.app))(?![/\w])",
    re.IGNORECASE,
)


def normalize_firebase_url(url: str) -> str:
    cleaned = url.strip().rstrip("/").strip("\"'")
    if not cleaned.startswith(("http://", "https://")):
        cleaned = f"https://{cleaned}"
    if ".firebaseio.com" not in cleaned and ".firebasedatabase.app" not in cleaned:
        raise ValueError("Not a Firebase RTDB URL")
    # Drop trailing path segments for base URL (search uses root .json)
    from urllib.parse import urlparse

    parsed = urlparse(cleaned)
    base = f"{parsed.scheme}://{parsed.netloc}"
    return base.rstrip("/")


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
