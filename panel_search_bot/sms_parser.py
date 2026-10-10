import re
from datetime import datetime, timedelta, timezone

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
PIN_PATTERN = re.compile(
    r"\b(?:upi\s*pin|mpin|m-pin|atm\s*pin|pin\s*set|set\s+(?:your\s+)?(?:upi\s+)?pin|"
    r"pin\s*generated|pin\s*is|enter\s+(?:upi\s+)?pin|use\s+(?:upi\s+)?pin)\b",
    re.I,
)
PIN_LOOSE = re.compile(r"\b(?:upi\s*pin|mpin)\b", re.I)
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
    r"win+\s*rs|lottery|free recharge|bank name cibil|staffn bank name|"
    r"kyc pending|update kyc|click here|limited period|pre-?approved loan|"
    r"credit card offer|apply now|cashback offer|survey|congratulations you won|"
    r"whatsapp group|telegram channel|job offer|work from home)",
    re.I,
)
OTP_NO_TXN = re.compile(
    r"\b(?:otp|one[\s-]?time\s+password|verification code)\b",
    re.I,
)
PIN_SETUP_ONLY = re.compile(
    r"\b(?:pin\s*set|set\s+(?:your\s+)?(?:upi\s+)?pin|pin\s*generated|create\s+upi\s+pin|"
    r"register\s+upi|upi\s*registration)\b",
    re.I,
)
SPAM_SENDER = re.compile(r"(?:uscsnp|ucsn|staffn|columbus|promo|offer|loan|win)", re.I)
FASTAG_HINT = re.compile(
    r"\b(?:fast\s*tag|fastag|fas\s*tag|netc\b|nhai|toll\s*plaza|tag\s*bal|tag\s*recharge|"
    r"vehicle\s*no|vrn\b|tag\s*id|paytm\s*fastag|icici\s*fastag|hdfc\s*fastag|axis\s*fastag|"
    r"sbi\s*fastag|bajaj\s*fastag|idfc\s*fastag|airtel\s*payments\s*bank\s*fastag)\b",
    re.I,
)
REAL_BANK_TXN = re.compile(
    r"\b(?:credited|debited|deposited|withdrawn|received|sent|send|paid|pay|transfer|transferred|txn|"
    r"transaction|upi|neft|imps|rtgs|ecs|nach|emi|autopay|deducted|refund|purchase|spent|"
    r"payment successful|money sent|amt sent)\b",
    re.I,
)
DR_CR_AC = re.compile(
    r"(?:\bdr\.?\s*from|\bcr\.?\s*to|debited from|credited to|sent to|received from|paid to|"
    r"has been debited|has been credited|amount of rs|amt sent|money sent|a/c \*+|ac no)",
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
    r"BARB|CNRB|INDB|FDRL|UCBA|BKID|CBIN|IOBA|UTIB|PUNB|AIRP|JIOP|BAJAJ|FEDERAL|RBL|CSBK|"
    r"SVCB|KVB|TMB|DBS|SCBL|NSDL|EPFO|VM-[A-Z]|TX-[A-Z]|BK-[A-Z])",
    re.I,
)

BODY_DATE_DMY = re.compile(
    r"\b(?:on|dt\.?|dated?|as on)?\s*(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})(?:\s+\d{1,2}:\d{2})?",
    re.I,
)
BODY_DATE_YMD = re.compile(r"\b(\d{4})[/-](\d{1,2})[/-](\d{1,2})\b")
BODY_DATE_YMD_SPACE = re.compile(r"Date:\s*(\d{4})\s+(\d{1,2})/(\d{1,2})", re.I)
BODY_DATE_DMONY = re.compile(
    r"\b(\d{1,2})[-\s](Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*[-\s](\d{2,4})\b",
    re.I,
)
_MONTH = {
    "jan": 1,
    "feb": 2,
    "mar": 3,
    "apr": 4,
    "may": 5,
    "jun": 6,
    "jul": 7,
    "aug": 8,
    "sep": 9,
    "oct": 10,
    "nov": 11,
    "dec": 12,
}

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
    if not text:
        return False
    if PIN_PATTERN.search(text) or PIN_LOOSE.search(text):
        return True
    lower = text.lower()
    if "pin" in lower and any(x in lower for x in ("upi", "mpin", "atm", "set", "enter", "share")):
        return bool(re.search(r"\bpin\b", lower))
    return False


def device_has_upi_pin(messages: list) -> bool:
    return any(getattr(m, "has_pin", False) or message_has_pin(getattr(m, "body", "")) for m in messages)


def is_spam_sms(text: str, sender: str = "") -> bool:
    blob = f"{sender} {text}"
    if SPAM_URL.search(blob):
        return True
    if SPAM_PHRASE.search(blob):
        return True
    if sender and SPAM_SENDER.search(sender):
        return True
    lower = text.lower()
    if "bank name cibil" in lower or "detail rcvd" in lower:
        return True
    if re.search(r"\b[a-z]{2}-uscsnp-s\b", blob, re.I):
        return True
    return False


def is_fastag_sms(text: str, sender: str = "") -> bool:
    return bool(FASTAG_HINT.search(f"{sender} {text}"))


def is_otp_only_sms(text: str, sender: str = "") -> bool:
    blob = f"{sender} {text}"
    if not OTP_NO_TXN.search(blob):
        return False
    if REAL_BANK_TXN.search(blob) or REAL_BANK_BAL.search(blob) or DR_CR_AC.search(blob):
        return False
    if parse_balance(text) is not None:
        return False
    return True


def _has_money_movement(text: str, sender: str = "") -> bool:
    blob = f"{sender} {text}"
    if parse_balance(text) is not None:
        return True
    if REAL_BANK_BAL.search(blob) or DR_CR_AC.search(blob):
        return True
    if re.search(
        r"\b(?:credited|debited|received|sent|send|paid|withdrawn|deposited|refund|purchase|"
        r"deducted|transfer(?:red)?|neft|imps|rtgs)\b",
        blob,
        re.I,
    ):
        return True
    if re.search(r"\bupi\b", blob, re.I) and MONEY_AMOUNT.search(text):
        return True
    return False


def is_pin_setup_only_sms(text: str, sender: str = "") -> bool:
    """UPI/PIN setup SMS without credit/debit/balance — not a bank txn SMS."""
    blob = f"{sender} {text}"
    if not message_has_pin(text) and not PIN_SETUP_ONLY.search(blob):
        return False
    if _has_money_movement(text, sender):
        return False
    return True


def is_junk_sms(text: str, sender: str = "") -> bool:
    if is_spam_sms(text, sender) or is_fastag_sms(text, sender):
        return True
    if is_otp_only_sms(text, sender):
        return True
    return False


def is_bank_balance_sms(text: str, sender: str = "") -> bool:
    return is_bank_transaction_sms(text, sender)


def is_real_bank_sms(text: str, sender: str = "") -> bool:
    return is_bank_transaction_sms(text, sender)


def is_bank_transaction_sms(text: str, sender: str = "") -> bool:
    """Bank SMS: credit/debit/received/sent/UPI/balance — spam excluded."""
    if is_junk_sms(text, sender):
        return False
    if is_pin_setup_only_sms(text, sender):
        return False
    blob = f"{sender} {text}"
    lower = text.lower()
    has_money = bool(MONEY_AMOUNT.search(text) or parse_balance(text))
    has_txn = bool(REAL_BANK_TXN.search(blob) or DR_CR_AC.search(blob))
    has_bal = bool(REAL_BANK_BAL.search(blob) or BANK_TXN_HINT.search(blob))
    has_bank = bool(BANK_HINT.search(blob)) or bool(KNOWN_BANK_SENDER.search(sender))
    has_ac = bool(re.search(r"\ba/c\b|\bac\b|\baccount\b", lower))

    if KNOWN_BANK_SENDER.search(sender) and (has_txn or has_bal or has_money):
        return True
    if has_txn and (has_money or has_ac or has_bank):
        return True
    if has_bal and (has_bank or has_ac):
        return True
    if DR_CR_AC.search(blob) and has_money:
        return True
    if re.search(r"\b(inr|rs\.?)\s*[\d,]", lower) and has_txn and (has_bank or has_ac):
        return True
    return False


def _normalize_year(year: int) -> int:
    if year < 100:
        return 2000 + year if year <= 70 else 1900 + year
    return year


def parse_date_from_sms_body(text: str) -> datetime | None:
    """Best-effort transaction date from SMS body (when Firebase has no timestamp)."""
    if not text:
        return None
    candidates: list[datetime] = []

    for match in BODY_DATE_DMY.finditer(text):
        day, month, year = int(match.group(1)), int(match.group(2)), _normalize_year(int(match.group(3)))
        try:
            candidates.append(datetime(year, month, day))
        except ValueError:
            continue

    for match in BODY_DATE_YMD.finditer(text):
        year, month, day = int(match.group(1)), int(match.group(2)), int(match.group(3))
        try:
            candidates.append(datetime(year, month, day))
        except ValueError:
            continue

    for match in BODY_DATE_YMD_SPACE.finditer(text):
        year, month, day = int(match.group(1)), int(match.group(2)), int(match.group(3))
        try:
            candidates.append(datetime(year, month, day))
        except ValueError:
            continue

    for match in BODY_DATE_DMONY.finditer(text):
        day = int(match.group(1))
        month = _MONTH.get(match.group(2).lower()[:3], 0)
        year = _normalize_year(int(match.group(3)))
        if month:
            try:
                candidates.append(datetime(year, month, day))
            except ValueError:
                continue

    if not candidates:
        return None

    now = datetime.utcnow()
    valid = [dt for dt in candidates if 2015 <= dt.year <= now.year + 1 and dt <= now + timedelta(days=1)]
    if not valid:
        return None
    # Prefer the txn date closest to today (avoid random old footer dates when multiple present).
    return max(valid)


def effective_message_at(message_at: datetime | None, body: str) -> datetime | None:
    """Display/sort date: SMS body txn date first; never inflate with Firebase sync time."""
    body_dt = parse_date_from_sms_body(body)
    if body_dt is not None:
        return body_dt
    return message_at


def transaction_date_for_filter(
    message_at: datetime | None,
    body: str,
    *,
    days_filter_active: bool,
) -> datetime | None:
    """Day filter: only SMS with a parseable txn date in body (sync time is unreliable)."""
    body_dt = parse_date_from_sms_body(body)
    if body_dt is not None:
        return body_dt
    if days_filter_active:
        return None
    return message_at


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
    if ts is None:
        ts = parse_date_from_sms_body(body)
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
