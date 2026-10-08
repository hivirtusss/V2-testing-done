import re
from datetime import datetime, timezone

AVL_BALANCE_PATTERNS = [
    re.compile(
        r"(?:available|avl\.?)\s*(?:bal\.?|balance)?\s*[:.]?\s*(?:is\s*)?(?:rs\.?|inr|₹)?\s*([\d,]+(?:\.\d{1,2})?)",
        re.I,
    ),
    re.compile(
        r"(?:a/c|ac)\s*(?:bal\.?|balance)\s*[:.]?\s*(?:rs\.?|inr|₹)?\s*([\d,]+(?:\.\d{1,2})?)",
        re.I,
    ),
    re.compile(
        r"(?:bal\.?|balance)\s*[:.]?\s*(?:rs\.?|inr|₹)?\s*([\d,]+(?:\.\d{1,2})?)\s*(?:is\s*)?(?:available|avl)",
        re.I,
    ),
]
OTHER_BALANCE_PATTERNS = [
    re.compile(r"(?:bal|balance)\s*[:.]?\s*(?:rs\.?|inr|₹)?\s*([\d,]+(?:\.\d{1,2})?)", re.I),
]
PIN_PATTERN = re.compile(r"\b(?:pin|otp|mpin|upi\s*pin)\b", re.I)
BANK_HINT = re.compile(
    r"\b(?:bank|sbi|hdfc|icici|axis|kotak|pnb|bob|idfc|yes|canara|union|paytm|phonepe|gpay|credit|debit)\b",
    re.I,
)
BANK_TXN_HINT = re.compile(
    r"\b(?:credited|debited|credit|debit|avl|available|a/c|ac\s*bal|balance)\b",
    re.I,
)

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


def _to_amount(raw: str) -> float | None:
    try:
        return float(raw.replace(",", ""))
    except ValueError:
        return None


def parse_balance(text: str) -> float | None:
    avl_amounts: list[float] = []
    for pattern in AVL_BALANCE_PATTERNS:
        for match in pattern.finditer(text):
            amount = _to_amount(match.group(1))
            if amount is not None:
                avl_amounts.append(amount)
    if avl_amounts:
        return max(avl_amounts)

    other: list[float] = []
    for pattern in OTHER_BALANCE_PATTERNS:
        for match in pattern.finditer(text):
            amount = _to_amount(match.group(1))
            if amount is not None:
                other.append(amount)
    if other:
        return max(other)
    return None


def message_has_pin(text: str) -> bool:
    return bool(PIN_PATTERN.search(text))


def is_bank_balance_sms(text: str) -> bool:
    if not BANK_HINT.search(text) and "bank" not in text.lower():
        return False
    return bool(BANK_TXN_HINT.search(text))


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
