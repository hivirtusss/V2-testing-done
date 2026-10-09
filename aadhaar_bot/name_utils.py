from __future__ import annotations

import re

_MULTI_SPACE = re.compile(r"\s+")
_TITLE_TOKENS = frozenset(
    {
        "MR",
        "MRS",
        "MS",
        "DR",
        "SHRI",
        "SMT",
        "KUMARI",
        "LATE",
    }
)


def prepare_holder_name(raw: str) -> tuple[str, str]:
    """Return (display name, primary uppercase query name for UIDAI)."""
    display = _MULTI_SPACE.sub(" ", raw.strip())
    return display, display.upper()


def _normalize_upper(name: str) -> str:
    return _MULTI_SPACE.sub(" ", name.strip()).upper()


def _swap_word_order(name: str) -> str | None:
    parts = name.split()
    if len(parts) < 2:
        return None
    return " ".join(reversed(parts))


def _alias_variants(word: str) -> list[str]:
    w = word.upper().strip(".")
    out: list[str] = [w]
    if w in ("MOHD", "MD", "MUHD", "MO", "M"):
        out.extend(["MOHAMMED", "MUHAMMAD", "MUHAMMED"])
    if w in ("MOHAMMED", "MUHAMMAD", "MUHAMMED", "MOHAMMAD"):
        out.extend(["MOHD", "MD"])
    if w == "MO":
        out.append("MOHD")
    seen: set[str] = set()
    uniq: list[str] = []
    for x in out:
        if x not in seen:
            seen.add(x)
            uniq.append(x)
    return uniq


def _expand_name_aliases(name: str) -> list[str]:
    parts = name.split()
    if not parts:
        return [name]
    per_part = [_alias_variants(p) for p in parts]
    results: list[str] = [name]

    def backtrack(i: int, acc: list[str]) -> None:
        if i == len(per_part):
            results.append(" ".join(acc))
            return
        for variant in per_part[i]:
            backtrack(i + 1, acc + [variant])

    backtrack(0, [])
    seen: set[str] = set()
    uniq: list[str] = []
    for r in results:
        n = _normalize_upper(r)
        if n not in seen:
            seen.add(n)
            uniq.append(n)
    return uniq


def _without_titles(name: str) -> str | None:
    parts = [p for p in name.split() if p not in _TITLE_TOKENS]
    if not parts or len(parts) == len(name.split()):
        return None
    return " ".join(parts)


def uidai_name_candidates(raw: str, *, max_out: int = 12) -> list[str]:
    """
    UIDAI name tries: as typed, reversed order, Mohd/Mohammed aliases, title strip.
    """
    base = _normalize_upper(raw)
    if not base:
        return ["AADHAAR"]

    pool: list[str] = []
    seen: set[str] = set()

    def add(n: str) -> None:
        n = _normalize_upper(n)
        if len(n) < 2 or n in seen:
            return
        seen.add(n)
        pool.append(n)

    add(base)
    if base != base.title():
        add(base.title())
    rev = _swap_word_order(base)
    if rev:
        add(rev)
    for v in _expand_name_aliases(base):
        add(v)
        r2 = _swap_word_order(v)
        if r2:
            add(r2)
    stripped = _without_titles(base)
    if stripped:
        add(stripped)
        for v in _expand_name_aliases(stripped):
            add(v)
            r3 = _swap_word_order(v)
            if r3:
                add(r3)

    return pool[:max_out]
