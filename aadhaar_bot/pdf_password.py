from __future__ import annotations

import re
from typing import Any


def _name_four(name: str) -> str:
    """UIDAI PDF password: first 4 letters of name (CAPS), spaces kept for 'P. KUMAR' style."""
    cleaned = re.sub(r"\s+", " ", name.strip())
    if not cleaned:
        return "AADH"
    compact = cleaned.replace(" ", "")
    return compact[:4].upper()


def _year_from_data(data: dict[str, Any]) -> str:
    for key in ("yearOfBirth", "yob", "birthYear"):
        v = data.get(key)
        if v and str(v).isdigit() and len(str(v)) == 4:
            return str(v)
    dob = data.get("dob") or data.get("dateOfBirth")
    if dob:
        m = re.search(r"(20\d{2}|19\d{2})", str(dob))
        if m:
            return m.group(1)
    return "2003"


def pdf_password_hint(name: str, uidai_data: dict[str, Any] | None = None) -> str:
    data = uidai_data or {}
    return _name_four(name) + _year_from_data(data)
