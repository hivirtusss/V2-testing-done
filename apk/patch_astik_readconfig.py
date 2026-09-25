#!/usr/bin/env python3
"""Restore Astik-exact readConfig + runTest (no BotConfigSync, no bot HTTP)."""

from __future__ import annotations

import os
from pathlib import Path

_APK_DIR = Path(__file__).resolve().parent
ROOT = _APK_DIR / "virtus_decompiled/smali/com/virtus/module"
TGS = ROOT / "TelegramPollingService.smali"
MAIN = ROOT / "MainActivity.smali"
ASTIK_TGS = (
    _APK_DIR / "astik-analysis/astik_decompiled/smali/com/astik/module/TelegramPollingService.smali"
)

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
    sig = ".method private readConfig(Landroid/content/SharedPreferences;)V"
    astik = ASTIK_TGS.read_text()
    method = _extract_method(astik, sig)
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
    astik_main = (
        _APK_DIR / "astik-analysis/astik_decompiled/smali/com/astik/module/MainActivity.smali"
    ).read_text()
    method = _extract_method(astik_main, sig).replace("com/astik/module", "com/virtus/module")
    text = _replace_method(MAIN.read_text(), sig, method)
    MAIN.write_text(text)
    print("runTest restored (Astik-exact KEY-only)")


def main() -> None:
    strip_bot_sync_artifacts()
    restore_read_config()
    restore_run_test_astik()


if __name__ == "__main__":
    main()
