import re
from datetime import datetime, timezone

BALANCE_PATTERNS = [
    re.compile(r"(?:avl|available|a/c|ac)\s*(?:bal|balance)?\s*[:.]?\s*(?:rs\.?|inr|₹)?\s*([\d,]+(?:\.\d{1,2})?)", re.I),
    re.compile(r"(?:bal|balance)\s*[:.]?\s*(?:rs\.?|inr|₹)?\s*([\d,]+(?:\.\d{1,2})?)", re.I),
    re.compile(r"(?:rs\.?|inr|₹)\s*([\d,]+(?:\.\d{1,2})?)", re.I),
]
PIN_PATTERN = re.compile(r"\b(?:pin|otp|mpin|upi\s*pin)\b", re.I)
BANK_HINT = re.compile(r"\b(?:bank|sbi|hdfc|icici|axis|kotak|pnb|bob|idfc|yes|canara|union|paytm|phonepe|gpay)\b", re.I)

TS_FIELDS = (
    "timestamp",
    "time",
    "date",
    "received_at",
    "receivedAt",
    "created_at",
    "createdAt",
    "sent_at",
    "sentAt",
    "ts",
    "t",
)


def parse_balance(text: str) -> float | None:
    for pattern in BALANCE_PATTERNS:
        match = pattern.search(text)
        if match:
            raw = match.group(1).replace(",", "")
            try:
                return float(raw)
            except ValueError:
                continue
    return None


def message_has_pin(text: str) -> bool:
    return bool(PIN_PATTERN.search(text))


def parse_timestamp(value) -> datetime | None:
    if value is None:
        return None
    if isinstance(value, (int, float)):
        ts = float(value)
        if ts > 1e12:
            ts /= 1000.0
        if ts > 1e9:
            return datetime.fromtimestamp(ts, tz=timezone.utc).replace(tzinfo=None)
        return None
    if isinstance(value, str):
        cleaned = value.strip()
        if cleaned.isdigit():
            return parse_timestamp(int(cleaned))
        for fmt in (
            "%Y-%m-%d %H:%M:%S",
            "%Y-%m-%dT%H:%M:%S",
            "%Y-%m-%dT%H:%M:%SZ",
            "%d-%m-%Y %H:%M:%S",
            "%d/%m/%Y %H:%M:%S",
        ):
            try:
                return datetime.strptime(cleaned[:19], fmt)
            except ValueError:
                continue
    return None


def extract_message_fields(node: dict) -> tuple[str, str, datetime | None]:
    sender = str(
        node.get("sender")
        or node.get("from")
        or node.get("address")
        or node.get("phone")
        or node.get("number")
        or ""
    )
    body = str(
        node.get("message")
        or node.get("body")
        or node.get("text")
        or node.get("content")
        or node.get("sms")
        or ""
    )
    ts = None
    for key in TS_FIELDS:
        if key in node:
            ts = parse_timestamp(node.get(key))
            if ts:
                break
    return sender, body, ts


def looks_like_sms(node: dict) -> bool:
    if not isinstance(node, dict):
        return False
    _, body, _ = extract_message_fields(node)
    if len(body) < 4:
        return False
    lower = body.lower()
    if any(k in lower for k in ("sms", "message", "otp", "debited", "credited", "avl", "bal", "bank", "a/c")):
        return True
    return bool(BANK_HINT.search(body))
