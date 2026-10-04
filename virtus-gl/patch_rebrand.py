#!/usr/bin/env python3
"""Rebrand KC GL decompiled APK to Virtus GL (same features, same key flow)."""

from __future__ import annotations

import argparse
import re
import shutil
import sys
from pathlib import Path

TEXT_REPLACEMENTS = [
    ("GetKernelCheatTextMes", "GetVirtusGLTextMes"),
    ("GetKernelCheatTextTips", "GetVirtusGLTextTips"),
    ("GetKernelCheatText", "GetVirtusGLText"),
    ("GetKernelCheat", "GetVirtusGL"),
    ("KC GL", "Virtus GL"),
    ("Kernel Cheat", "Virtus GL"),
    ("KernelCheat.com", "VirtusGL.com"),
    ("KernelCheat", "VirtusGL"),
    ("Kernel version:", "Virtus version:"),
    ("Cheat core version", "Virtus core version"),
    ("https://t.me/KernelCheat", "https://t.me/VirtusGL"),
    ("com.android.lc", "com.virtus.gl"),
    ("io.android.lc", "io.virtus.gl"),
    ("Lcom/android/lc/", "Lcom/virtus/gl/"),
    ("Lio/android/lc/", "Lio/virtus/gl/"),
    ("com/android/lc/", "com/virtus/gl/"),
    ("io/android/lc/", "io/virtus/gl/"),
]

BINARY_EXTENSIONS = {".so", ".png", ".jpg", ".webp", ".gif", ".9.png", ".ttf", ".otf", ".wav", ".mp3"}
TEXT_EXTENSIONS = {
    ".smali", ".xml", ".yml", ".yaml", ".json", ".txt", ".properties", ".MF", ".SF", ".RSA",
    ".java", ".kotlin", ".md", ".html", ".css", ".svg",
}


def should_patch_file(path: Path) -> bool:
    if path.suffix.lower() in BINARY_EXTENSIONS:
        return False
    if path.suffix.lower() in TEXT_EXTENSIONS:
        return True
    # Extensionless META-INF/version files etc.
    return path.suffix == "" and path.name not in {"apktool.jar"}


def patch_text(content: str, shuanq_app_id: str | None, shuanq_app_key: str | None) -> str:
    for old, new in TEXT_REPLACEMENTS:
        content = content.replace(old, new)
    if shuanq_app_id:
        content = re.sub(
            r'(\.field private static AppId:Ljava/lang/String; = ")[^"]+(")',
            rf"\g<1>{shuanq_app_id}\g<2>",
            content,
        )
    if shuanq_app_key:
        content = re.sub(
            r'(\.field private static AppKey:Ljava/lang/String; = ")[^"]+(")',
            rf"\g<1>{shuanq_app_key}\g<2>",
            content,
        )
    return content


def rename_package_dirs(root: Path) -> None:
    moves = [
        (root / "smali" / "com" / "android" / "lc", root / "smali" / "com" / "virtus" / "gl"),
        (root / "smali" / "io" / "android" / "lc", root / "smali" / "io" / "virtus" / "gl"),
    ]
    for src, dst in moves:
        if src.exists():
            dst.parent.mkdir(parents=True, exist_ok=True)
            if dst.exists():
                shutil.rmtree(dst)
            shutil.move(str(src), str(dst))
    # cleanup empty dirs
    for stale in [
        root / "smali" / "com" / "android",
        root / "smali" / "io" / "android",
    ]:
        if stale.exists() and not any(stale.rglob("*")):
            shutil.rmtree(stale, ignore_errors=True)


def patch_tree(root: Path, shuanq_app_id: str | None, shuanq_app_key: str | None) -> int:
    changed = 0
    for path in root.rglob("*"):
        if not path.is_file() or not should_patch_file(path):
            continue
        try:
            original = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        updated = patch_text(original, shuanq_app_id, shuanq_app_key)
        if updated != original:
            path.write_text(updated, encoding="utf-8")
            changed += 1
    return changed


def main() -> int:
    parser = argparse.ArgumentParser(description="Rebrand KC GL decompiled tree to Virtus GL")
    parser.add_argument(
        "--source",
        default="/workspace/apk/drive-analysis/decompiled",
        help="KC GL apktool decompiled directory",
    )
    parser.add_argument(
        "--output",
        default="/workspace/virtus-gl/build/decompiled",
        help="Output patched decompiled directory",
    )
    parser.add_argument("--shuanq-app-id", default="", help="Optional override for ShuanQ AppId")
    parser.add_argument("--shuanq-app-key", default="", help="Optional override for ShuanQ AppKey")
    args = parser.parse_args()

    source = Path(args.source)
    output = Path(args.output)
    if not source.exists():
        print(f"Source not found: {source}", file=sys.stderr)
        return 1

    if output.exists():
        shutil.rmtree(output)
    shutil.copytree(source, output)

    changed = patch_tree(output, args.shuanq_app_id or None, args.shuanq_app_key or None)
    rename_package_dirs(output)

    # apktool.yml package name
    yml = output / "apktool.yml"
    if yml.exists():
        text = yml.read_text(encoding="utf-8")
        text = text.replace("com.android.lc", "com.virtus.gl")
        yml.write_text(text, encoding="utf-8")

    print(f"Patched Virtus GL tree: {output}")
    print(f"Modified text files: {changed}")
    print("Package: com.virtus.gl")
    print("Key flow: unchanged (ShuanQ register/recharge/login via libkernel.so)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
