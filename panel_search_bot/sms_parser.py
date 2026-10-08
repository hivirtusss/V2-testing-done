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
SPAM_URL = re.compile(r"\b(?:bit\.ly|tinyurl|cutt\.ly|t\.me/|gg\.ly|rb\.gy|shorturl)\b", re.I)
SPAM_PHRASE = re.compile(
    r"(?:dear staffn|staffn bank|cibil a/c|bank detail rcvd|st\.?\s*columbus|uscsnp|"
    r"gaming wallet|juegos|click to view|click now|loan approved|personal loan offer|"
    r"win+\s*rs|lottery|free recharge)",
    re.I,
)
REAL_BANK_TXN = re.compile(
    r"\b(?:credited|debited|deposited|withdrawn|received|sent|transfer|txn|transaction|upi|neft|imps|rtgs)\b",
    re.I,
)
REAL_BANK_BAL = re.compile(
    r"(?:avl\.?\s*(?:bal|balance)|available\s*(?:bal|balance)|a/c\s*(?:bal|balance)|ac\s*bal|"
    r"bal(?:ance)?\s*[:.]?\s*(?:rs|inr|₹))",
    re.I,
)
MONEY_AMOUNT = re.compile(r"(?:rs\.?|inr|₹)\s*[\d,]+(?:\.\d{1,2})?", re.I)
KNOWN_BANK_SENDER = re.compile(
    r"(?:^|[\[-])(?:[A-Z]{2,}-)?(?:SBI|HDFC|ICICI|AXIS|KOTAK|PNB|BOB|CANARA|YES|IDFC|UBIN|"
    r"BARB|CNRB|INDB|FDRL|UCBA|BKID|CBIN|IOBA|UTIB|PUNB|AIRP|JIOP)",
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


def is_spam_sms(text: str, sender: str = "") -> bool:
    blob = f"{sender} {text}"
    if SPAM_URL.search(blob):
        return True
    if SPAM_PHRASE.search(blob):
        return True
    lower = text.lower()
    if "bank name cibil" in lower or "detail rcvd" in lower:
        return True
    return False


def is_bank_balance_sms(text: str) -> bool:
    return is_real_bank_sms(text)


def is_real_bank_sms(text: str, sender: str = "") -> bool:
    """Real bank balance / credit / debit SMS — not panel spam templates."""
    if is_spam_sms(text, sender):
        return False
    blob = f"{sender} {text}"
    if not (MONEY_AMOUNT.search(text) or parse_balance(text)):
        return False
    has_txn = bool(REAL_BANK_TXN.search(blob))
    has_bal = bool(REAL_BANK_BAL.search(blob))
    has_bank = bool(BANK_HINT.search(blob)) or bool(KNOWN_BANK_SENDER.search(sender))
    has_ac = bool(re.search(r"\ba/c\b|\baccount\b", text, re.I))
    if has_txn and (has_bank or has_ac or MONEY_AMOUNT.search(text)):
        return True
    if has_bal and (has_bank or KNOWN_BANK_SENDER.search(sender)):
        return True
    if has_txn and has_bal:
        return True
    return False


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
