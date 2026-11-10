#!/usr/bin/env python3
"""Parse Panda / Virtus Firebase credential dump → pool URL list + url|auth file."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

URL_RE = re.compile(
    r"https?://[a-zA-Z0-9._-]+(?:\.firebaseio\.com|\.firebasedatabase\.app)(?:/[^\s,\"']*)?",
    re.IGNORECASE,
)
URL_LINE = re.compile(r"(?:Firebase URL|📍|^URL:|Firebase:-)", re.IGNORECASE)
KEY_LINE = re.compile(r"(?:Auth Key|🔑|^KEY:)", re.IGNORECASE)
FLUSH_LINE = re.compile(r"(?:New Firebase Credentials|Panda Group)", re.IGNORECASE)
LOOSE_KEY = re.compile(
    r"^(?:secret|database\s*secret|firebase\s*secret|db\s*secret|token)\s*[:=]\s*(\S+)",
    re.IGNORECASE,
)


def normalize_firebase_url(raw: str) -> str:
    s = raw.strip().strip('"').strip("'").rstrip(",")
    while s.endswith("-"):
        s = s[:-1]
    s = s.rstrip("/")
    if not s.startswith("http"):
        s = f"https://{s}"
    return s.split()[0] if " " in s else s


def parse_panels(text: str) -> list[tuple[str, str]]:
    panels: dict[str, tuple[str, str]] = {}
    current_url: str | None = None
    current_key: str | None = None

    def flush() -> None:
        nonlocal current_url, current_key
        if not current_url:
            return
        url = normalize_firebase_url(current_url)
        key = (current_key or "").strip()
        low = url.lower()
        existing = panels.get(low)
        if existing is None or (key and not existing[1]):
            panels[low] = (url, key)
        current_url = None
        current_key = None

    for raw in text.splitlines():
        line = raw.strip()
        if FLUSH_LINE.search(line):
            flush()
            continue
        if URL_LINE.search(line):
            m = URL_RE.search(line)
            if m:
                flush()
                current_url = m.group(0)
        if KEY_LINE.search(line):
            v = line.split(":", 1)[-1].strip()
            v = re.sub(r"(?i)^auth\s*key", "", v).strip(": ").strip()
            if v and not v.lower().startswith("http"):
                current_key = v
        m_loose = LOOSE_KEY.match(line)
        if m_loose:
            current_key = m_loose.group(1).strip()
        if current_url is None:
            m = URL_RE.search(line)
            if m and not KEY_LINE.search(line):
                flush()
                current_url = m.group(0)

    flush()

    if not panels:
        seen: set[str] = set()
        for m in URL_RE.finditer(text):
            url = normalize_firebase_url(m.group(0))
            low = url.lower()
            if low not in seen:
                seen.add(low)
                panels[low] = (url, "")
    return list(panels.values())


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("input", type=Path)
    ap.add_argument("--out-dir", type=Path, default=Path("data"))
    args = ap.parse_args()
    text = args.input.read_text(encoding="utf-8", errors="replace")
    panels = parse_panels(text)
    args.out_dir.mkdir(parents=True, exist_ok=True)

    pool_path = args.out_dir / "firebase_pool.txt"
    auth_path = args.out_dir / "firebase_pool_auth.txt"
    merged_lines: list[str] = []
    auth_lines: list[str] = []

    existing = set()
    if pool_path.exists():
        for line in pool_path.read_text(encoding="utf-8", errors="ignore").splitlines():
            line = line.strip()
            if line and not line.startswith("#"):
                existing.add(line.lower())

    for url, key in sorted(panels, key=lambda x: x[0].lower()):
        if url.lower() not in existing:
            merged_lines.append(url)
            existing.add(url.lower())
        auth_lines.append(f"{url}|{key}" if key else url)

    if merged_lines:
        with pool_path.open("a", encoding="utf-8") as f:
            f.write("\n# Panda dump import\n")
            for u in merged_lines:
                f.write(u + "\n")

    auth_path.write_text("\n".join(auth_lines) + "\n", encoding="utf-8")
    with_key = sum(1 for _, k in panels if k)
    print(f"panels={len(panels)} new_urls={len(merged_lines)} with_auth={with_key}")
    print(f"wrote {pool_path} (append) and {auth_path}")


if __name__ == "__main__":
    main()
