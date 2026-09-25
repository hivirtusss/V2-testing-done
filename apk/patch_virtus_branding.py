#!/usr/bin/env python3
"""Rebrand APK UI: Astik → Virtus, purple → yellow/blue. No logic changes."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "virtus_decompiled"

# User-visible strings only (keep astik_module_prefs / package — no crash)
STRINGS = (
    ("ASTIK SMS MODULE — running", "VIRTUS SMS MODULE — running"),
    ("ASTIK SMS MODULE", "VIRTUS SMS MODULE"),
    ("ASTIK TEST OK — module alive", "VIRTUS TEST OK — module alive"),
    ("ASTIK TEST OK \u2014 module alive", "VIRTUS TEST OK \u2014 module alive"),
    ("PREMIUM INJECTION GATEWAY", "VIRTUS INJECTION GATEWAY"),
    ("Astik Module", "Virtus Module"),
    ("AstikModule", "VirtusModule"),
)

# Purple theme → yellow + blue (uptime/timer colors → yellow, accents → blue)
COLORS = {
    "#651FFF": "#1565C0",
    "#7C4DFF": "#FFB300",
    "#151B2E": "#0D2847",
    "#0D1220": "#051A30",
    "#2A3350": "#1E5090",
    "#3A4470": "#1565C0",
    "#0E1424": "#0A1F3D",
    "#69F0AE": "#FFD54F",
    "#00E676": "#FFC107",
    "#B388FF": "#42A5F5",
    "#0A0E1A": "#041224",
    "#E8EAF6": "#FFFDE7",
}


def patch_file(path: Path) -> bool:
    text = path.read_text(encoding="utf-8", errors="replace")
    original = text
    for old, new in STRINGS:
        text = text.replace(old, new)
    for old, new in COLORS.items():
        text = text.replace(old, new)
    if text != original:
        path.write_text(text, encoding="utf-8")
        return True
    return False


def main() -> None:
    if not OUT.is_dir():
        raise SystemExit(f"Run build_astik_minimal.py first — missing {OUT}")

    changed = 0
    for path in OUT.rglob("*"):
        if not path.is_file():
            continue
        if path.suffix not in {".smali", ".xml"}:
            continue
        if patch_file(path):
            changed += 1

    print(f"Virtus branding applied ({changed} files) — yellow/blue UI, name only")


if __name__ == "__main__":
    main()
