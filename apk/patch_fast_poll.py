#!/usr/bin/env python3
"""Faster APK inject poll — 250ms -> 100ms between Firebase message checks."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parent
TARGET = ROOT / "virtus_decompiled/smali/com/astik/module/TelegramPollingService$6.smali"

OLD = """    const-wide/16 v0, 0xfa

    .line 452
    :try_start_0
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V"""

NEW = """    const-wide/16 v0, 0x64

    .line 452
    :try_start_0
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V"""


def main() -> None:
    if not TARGET.is_file():
        raise SystemExit(f"Missing {TARGET}")
    text = TARGET.read_text(encoding="utf-8")
    if OLD not in text:
        if NEW.splitlines()[0] in text:
            print("Fast poll patch already applied")
            return
        raise SystemExit("poll sleep pattern not found")
    TARGET.write_text(text.replace(OLD, NEW, 1), encoding="utf-8")
    print("APK fast poll patch applied (100ms inject poll)")


if __name__ == "__main__":
    main()
