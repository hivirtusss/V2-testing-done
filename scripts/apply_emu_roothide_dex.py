#!/usr/bin/env python3
"""Patch dex for emulator-only root hide (no bubble/SMS)."""
from __future__ import annotations

import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GUARD = ROOT / "patch_smali/com/floatingmenu/EmulatorGuard.smali"

HOOKS_OLD = """    :try_start_15b
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->applySmsHooks()V

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->applyTelephonyHooks()V

    const-string v1, "android.app.ActivityThread"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    invoke-static {v1, v2}, Lcom/floatingmenu/MenuLoader;->applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V

    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

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

HOOKS_NEW = """    :try_start_15b
    const/4 v1, 0x1

    sput-boolean v1, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    sput-boolean v1, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    const-string v1, "android.app.ActivityThread"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    invoke-static {v1, v2}, Lcom/floatingmenu/MenuLoader;->applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->applyPackageManagerHooks()V

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->spoofBuildFields()V"""

THREAD_OLD = """    :cond_18c
    :goto_18c
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/MenuLoader$1;

    move-object v7, v1

    move-object v8, p0

    move-object v10, p1

    invoke-direct/range {v7 .. v12}, Lcom/floatingmenu/MenuLoader$1;-><init>(Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void"""

THREAD_NEW = """    :cond_18c
    :goto_18c
    return-void"""

EMU_GATE = """    :goto_59
    invoke-static {}, Lcom/floatingmenu/EmulatorGuard;->isEmulator()Z

    move-result v6

    if-eqz v6, :cond_emu_rh_go

    return-void

    :cond_emu_rh_go"""

ML19 = """.class Lcom/floatingmenu/MenuLoader$19;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 1

    return-void
.end method
"""


def patch_menu_loader(path: Path) -> None:
    text = path.read_text()
    if HOOKS_OLD not in text:
        raise SystemExit("MenuLoader hooks block not found")
    text = text.replace(HOOKS_OLD, HOOKS_NEW, 1)
    if THREAD_OLD not in text:
        raise SystemExit("MenuLoader thread block not found")
    text = text.replace(THREAD_OLD, THREAD_NEW, 1)
    anchor = """    :goto_59
    if-eqz p0, :cond_65"""
    if anchor not in text:
        raise SystemExit("MenuLoader emu gate anchor not found")
    text = text.replace(anchor, EMU_GATE + "\n\n    if-eqz p0, :cond_65", 1)
    path.write_text(text)


def patch_ml51(path: Path) -> None:
    text = path.read_text()
    old = "sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z"
    if old not in text:
        raise SystemExit("MenuLoader$5$1 iam dev gate not found")
    path.write_text(text.replace(old, "const/4 v2, 0x1"))


def patch_ml5(path: Path) -> None:
    text = path.read_text()
    old = "sget-boolean p2, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z"
    if old not in text:
        raise SystemExit("MenuLoader$5 iam dev gate not found")
    path.write_text(text.replace(old, "const/4 p2, 0x1"))


def main() -> None:
    smali_root = Path(sys.argv[1])
    dest = smali_root / "com/floatingmenu/EmulatorGuard.smali"
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(GUARD, dest)
    patch_menu_loader(smali_root / "com/floatingmenu/MenuLoader.smali")
    patch_ml51(smali_root / "com/floatingmenu/MenuLoader$5$1.smali")
    patch_ml5(smali_root / "com/floatingmenu/MenuLoader$5.smali")
    (smali_root / "com/floatingmenu/MenuLoader$19.smali").write_text(ML19)
    print("emulator root-hide dex patches applied")


if __name__ == "__main__":
    main()
