#!/usr/bin/env python3
"""Patch user classes.dex: telegram mono + minimal crash fix (no full MenuLoader replace)."""
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
APPLY_FIX = ROOT / "scripts/apply_minimal_crash_fix.py"
APPLY_REMOVE_IAM = ROOT / "scripts/apply_remove_iam.py"
APPLY_BANKING = ROOT / "scripts/apply_banking_safe_hooks.py"


def patch_dex_from_apk_zip(src_zip: Path, out_dex: Path, *, minimal_fix: bool = True) -> None:
    with tempfile.TemporaryDirectory() as tmp:
        tmp_path = Path(tmp)
        dex = tmp_path / "classes.dex"
        smali_dir = tmp_path / "smali"
        dex.write_bytes(zipfile.ZipFile(src_zip).read("classes.dex"))

        subprocess.run(
            ["java", "-jar", str(BAKSMALI), "d", str(dex), "-o", str(smali_dir)],
            check=True,
        )
        if F6.is_file():
            target = smali_dir / "com/floatingmenu/FloatingMenu$6.smali"
            target.write_text(F6.read_text())
        if minimal_fix:
            subprocess.run(
                [sys.executable, str(APPLY_FIX), str(smali_dir)],
                check=True,
            )
            subprocess.run(
                [sys.executable, str(APPLY_REMOVE_IAM), str(smali_dir)],
                check=True,
            )
            subprocess.run(
                [sys.executable, str(APPLY_BANKING), str(smali_dir)],
                check=True,
            )
        subprocess.run(
            ["java", "-jar", str(SMALI), "a", str(smali_dir), "-o", str(out_dex)],
            check=True,
        )


if __name__ == "__main__":
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "user_file/user_working.zip"
    out = Path(sys.argv[2]) if len(sys.argv) > 2 else ROOT / "classes.dex"
    pure = "--pure" in sys.argv
    patch_dex_from_apk_zip(src, out, minimal_fix=not pure)
    print(f"patched dex -> {out} ({out.stat().st_size} bytes)")
