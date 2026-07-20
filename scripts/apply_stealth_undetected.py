#!/usr/bin/env python3
"""Stealth hooks: banking apps skip detectable PM/build spoof; neutral in-app strings."""
from __future__ import annotations

import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GUARD_SRC = ROOT / "patch_smali/com/floatingmenu/BankingAppGuard.smali"

# Strings visible inside hooked app processes (logcat, views, prefs).
STEALTH_REPLACEMENTS = {
    "ZygiskMenu @Hivirtus": "Choreographer",
    "ZygiskMenuPoller": "SyncManager",
    "zygisk_floating_menu": "wm_overlay_host",
    "zygisk_menu_prefs": "acfg_prefs_v2",
    "zygisk_menu_socket": "acfg_local_sock",
}


def copy_banking_guard(smali_root: Path) -> None:
    dest = smali_root / "com/floatingmenu/BankingAppGuard.smali"
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(GUARD_SRC, dest)


def apply_string_stealth(smali_root: Path) -> None:
    for path in smali_root.rglob("*.smali"):
        text = path.read_text()
        orig = text
        for old, new in STEALTH_REPLACEMENTS.items():
            text = text.replace(old, new)
        if text != orig:
            path.write_text(text)


def patch_menu_loader(path: Path) -> None:
    text = path.read_text()

    pm_head = """.method private static applyPackageManagerHooks()V
    .registers 11

    const-string v0, "package\""""
    pm_head_new = """.method private static applyPackageManagerHooks()V
    .registers 11

    sget-object v10, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-static {v10}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v10

    if-nez v10, :cond_stealth_pm_skip

    const-string v0, "package\""""
    if pm_head not in text:
        raise SystemExit("applyPackageManagerHooks head not found")
    text = text.replace(pm_head, pm_head_new, 1)

    pm_tail = """    :goto_b0
    return-void
.end method

.method private static applySmsHooks()V"""
    pm_tail_new = """    :goto_b0
    return-void

    :cond_stealth_pm_skip
    return-void
.end method

.method private static applySmsHooks()V"""
    if pm_tail not in text:
        raise SystemExit("applyPackageManagerHooks tail not found")
    text = text.replace(pm_tail, pm_tail_new, 1)

    spoof_head = """.method private static spoofBuildFields()V
    .registers 5

    const-string v0, "ZygiskMenu @Hivirtus\""""
    spoof_head_new = """.method private static spoofBuildFields()V
    .registers 6

    sget-object v5, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-static {v5}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_stealth_build_skip

    const-string v0, "ZygiskMenu @Hivirtus\""""
    if spoof_head not in text:
        raise SystemExit("spoofBuildFields head not found")
    text = text.replace(spoof_head, spoof_head_new, 1)

    spoof_tail = """    :goto_30
    return-void
.end method

.method private static startSystemUiLicenseManager"""
    spoof_tail_new = """    :goto_30
    return-void

    :cond_stealth_build_skip
    return-void
.end method

.method private static startSystemUiLicenseManager"""
    if spoof_tail not in text:
        raise SystemExit("spoofBuildFields tail not found")
    text = text.replace(spoof_tail, spoof_tail_new, 1)

    init_old = """    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    if-eqz v1, :cond_18c

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->applyPackageManagerHooks()V

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->spoofBuildFields()V"""
    init_new = """    sget-object v1, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-static {v1}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_18c

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->applyPackageManagerHooks()V

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->spoofBuildFields()V"""
    if init_old not in text:
        raise SystemExit("init PM block not found")
    text = text.replace(init_old, init_new, 1)

    path.write_text(text)


def patch_pm_blocklist(path: Path) -> None:
    text = path.read_text()
    if "zygisk_floating_menu" in text:
        return

    text = text.replace("const/16 p1, 0xc", "const/16 p1, 0x11", 1)
    insert_after = '    const-string v1, "com.xposed.manager"\n\n    aput-object v1, p1, v0\n\n    invoke-static {p1}'
    new_block = '''    const-string v1, "com.xposed.manager"

    aput-object v1, p1, v0

    const/16 v0, 0xc

    const-string v1, "com.vvb2060.kernelsu"

    aput-object v1, p1, v0

    const/16 v0, 0xd

    const-string v1, "com.sukisu.ultra"

    aput-object v1, p1, v0

    const/16 v0, 0xe

    const-string v1, "me.bmax.apatch"

    aput-object v1, p1, v0

    const/16 v0, 0xf

    const-string v1, "io.github.mmrl"

    aput-object v1, p1, v0

    const/16 v0, 0x10

    const-string v1, "zygisk_floating_menu"

    aput-object v1, p1, v0

    invoke-static {p1}'''
    if insert_after not in text:
        raise SystemExit("MenuLoader$20 blocklist anchor not found")
    text = text.replace(insert_after, new_block, 1)
    path.write_text(text)


def main() -> None:
    smali_root = Path(sys.argv[1])
    copy_banking_guard(smali_root)
    patch_menu_loader(smali_root / "com/floatingmenu/MenuLoader.smali")
    ml20 = smali_root / "com/floatingmenu/MenuLoader$20.smali"
    if ml20.is_file():
        patch_pm_blocklist(ml20)
    apply_string_stealth(smali_root)
    print("stealth undetected patches applied")


if __name__ == "__main__":
    main()
