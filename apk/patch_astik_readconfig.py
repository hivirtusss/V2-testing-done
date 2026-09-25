#!/usr/bin/env python3
"""Restore Astik-exact readConfig + runTest (no BotConfigSync, no bot HTTP)."""

from __future__ import annotations

import os
from pathlib import Path

_APK_DIR = Path(__file__).resolve().parent
ROOT = _APK_DIR / "virtus_decompiled/smali/com/virtus/module"
TGS = ROOT / "TelegramPollingService.smali"
MAIN = ROOT / "MainActivity.smali"
REF = _APK_DIR / "reference"
ASTIK_READ_CONFIG = REF / "astik_readConfig.smali"
ASTIK_RUN_TEST = REF / "astik_runTest.smali"

DEFAULT_CONFIG_DB = os.environ.get(
    "DEFAULT_CONFIG_DB",
    "https://base-e3797-default-rtdb.firebaseio.com",
).strip().rstrip("/")


def _config_db_url() -> str:
    return f"{DEFAULT_CONFIG_DB}/config/"


def _extract_method(text: str, signature: str) -> str:
    start = text.index(signature)
    end = text.index(".end method", start) + len(".end method")
    return text[start:end]


def _replace_method(text: str, signature: str, new_method: str) -> str:
    old = _extract_method(text, signature)
    return text.replace(old, new_method, 1)


def restore_read_config() -> None:
    if not ASTIK_READ_CONFIG.is_file():
        raise SystemExit(f"Missing {ASTIK_READ_CONFIG} — git pull latest")
    method = ASTIK_READ_CONFIG.read_text()
    method = method.replace("com/astik/module", "com/virtus/module")
    method = method.replace("AstikModule", "VirtusModule")
    method = method.replace(
        "https://astik-module-default-rtdb.firebaseio.com/config/",
        _config_db_url(),
    )

    virtus = _replace_method(TGS.read_text(), sig, method)
    TGS.write_text(virtus)
    print(f"readConfig restored (Astik-exact, config DB={DEFAULT_CONFIG_DB})")


def strip_bot_sync_artifacts() -> None:
    for name in ("BotConfigSync.smali", "MainActivity$BotSync.smali"):
        path = ROOT / name
        if path.exists():
            path.unlink()
            print(f"removed {name}")


def restore_run_test_astik() -> None:
    """Match Astik runTest — save KEY only, start TEST thread (no BotSync, no KEY|url)."""
    sig = ".method private runTest()V"
    if not ASTIK_RUN_TEST.is_file():
        raise SystemExit(f"Missing {ASTIK_RUN_TEST} — git pull latest")
    method = ASTIK_RUN_TEST.read_text().replace("com/astik/module", "com/virtus/module")
    text = _replace_method(MAIN.read_text(), sig, method)
    MAIN.write_text(text)
    print("runTest restored (Astik-exact KEY-only)")


def main() -> None:
    strip_bot_sync_artifacts()
    restore_read_config()
    restore_run_test_astik()


if __name__ == "__main__":
    main()
