#!/usr/bin/env python3
"""Skip ActivityManager binder hooks on banking/UPI apps (reduces Paytm/Navi crashes)."""
from __future__ import annotations

import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GUARD = ROOT / "patch_smali/com/floatingmenu/BankingAppGuard.smali"

ACT_HEAD = """.method private static applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V
    .registers 8

    :try_start_0"""

ACT_HEAD_NEW = """.method private static applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V
    .registers 9

    sget-object v8, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-static {v8}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_banking_skip_activity_hooks

    :try_start_0"""

GUARD_EXTRA = """    const/16 v2, 0xf

    const-string v3, "phonepe"

    aput-object v3, v1, v2

    array-length v2, v1"""

GUARD_EXTRA_NEW = """    const/16 v2, 0xf

    const-string v3, "phonepe"

    aput-object v3, v1, v2

    const/16 v2, 0x10

    const-string v3, "yespaynext"

    aput-object v3, v1, v2

    array-length v2, v1"""


def patch_guard(path: Path) -> None:
    text = path.read_text()
    if "yespaynext" in text:
        return
    text = text.replace("const/16 v1, 0x10", "const/16 v1, 0x11", 1)
    if GUARD_EXTRA not in text:
        raise SystemExit("BankingAppGuard phonepe block not found")
    path.write_text(text.replace(GUARD_EXTRA, GUARD_EXTRA_NEW, 1))


def patch_activity_hooks(ml: Path) -> None:
    text = ml.read_text()
    if ACT_HEAD not in text:
        raise SystemExit("applyActivityHooks head not found")
    text = text.replace(ACT_HEAD, ACT_HEAD_NEW, 1)
    tail = """    :cond_a3
    :goto_a3
    return-void
.end method

.method private static applyPackageManagerHooks()V"""
    tail_new = """    :cond_a3
    :goto_a3
    :cond_banking_skip_activity_hooks
    return-void
.end method

.method private static applyPackageManagerHooks()V"""
    if tail not in text:
        raise SystemExit("applyActivityHooks tail not found")
    text = text.replace(tail, tail_new, 1)
    ml.write_text(text)


def main() -> None:
    smali_root = Path(sys.argv[1])
    dest = smali_root / "com/floatingmenu/BankingAppGuard.smali"
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(GUARD, dest)
    patch_guard(dest)
    patch_activity_hooks(smali_root / "com/floatingmenu/MenuLoader.smali")
    print("banking-safe activity hook skip applied")


if __name__ == "__main__":
    main()
