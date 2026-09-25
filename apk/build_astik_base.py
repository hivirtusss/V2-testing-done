#!/usr/bin/env python3
"""Reset virtus_decompiled from Astik — minimal rename only (crash-safe)."""

from __future__ import annotations

import os
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent
ASTIK = ROOT / "reference/astik_decompiled"
OUT = ROOT / "virtus_decompiled"

CONFIG_DB = os.environ.get(
    "DEFAULT_CONFIG_DB",
    "https://base-e3797-default-rtdb.firebaseio.com",
).strip().rstrip("/")

REPLACEMENTS = (
    ("com/astik/module", "com/virtus/module"),
    ("com.astik.module", "com.virtus.module"),
    ("astik_module_prefs", "virtus_module_prefs"),
    ("AstikModule", "VirtusModule"),
    ("ASTIK SMS MODULE", "VIRTUS SMS MODULE"),
    ("Astik TEST OK", "Virtus TEST OK"),
    ("https://astik-module-default-rtdb.firebaseio.com/config/", f"{CONFIG_DB}/config/"),
    ("https://astik-module-default-rtdb.firebaseio.com", CONFIG_DB),
    ("astik-fb-retry", "virtus-fb-retry"),
    ("astik:keepalive", "virtus:keepalive"),
    ("astik_module_channel", "virtus_module_channel"),
)


def main() -> None:
    if not ASTIK.is_dir():
        raise SystemExit(f"Missing {ASTIK} — git pull latest")

    if OUT.exists():
        shutil.rmtree(OUT)
    shutil.copytree(ASTIK, OUT)

    astik_pkg = OUT / "smali/com/astik/module"
    virtus_pkg = OUT / "smali/com/virtus/module"
    virtus_pkg.parent.mkdir(parents=True, exist_ok=True)
    astik_pkg.rename(virtus_pkg)

    for path in list(OUT.rglob("*")):
        if not path.is_file():
            continue
        if path.suffix not in {".smali", ".xml", ".yml"} and path.name != "AndroidManifest.xml":
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        for old, new in REPLACEMENTS:
            text = text.replace(old, new)
        path.write_text(text, encoding="utf-8")

    print(f"virtus_decompiled = Astik clone (config DB={CONFIG_DB})")


if __name__ == "__main__":
    main()
