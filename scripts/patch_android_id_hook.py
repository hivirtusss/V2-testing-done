#!/usr/bin/env python3
"""Patch user smali for IdentityGuard + Settings android_id hook."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WORK = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "user_smali"


def patch_menu_loader(work: Path) -> None:
    path = work / "com/floatingmenu/MenuLoader.smali"
    text = path.read_text()
    needle = "    sput-object v1, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;\n\n    new-instance v1, Ljava/lang/StringBuilder;\n\n    const-string v4, \"Early applying SMS"
    insert = (
        "    sput-object v1, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;\n\n"
        "    sget-object v1, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;\n\n"
        "    invoke-static {v1}, Lcom/floatingmenu/IdentityGuard;->ensureLoaded(Ljava/lang/String;)V\n\n"
        "    new-instance v1, Ljava/lang/StringBuilder;\n\n"
        "    const-string v4, \"Early applying SMS"
    )
    if "IdentityGuard;->ensureLoaded" not in text:
        if needle not in text:
            raise SystemExit("MenuLoader patch anchor not found")
        text = text.replace(needle, insert, 1)
        path.write_text(text)


def patch_content_provider_hook(work: Path) -> None:
    path = work / "com/floatingmenu/MenuLoader$5$1.smali"
    text = path.read_text()
    anchor = "    :goto_85\n    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z"
    hook = """    :goto_85
    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    if-eqz v2, :virtus_skip_aid_query

    if-eqz v12, :virtus_skip_aid_query

    invoke-virtual {v12}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v11, "settings"

    invoke-virtual {v2, v11}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :virtus_skip_aid_query

    invoke-virtual {v12}, Landroid/net/Uri;->getLastPathSegment()Ljava/lang/String;

    move-result-object v2

    const-string v11, "android_id"

    invoke-virtual {v11, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :virtus_skip_aid_query

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$000()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/floatingmenu/IdentityGuard;->getSpoofedAndroidId(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :virtus_skip_aid_query

    new-instance v0, Landroid/database/MatrixCursor;

    const/4 v1, 0x3

    new-array v11, v1, [Ljava/lang/String;

    const-string v13, "_id"

    const/4 v14, 0x0

    aput-object v13, v11, v14

    const-string v13, "name"

    const/4 v15, 0x1

    aput-object v13, v11, v15

    const/4 v13, 0x2

    aput-object v4, v11, v13

    invoke-direct {v0, v11}, Landroid/database/MatrixCursor;-><init>([Ljava/lang/String;)V

    new-array v1, v1, [Ljava/lang/Object;

    invoke-static {v15}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v11

    aput-object v11, v1, v14

    const-string v11, "android_id"

    aput-object v11, v1, v15

    aput-object v2, v1, v13

    invoke-virtual {v0, v1}, Landroid/database/MatrixCursor;->addRow([Ljava/lang/Object;)V

    return-object v0

    :virtus_skip_aid_query
    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z"""
    if ":virtus_skip_aid_query" not in text:
        if anchor not in text:
            raise SystemExit("MenuLoader$5$1 patch anchor not found")
        text = text.replace(anchor, hook, 1)

    # call() path — intercept android_id in Settings.call
    call_anchor = "    if-eqz v2, :cond_6a\n\n    if-eqz v1, :cond_6a\n\n    const-string v2, \"call\""
    call_hook = """    if-eqz v2, :cond_6a

    if-eqz v1, :cond_6a

    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    if-eqz v2, :virtus_skip_aid_call

    if-eqz v0, :virtus_skip_aid_call

    array-length v2, v0

    const/4 v11, 0x0

    :virtus_aid_call_loop
    if-ge v11, v2, :virtus_skip_aid_call

    aget-object v12, v0, v11

    instance-of v13, v12, Ljava/lang/String;

    if-eqz v13, :virtus_aid_call_next

    check-cast v12, Ljava/lang/String;

    const-string v13, "android_id"

    invoke-virtual {v13, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :virtus_aid_call_next

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$000()Ljava/lang/String;

    move-result-object v12

    invoke-static {v12}, Lcom/floatingmenu/IdentityGuard;->getSpoofedAndroidId(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    if-eqz v12, :virtus_aid_call_next

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    invoke-virtual {v0, v4, v12}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    return-object v0

    :virtus_aid_call_next
    add-int/lit8 v11, v11, 0x1

    goto :virtus_aid_call_loop

    :virtus_skip_aid_call
    const-string v2, \"call\""""
    if ":virtus_skip_aid_call" not in text:
        if call_anchor not in text:
            raise SystemExit("MenuLoader$5$1 call patch anchor not found")
        text = text.replace(call_anchor, call_hook, 1)

    path.write_text(text)


def main() -> None:
    patch_menu_loader(WORK)
    patch_content_provider_hook(WORK)
    print(f"Patched android_id hooks in {WORK}")


if __name__ == "__main__":
    main()
