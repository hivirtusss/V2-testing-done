#!/usr/bin/env python3
"""Remove I am not Developer / I am no root UI and all related hook behavior."""
from __future__ import annotations

import sys
from pathlib import Path

FM1 = "com/floatingmenu/FloatingMenu$1.smali"
FM13 = "com/floatingmenu/FloatingMenu$1$3.smali"
ML = "com/floatingmenu/MenuLoader.smali"
ML1 = "com/floatingmenu/MenuLoader$1.smali"
ML5 = "com/floatingmenu/MenuLoader$5.smali"
ML51 = "com/floatingmenu/MenuLoader$5$1.smali"

IAM_SWITCH_UI = """    new-instance v3, Landroid/widget/Switch;

    iget-object v1, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v3, v1}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v3}, Lcom/floatingmenu/b;->o(Landroid/widget/Switch;)V

    invoke-static {v3}, Lcom/floatingmenu/b;->m(Landroid/widget/Switch;)V

    invoke-static {v3}, Lcom/floatingmenu/b;->n(Landroid/widget/Switch;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, -0x1

    const/4 v7, -0x2

    invoke-direct {v1, v2, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v2, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x41600000    # 14.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I
    :try_end_62e
    .catch Ljava/lang/Exception; {:try_start_5d7 .. :try_end_62e} :catch_c37

    :try_start_62e
    invoke-static {v3, v1}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V
    :try_end_631
    .catch Ljava/lang/Exception; {:try_start_62e .. :try_end_631} :catch_c3a

    :try_start_631
    invoke-virtual {v10, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/Switch;

    iget-object v1, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v2, v1}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v2}, Lcom/floatingmenu/b;->p(Landroid/widget/Switch;)V

    invoke-static {v2}, Lcom/floatingmenu/b;->m(Landroid/widget/Switch;)V

    invoke-static {v2}, Lcom/floatingmenu/b;->n(Landroid/widget/Switch;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, -0x1

    const/4 v8, -0x2

    invoke-direct {v1, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v7, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v8, 0x41200000    # 10.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    iput v7, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I
    :try_end_655
    .catch Ljava/lang/Exception; {:try_start_631 .. :try_end_655} :catch_c37

    :try_start_655
    invoke-static {v2, v1}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V
    :try_end_658
    .catch Ljava/lang/Exception; {:try_start_655 .. :try_end_658} :catch_c3a

    :try_start_658
    invoke-virtual {v10, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V"""

IAM_SWITCH_STUB = """    new-instance v3, Landroid/widget/Switch;

    iget-object v1, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v3, v1}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x0

    invoke-static {v3, v1}, Lcom/floatingmenu/b;->g(Landroid/widget/Switch;Z)V

    new-instance v2, Landroid/widget/Switch;

    iget-object v1, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v2, v1}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v2, v1}, Lcom/floatingmenu/b;->g(Landroid/widget/Switch;Z)V

    :try_start_658"""

INIT_PM_IAM = """    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

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

INIT_PM_BANK = """    sget-object v1, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-static {v1}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_18c

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->applyPackageManagerHooks()V

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->spoofBuildFields()V"""

ML19_BLOCK = """    sget-boolean p6, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    if-eqz p6, :cond_2f

    new-instance p6, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object p7

    invoke-direct {p6, p7}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance p7, Lcom/floatingmenu/MenuLoader$19;

    invoke-direct {p7}, Lcom/floatingmenu/MenuLoader$19;-><init>()V

    invoke-virtual {p6, p7}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    """

PREFS_IAM_ML1 = """    const-string v3, "iamnotdeveloper"

    sget-boolean v4, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    invoke-static {v4}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "iamnoroot"

    sget-boolean v4, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    invoke-static {v4}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    """

PREFS_IAM_ML = """    sget-boolean p1, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    invoke-static {p1}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object p1

    const-string p2, "iamnotdeveloper"

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    sget-boolean p1, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    invoke-static {p1}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object p1

    const-string p2, "iamnoroot"

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    """

FM13_SAVE = """    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$switchDev:Landroid/widget/Switch;

    invoke-static {p1}, Lcom/floatingmenu/b;->h(Landroid/widget/Switch;)Z

    move-result v9

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$switchNoRoot:Landroid/widget/Switch;

    invoke-static {p1}, Lcom/floatingmenu/b;->h(Landroid/widget/Switch;)Z

    move-result v10"""

FM13_SAVE_OFF = """    const/4 v9, 0x0

    const/4 v10, 0x0"""


def _replace(path: Path, old: str, new: str, *, required: bool = True) -> None:
    text = path.read_text()
    if old not in text:
        if required:
            raise SystemExit(f"anchor not found in {path.name}")
        return
    path.write_text(text.replace(old, new, 1))


def _replace_all(path: Path, old: str, new: str) -> None:
    text = path.read_text()
    if old not in text:
        raise SystemExit(f"anchor not found in {path.name}")
    path.write_text(text.replace(old, new))


def disable_private_method(path: Path, name: str) -> None:
    text = path.read_text()
    needle = f".method private static {name}()V\n    .registers "
    idx = text.find(needle)
    if idx < 0:
        raise SystemExit(f"{name} not found in {path.name}")
    start = idx + len(needle)
    end = text.find("\n\n", start)
    if end < 0:
        raise SystemExit(f"{name} registers block not found")
    head = text[: end + 2]
    tail = text[end + 2 :]
    if tail.startswith("    return-void\n\n"):
        return
    path.write_text(head + "    return-void\n\n" + tail)


def main() -> None:
    root = Path(sys.argv[1])
    fm1 = root / FM1
    _replace(fm1, IAM_SWITCH_UI, IAM_SWITCH_STUB)
    _replace(root / FM13, FM13_SAVE, FM13_SAVE_OFF)
    _replace_all(
        root / ML51,
        "sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z",
        "const/4 v2, 0x0",
    )
    _replace_all(
        root / ML5,
        "sget-boolean p2, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z",
        "const/4 p2, 0x0",
    )

    ml = root / ML
    text = ml.read_text()
    for block in (INIT_PM_IAM, INIT_PM_BANK):
        if block in text:
            text = text.replace(block, "", 1)
    if ML19_BLOCK in text:
        text = text.replace(ML19_BLOCK, "", 1)
    ml.write_text(text)

    _replace(root / ML1, PREFS_IAM_ML1, "", required=False)
    _replace(ml, PREFS_IAM_ML, "", required=False)

    disable_private_method(ml, "applyPackageManagerHooks")
    disable_private_method(ml, "spoofBuildFields")
    print("iamnotdeveloper / iamnoroot removed from menu and hooks")


if __name__ == "__main__":
    main()
