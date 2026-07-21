#!/usr/bin/env python3
"""Neutral in-app strings (log tags, overlay tag, prefs names)."""
from __future__ import annotations

import sys
from pathlib import Path

STEALTH_REPLACEMENTS = {
    "ZygiskMenu @Hivirtus": "Choreographer",
    "ZygiskMenuPoller": "SyncManager",
    "zygisk_floating_menu": "wm_overlay_host",
    "zygisk_menu_prefs": "acfg_prefs_v2",
    "zygisk_menu_socket": "acfg_local_sock",
}


def apply_string_stealth(smali_root: Path) -> None:
    for path in smali_root.rglob("*.smali"):
        text = path.read_text()
        orig = text
        for old, new in STEALTH_REPLACEMENTS.items():
            text = text.replace(old, new)
        if text != orig:
            path.write_text(text)


def main() -> None:
    apply_string_stealth(Path(sys.argv[1]))
    print("stealth string renames applied")


if __name__ == "__main__":
    main()
