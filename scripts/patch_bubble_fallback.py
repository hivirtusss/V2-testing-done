#!/usr/bin/env python3
"""Bubble fallback: show menu when package is in target_packages.txt."""
from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def patch_bubble_fallback(work: Path) -> None:
    path = work / "com/floatingmenu/MenuLoader$1$1.smali"
    text = path.read_text()
    anchor = (
        "    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z\n\n"
        "    if-eqz v1, :cond_"
    )
    if "TargetListGuard;->isSelectedPackage" in text:
        return
    idx = text.find(anchor)
    if idx < 0:
        raise SystemExit("MenuLoader$1$1 bubble anchor not found")
    # find cond label after anchor
    rest = text[idx + len(anchor):]
    label_end = rest.find("\n")
    cond_label = rest[:label_end].strip()
    hook = (
        "    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z\n\n"
        "    if-eqz v1, :virtus_bubble_show\n\n"
        "    invoke-virtual {p1}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;\n\n"
        "    move-result-object v2\n\n"
        "    invoke-static {v2}, Lcom/floatingmenu/TargetListGuard;->isSelectedPackage(Ljava/lang/String;)Z\n\n"
        "    move-result v1\n\n"
        "    if-eqz v1, :virtus_bubble_show\n\n"
        f"    goto :{cond_label}\n\n"
        "    :virtus_bubble_show\n"
    )
    old = f"    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z\n\n    if-eqz v1, :cond_{cond_label}\n\n"
    if old not in text:
        raise SystemExit(f"Could not match cond block :cond_{cond_label}")
    text = text.replace(old, hook, 1)
    path.write_text(text)


def main() -> None:
    work = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "user_smali"
    patch_bubble_fallback(work)
    print(f"Bubble fallback patched in {work}")


if __name__ == "__main__":
    main()
