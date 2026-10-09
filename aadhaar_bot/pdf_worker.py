from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from aadhaar_bot.config import get_settings
from aadhaar_bot.pdf_password import password_candidates, pdf_password_hint


@dataclass
class UnlockResult:
    pdf_bytes: bytes
    password: str | None
    unlocked: bool


def _is_encrypted(pdf_bytes: bytes) -> bool:
    if not pdf_bytes or pdf_bytes[:4] != b"%PDF":
        return False
    try:
        from pypdf import PdfReader
    except ImportError:
        return b"/Encrypt" in pdf_bytes[:4096]
    import io

    try:
        reader = PdfReader(io.BytesIO(pdf_bytes))
        return bool(reader.is_encrypted)
    except Exception:
        return b"/Encrypt" in pdf_bytes[:8192]


def unlock_pdf(
    pdf_bytes: bytes,
    holder_name: str,
    uidai_data: dict[str, Any] | None = None,
) -> UnlockResult:
    """Try UIDAI-style passwords (name4 + YYYY). DOB years from API + brute range."""
    if not pdf_bytes:
        return UnlockResult(pdf_bytes=b"", password=None, unlocked=False)

    settings = get_settings()
    hint = pdf_password_hint(holder_name, uidai_data)
    candidates = password_candidates(
        holder_name,
        uidai_data,
        year_from=settings.aadhaar_pdf_year_from,
        year_to=settings.aadhaar_pdf_year_to,
    )
    if hint not in candidates:
        candidates.insert(0, hint)

    if not _is_encrypted(pdf_bytes):
        return UnlockResult(pdf_bytes=pdf_bytes, password=hint, unlocked=True)

    try:
        from pypdf import PdfReader, PdfWriter
    except ImportError as e:
        raise RuntimeError("pip install pypdf") from e

    import io

    for pwd in candidates:
        try:
            reader = PdfReader(io.BytesIO(pdf_bytes))
            if reader.is_encrypted and not reader.decrypt(pwd):
                continue
            writer = PdfWriter()
            for page in reader.pages:
                writer.add_page(page)
            out = io.BytesIO()
            writer.write(out)
            return UnlockResult(pdf_bytes=out.getvalue(), password=pwd, unlocked=True)
        except Exception:
            continue

    return UnlockResult(pdf_bytes=pdf_bytes, password=None, unlocked=False)
