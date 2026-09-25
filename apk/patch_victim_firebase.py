#!/usr/bin/env python3
"""Strip dead smali only — config flow is Astik-exact via patch_astik_readconfig.py."""

from pathlib import Path

ROOT = Path(__file__).resolve().parent / "virtus_decompiled/smali/com/virtus/module"

DEAD_SMALI = (
    "LicenseKeyValidator.smali",
    "LicenseKeyReporter.smali",
    "LicenseKeyReporter$1.smali",
    "PermissionHelper.smali",
    "RootHelper.smali",
    "BotConfigSync.smali",
    "MainActivity$BotSync.smali",
)


def strip_dead_smali() -> None:
    for name in DEAD_SMALI:
        path = ROOT / name
        if path.exists():
            path.unlink()
            print(f"removed dead smali: {name}")


def main() -> None:
    strip_dead_smali()


if __name__ == "__main__":
    main()
