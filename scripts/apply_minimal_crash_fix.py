#!/usr/bin/env python3
"""Apply tiny smali edits on disassembled dex — keep MenuLoader logic intact."""
from pathlib import Path
import sys

smali = Path(sys.argv[1])


def patch_menu_loader(path: Path) -> None:
    text = path.read_text()
    old_iam = """    const-string v6, "iamnotdeveloper"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonBoolean(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    sput-boolean v6, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    const-string v6, "iamnoroot"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonBoolean(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    sput-boolean v6, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z"""
    new_iam = """    const/4 v6, 0x0

    sput-boolean v6, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    const/4 v6, 0x0

    sput-boolean v6, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z"""
    if old_iam not in text:
        raise SystemExit("MenuLoader iam block not found")
    text = text.replace(old_iam, new_iam, 1)

    old_upd = """    sput-boolean p7, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    sput-boolean p8, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z"""
    new_upd = """    const/4 p7, 0x0

    sput-boolean p7, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    const/4 p8, 0x0

    sput-boolean p8, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z"""
    if old_upd in text:
        text = text.replace(old_upd, new_upd, 1)

    path.write_text(text)


def patch_ml1111(path: Path) -> None:
    text = path.read_text()
    old = """    :cond_53
    array-length v4, v0

    const/16 v9, 0x8

    if-lt v4, v9, :cond_60

    aget-object v4, v0, v10

    invoke-virtual {v5, v4}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v4

    sput-boolean v4, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    :cond_60
    array-length v4, v0

    const/16 v10, 0x9

    if-lt v4, v10, :cond_6d

    aget-object v4, v0, v9

    invoke-virtual {v5, v4}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v4

    sput-boolean v4, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    :cond_6d"""
    new = """    :cond_53
    const/4 v4, 0x0

    sput-boolean v4, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    const/4 v4, 0x0

    sput-boolean v4, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    :cond_6d"""
    if old not in text:
        raise SystemExit("MenuLoader$1$1$1$1 iam block not found")
    path.write_text(text.replace(old, new, 1))


def patch_ml19(path: Path) -> None:
    path.write_text(
        """.class Lcom/floatingmenu/MenuLoader$19;
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
    )


if __name__ == "__main__":
    root = smali if smali.is_dir() else smali.parent
    patch_menu_loader(root / "com/floatingmenu/MenuLoader.smali")
    patch_ml1111(root / "com/floatingmenu/MenuLoader$1$1$1$1.smali")
    patch_ml19(root / "com/floatingmenu/MenuLoader$19.smali")
    print("minimal crash fix applied in smali tree")
