#!/usr/bin/env python3
"""Patch user classes.dex: Telegram mono format + bubble always on target apps."""
from __future__ import annotations

import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BAKSMALI = ROOT / "baksmali.jar"
SMALI = ROOT / "smali.jar"
F6 = ROOT / "user_smali/com/floatingmenu/FloatingMenu$6.smali"
FM1 = ROOT / "user_smali/com/floatingmenu/FloatingMenu$1.smali"
FM13 = ROOT / "user_smali/com/floatingmenu/FloatingMenu$1$3.smali"
ML = ROOT / "user_smali/com/floatingmenu/MenuLoader$1$1$1$1.smali"
ML_MAIN = ROOT / "user_smali/com/floatingmenu/MenuLoader.smali"

PATCHES = (
    ("com/floatingmenu/FloatingMenu$6.smali", F6),
    ("com/floatingmenu/FloatingMenu$1.smali", FM1),
    ("com/floatingmenu/FloatingMenu$1$3.smali", FM13),
    ("com/floatingmenu/MenuLoader$1$1$1$1.smali", ML),
    ("com/floatingmenu/MenuLoader.smali", ML_MAIN),
)


def patch_dex_from_apk_zip(src_zip: Path, out_dex: Path) -> None:
    with tempfile.TemporaryDirectory() as tmp:
        tmp_path = Path(tmp)
        dex = tmp_path / "classes.dex"
        smali_dir = tmp_path / "smali"
        dex.write_bytes(zipfile.ZipFile(src_zip).read("classes.dex"))

        subprocess.run(
            ["java", "-jar", str(BAKSMALI), "d", str(dex), "-o", str(smali_dir)],
            check=True,
        )
        for rel, src in PATCHES:
            target = smali_dir / rel
            if not target.is_file():
                raise SystemExit(f"{rel} missing in dex")
            target.write_text(src.read_text())
        subprocess.run(
            ["java", "-jar", str(SMALI), "a", str(smali_dir), "-o", str(out_dex)],
            check=True,
        )


if __name__ == "__main__":
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "user_file/user_upload.zip"
    out = Path(sys.argv[2]) if len(sys.argv) > 2 else ROOT / "classes.dex"
    patch_dex_from_apk_zip(src, out)
    print(f"patched dex -> {out} ({out.stat().st_size} bytes)")
