#!/usr/bin/env python3
"""Patch injected dex: IdentityGuard + Settings android_id hook."""
from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def patch_menu_loader(work: Path) -> None:
    path = work / "com/floatingmenu/MenuLoader.smali"
    text = path.read_text()
    needle = (
        "    sput-object v1, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;\n\n"
        "    new-instance v1, Ljava/lang/StringBuilder;\n\n"
        "    const-string v4, \"Early applying SMS"
    )
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


def patch_settings_hook(work: Path) -> None:
    path = work / "com/floatingmenu/MenuLoader$5$1.smali"
    text = path.read_text()
    anchor = (
        "    move-object/from16 v0, p3\n\n"
        "    invoke-virtual/range {p2 .. p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;"
    )
    hook = (
        "    move-object/from16 v0, p3\n\n"
        "    move-object/from16 v11, p2\n\n"
        "    invoke-static {v11, v0}, Lcom/floatingmenu/IdentityGuard;->interceptSettings(Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;\n\n"
        "    move-result-object v11\n\n"
        "    if-eqz v11, :virtus_hook_continue\n\n"
        "    return-object v11\n\n"
        "    :virtus_hook_continue\n"
        "    invoke-virtual/range {p2 .. p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;"
    )
    if ":virtus_hook_continue" not in text:
        if anchor not in text:
            raise SystemExit("MenuLoader$5$1 hook anchor not found")
        text = text.replace(anchor, hook, 1)
        path.write_text(text)


def main() -> None:
    work = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "user_smali"
    patch_menu_loader(work)
    patch_settings_hook(work)
    print(f"Patched identity hooks in {work}")


if __name__ == "__main__":
    main()
