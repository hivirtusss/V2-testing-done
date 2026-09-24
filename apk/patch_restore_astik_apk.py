#!/usr/bin/env python3
"""Strip Virtus APK extras — match Astik module exactly (inject-only, Firebase config/{KEY})."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path("/workspace/apk/virtus_decompiled/smali/com/virtus/module")
ASTIK_TGS = Path("/workspace/apk/astik-analysis/astik_decompiled/smali/com/astik/module/TelegramPollingService.smali")
VIRTUS_TGS = ROOT / "TelegramPollingService.smali"
MAIN = ROOT / "MainActivity.smali"
MODULE_DB = "https://virtus-module-default-rtdb.firebaseio.com"

EXTRA_SMALI = (
    "BotConfigSync.smali",
    "MainActivity$BotSync.smali",
    "OutgoingSmsSender.smali",
)


def strip_extra_smali() -> None:
    for name in EXTRA_SMALI:
        path = ROOT / name
        if path.exists():
            path.unlink()
            print(f"removed extra smali: {name}")


def _extract_method(text: str, method_name: str) -> str | None:
    pattern = rf"(\.method[^\n]*{re.escape(method_name)}[^\n]*\n.*?\.end method)"
    match = re.search(pattern, text, re.S)
    return match.group(1) if match else None


def _replace_method(text: str, method_name: str, new_method: str) -> str:
    pattern = rf"\.method[^\n]*{re.escape(method_name)}[^\n]*\n.*?\.end method"
    match = re.search(pattern, text, re.S)
    if not match:
        raise SystemExit(f"method not found: {method_name}")
    return text[: match.start()] + new_method + text[match.end() :]


def restore_astik_read_config() -> None:
    astik = ASTIK_TGS.read_text()
    method = _extract_method(astik, "readConfig")
    if not method:
        raise SystemExit("Astik readConfig not found")
    method = (
        method.replace("com/astik/module", "com/virtus/module")
        .replace("AstikModule", "VirtusModule")
        .replace("astik-module-default-rtdb", "virtus-module-default-rtdb")
        .replace("astik_module_prefs", "virtus_module_prefs")
    )
    virtus = VIRTUS_TGS.read_text()
    virtus = _replace_method(virtus, "readConfig", method)
    VIRTUS_TGS.write_text(virtus)
    print("readConfig restored to Astik style (module config/{KEY})")


def strip_main_activity_bot_sync() -> None:
    text = MAIN.read_text()
    original = text
    text = re.sub(
        r"\n    iget-object v3, v0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;.*?"
        r"invoke-virtual \{v5\}, Ljava/lang/Thread;->start\(\)V\n\n    \.line 232\n    :cond_0",
        "\n    .line 232\n    :cond_0",
        text,
        count=1,
        flags=re.S,
    )
    text = re.sub(
        r"\n    new-instance v1, Ljava/lang/Thread;\n\n    new-instance v2, Lcom/virtus/module/MainActivity\$BotSync;.*?"
        r"invoke-virtual \{v1\}, Ljava/lang/Thread;->start\(\)V\n\n    \.line 292\n    new-instance v0, Ljava/lang/Thread;",
        "\n    .line 292\n    new-instance v0, Ljava/lang/Thread;",
        text,
        count=1,
        flags=re.S,
    )
    if text != original:
        MAIN.write_text(text)
        print("MainActivity BotSync hooks removed")
    else:
        print("MainActivity BotSync already absent (skip)")


def main() -> None:
    strip_extra_smali()
    restore_astik_read_config()
    strip_main_activity_bot_sync()
    print("Virtus APK extras stripped — Astik match")


if __name__ == "__main__":
    main()
