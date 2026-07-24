#!/usr/bin/env python3
"""No binder hooks / bubble on banking & UPI apps (Paytm, YesPay, Lxme, BharatPe, …)."""
from __future__ import annotations

import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GUARD = ROOT / "patch_smali/com/floatingmenu/BankingAppGuard.smali"

MARKER = "cond_virtus_banking_skip_hooks"

ACT_HEAD = """.method private static applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V
    .registers 8

    :try_start_0"""

ACT_HEAD_NEW = """.method private static applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V
    .registers 9

    sget-object v8, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-static {v8}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :goto_a3

    :try_start_0"""

SMS_HEAD = """.method private static applySmsHooks()V
    .registers 9

    const-class v0, Landroid/os/IBinder;"""

SMS_HEAD_NEW = """.method private static applySmsHooks()V
    .registers 10

    sget-object v8, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-static {v8}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :goto_5e

    const-class v0, Landroid/os/IBinder;"""

TEL_HEAD = """.method private static applyTelephonyHooks()V
    .registers 14

    const-string v0, "isub"
"""

TEL_HEAD_NEW = """.method private static applyTelephonyHooks()V
    .registers 14

    sget-object v8, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-static {v8}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :goto_b0

    const-string v0, "isub"
"""

INIT_AFTER_PKG = """    sput-object v1, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v4, "Early applying SMS, Telephony, and Activity hooks for: \""""

INIT_AFTER_PKG_NEW = f"""    sput-object v1, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    sget-object v1, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-static {{v1}}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :{MARKER}

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v4, "Early applying SMS, Telephony, and Activity hooks for: \""""

INIT_GOTO_BLOCK = """    :cond_167
    :goto_167
    new-instance v0, Ljava/lang/Thread;"""

INIT_GOTO_BLOCK_ALT = """    :cond_18c
    :goto_18c
    new-instance v0, Ljava/lang/Thread;"""

INIT_GOTO_NEW = f"""    :{MARKER}
    const/4 v1, 0x0

    sput-boolean v1, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    goto :goto_167

    :cond_167
    :goto_167
    new-instance v0, Ljava/lang/Thread;"""

INIT_GOTO_NEW_ALT = f"""    :{MARKER}
    const/4 v1, 0x0

    sput-boolean v1, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    goto :goto_18c

    :cond_18c
    :goto_18c
    new-instance v0, Ljava/lang/Thread;"""

ML1_DELAY = """    if-nez v2, :cond_c6

    const-string v2, "Completing delayed Activity hooks (mProviderMap clearing)..."

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    # invokes: Lcom/floatingmenu/MenuLoader;->applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V
    invoke-static {v1, v7}, Lcom/floatingmenu/MenuLoader;->access$200(Ljava/lang/Class;Ljava/lang/Object;)V

    :cond_c6"""

ML1_DELAY_NEW = """    if-nez v2, :cond_c6

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$000()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_c6

    const-string v2, "Completing delayed Activity hooks (mProviderMap clearing)..."

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {v1, v7}, Lcom/floatingmenu/MenuLoader;->access$200(Ljava/lang/Class;Ljava/lang/Object;)V

    :cond_c6"""

FM_SHOW = """    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    if-eqz v1, :cond_48

    invoke-static {p1}, Lcom/floatingmenu/FloatingMenu;->show(Landroid/app/Activity;)V

    :cond_48"""

FM_SHOW_NEW = """    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    if-eqz v1, :cond_48

    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_48

    invoke-static {p1}, Lcom/floatingmenu/FloatingMenu;->show(Landroid/app/Activity;)V

    :cond_48"""

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

    const/16 v2, 0x11

    const-string v3, "ybl"

    aput-object v3, v1, v2

    array-length v2, v1"""


def patch_guard(path: Path) -> None:
    text = path.read_text()
    if "ybl" in text:
        return
    text = text.replace("const/16 v1, 0x10\n", "const/16 v1, 0x12\n", 1)
    text = text.replace("const/16 v1, 0x11\n", "const/16 v1, 0x12\n", 1)
    if GUARD_EXTRA in text:
        path.write_text(text.replace(GUARD_EXTRA, GUARD_EXTRA_NEW, 1))
        return
    with_yespay = """    const/16 v2, 0x10

    const-string v3, "yespaynext"

    aput-object v3, v1, v2

    array-length v2, v1"""
    ybl_tail = """    const/16 v2, 0x10

    const-string v3, "yespaynext"

    aput-object v3, v1, v2

    const/16 v2, 0x11

    const-string v3, "ybl"

    aput-object v3, v1, v2

    array-length v2, v1"""
    if with_yespay in text:
        path.write_text(text.replace(with_yespay, ybl_tail, 1))
        return
    raise SystemExit("BankingAppGuard phonepe block not found")


def patch_menu_loader(ml: Path) -> None:
    text = ml.read_text()
    if MARKER not in text:
        if INIT_AFTER_PKG not in text:
            raise SystemExit("MenuLoader early-hooks anchor not found")
        text = text.replace(INIT_AFTER_PKG, INIT_AFTER_PKG_NEW, 1)
        if INIT_GOTO_BLOCK in text:
            text = text.replace(INIT_GOTO_BLOCK, INIT_GOTO_NEW, 1)
        elif INIT_GOTO_BLOCK_ALT in text:
            text = text.replace(INIT_GOTO_BLOCK_ALT, INIT_GOTO_NEW_ALT, 1)
        else:
            raise SystemExit("MenuLoader init tail (cond_167/18c) not found")

    if ACT_HEAD in text:
        text = text.replace(ACT_HEAD, ACT_HEAD_NEW, 1)

    if SMS_HEAD in text:
        text = text.replace(SMS_HEAD, SMS_HEAD_NEW, 1)
    if TEL_HEAD in text:
        text = text.replace(TEL_HEAD, TEL_HEAD_NEW, 1)

    text = text.replace(
        """    invoke-static {p1}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_ab""",
        """    invoke-static {p1}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :goto_ab""",
    )
    text = text.replace(
        """    invoke-static {p1}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :goto_a3""",
        """    invoke-static {p1}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :goto_a3""",
    )
    text = text.replace(
        """    invoke-static {v8}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :goto_b1""",
        """    invoke-static {v8}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :goto_5e""",
    )
    text = text.replace(
        """    invoke-static {v8}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :goto_b0""",
        """    invoke-static {v8}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :goto_b0""",
    )

    ml.write_text(text)


def patch_ml1(path: Path) -> None:
    if not path.is_file():
        return
    text = path.read_text()
    if "BankingAppGuard" in text and "Completing delayed Activity hooks" in text:
        return
    if ML1_DELAY not in text:
        raise SystemExit("MenuLoader\$1 delayed activity block not found")
    path.write_text(text.replace(ML1_DELAY, ML1_DELAY_NEW, 1))


def patch_fm_show(path: Path) -> None:
    if not path.is_file():
        return
    text = path.read_text()
    if "BankingAppGuard" in text and "FloatingMenu;->show" in text:
        return
    if FM_SHOW not in text:
        # Older bubble-always path
        alt = """    if-nez v1, :cond_44

    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/floatingmenu/TargetPackageGuard;->isPackageSelected(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_48

    :cond_44
    invoke-static {p1}, Lcom/floatingmenu/FloatingMenu;->show(Landroid/app/Activity;)V

    :cond_48"""
        if alt in text:
            alt_new = """    if-nez v1, :cond_44

    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/floatingmenu/TargetPackageGuard;->isPackageSelected(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_48

    :cond_44
    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_48

    invoke-static {p1}, Lcom/floatingmenu/FloatingMenu;->show(Landroid/app/Activity;)V

    :cond_48"""
            path.write_text(text.replace(alt, alt_new, 1))
            return
        raise SystemExit("MenuLoader\$1\$1 FloatingMenu.show block not found")
    path.write_text(text.replace(FM_SHOW, FM_SHOW_NEW, 1))


def main() -> None:
    smali_root = Path(sys.argv[1])
    dest = smali_root / "com/floatingmenu/BankingAppGuard.smali"
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(GUARD, dest)
    patch_guard(dest)
    patch_menu_loader(smali_root / "com/floatingmenu/MenuLoader.smali")
    patch_ml1(smali_root / "com/floatingmenu/MenuLoader$1.smali")
    patch_fm_show(smali_root / "com/floatingmenu/MenuLoader$1$1.smali")
    print("banking-safe: skip all binder hooks + bubble on UPI/banking apps")


if __name__ == "__main__":
    main()
