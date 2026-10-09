from __future__ import annotations

import re
from typing import Any


def _year_from_value(v: Any) -> str | None:
    if v is None:
        return None
    s = str(v).strip()
    if s.isdigit() and len(s) == 4 and s.startswith(("19", "20")):
        return s
    m = re.search(r"(20\d{2}|19\d{2})", s)
    return m.group(1) if m else None


def _years_from_uidai(data: dict[str, Any]) -> list[str]:
    years: list[str] = []
    seen: set[str] = set()

    def add(y: str | None) -> None:
        if y and y not in seen:
            seen.add(y)
            years.append(y)

    for key in ("yearOfBirth", "yob", "birthYear", "year"):
        add(_year_from_value(data.get(key)))
    for key in ("dob", "dateOfBirth", "dobValue", "birthDate"):
        add(_year_from_value(data.get(key)))

    stack: list[Any] = [data]
    while stack:
        node = stack.pop()
        if isinstance(node, dict):
            for k, v in node.items():
                kl = str(k).lower()
                if kl in ("yearofbirth", "yob", "birthyear", "year"):
                    add(_year_from_value(v))
                elif kl in ("dob", "dateofbirth", "dobvalue", "birthdate"):
                    add(_year_from_value(v))
                elif isinstance(v, (dict, list)):
                    stack.append(v)
        elif isinstance(node, list):
            stack.extend(node)
    return years


def name_prefix_variants(name: str) -> list[str]:
    """UIDAI e-Aadhaar password name part (first 4 chars, multiple spellings)."""
    cleaned = re.sub(r"\s+", " ", name.strip())
    if not cleaned:
        return ["AADH"]
    upper = cleaned.upper()
    compact = upper.replace(" ", "")
    out: list[str] = []
    seen: set[str] = set()

    def add(s: str) -> None:
        s = s[:4]
        if len(s) >= 3 and s not in seen:
            seen.add(s)
            out.append(s)

    add(compact)
    add(upper)
    parts = upper.split()
    if parts:
        add(parts[0])
        add("".join(parts))
    if "." in upper:
        add(upper.replace(" ", ""))
    return out or ["AADH"]


def brute_birth_years(
    uidai_data: dict[str, Any] | None,
    *,
    year_from: int = 1960,
    year_to: int = 2012,
) -> list[str]:
    """DOB auto: UIDAI response first, then common year scan (newest first)."""
    years = _years_from_uidai(uidai_data or {})
    for y in range(year_to, year_from - 1, -1):
        ys = str(y)
        if ys not in years:
            years.append(ys)
    return years


def password_candidates(
    name: str,
    uidai_data: dict[str, Any] | None = None,
    *,
    year_from: int = 1960,
    year_to: int = 2012,
    max_candidates: int = 800,
) -> list[str]:
    prefixes = name_prefix_variants(name)
    years = brute_birth_years(uidai_data, year_from=year_from, year_to=year_to)
    candidates: list[str] = []
    seen: set[str] = set()
    for prefix in prefixes:
        for year in years:
            pwd = f"{prefix}{year}"
            if pwd not in seen:
                seen.add(pwd)
                candidates.append(pwd)
            if len(candidates) >= max_candidates:
                return candidates
    return candidates


def pdf_password_hint(name: str, uidai_data: dict[str, Any] | None = None) -> str:
    data = uidai_data or {}
    years = _years_from_uidai(data)
    year = years[0] if years else "2003"
    return name_prefix_variants(name)[0] + year
