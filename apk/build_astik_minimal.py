#!/usr/bin/env python3
"""Astik APK — NO package rename, NO extra classes. Only Firebase URL for bot."""

from __future__ import annotations

import os
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent
ASTIK = ROOT / "reference/astik_decompiled"
OUT = ROOT / "virtus_decompiled"

CONFIG_DB = (
    os.environ.get("APK_CONFIG_DB")
    or os.environ.get("DEFAULT_CONFIG_DB")
    or "https://base-e3797-default-rtdb.firebaseio.com"
).strip().rstrip("/")

OLD = "https://astik-module-default-rtdb.firebaseio.com"


def main() -> None:
    if not ASTIK.is_dir():
        raise SystemExit(f"Missing {ASTIK}")

    if OUT.exists():
        shutil.rmtree(OUT)
    shutil.copytree(ASTIK, OUT)

    for path in OUT.rglob("*"):
        if not path.is_file():
            continue
        if path.suffix not in {".smali", ".xml", ".yml"}:
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        if OLD not in text:
            continue
        path.write_text(text.replace(OLD, CONFIG_DB), encoding="utf-8")

    print(f"Astik clone ready (package=com.astik.module, config DB={CONFIG_DB})")


if __name__ == "__main__":
    main()
