#!/usr/bin/env python3
"""Build no-login APK: patch Hermes bundle only, preserve original classes.dex."""
from __future__ import annotations

import importlib.util
import shutil
import sys
import zipfile
from pathlib import Path


def load_patch_fn():
    root = Path(__file__).resolve().parents[1]
    spec = importlib.util.spec_from_file_location(
        "patch_skip_login_bundle", root / "scripts/patch_skip_login_bundle.py"
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod.patch_bundle


def build(src_apk: Path, out_apk: Path) -> None:
    patch_bundle = load_patch_fn()
    tmp = out_apk.with_suffix(".tmp.apk")
    shutil.copy2(src_apk, tmp)

    with zipfile.ZipFile(tmp, "r") as zin:
        bundle = bytearray(zin.read("assets/index.android.bundle"))
        patch_bundle(bundle)

        with zipfile.ZipFile(out_apk, "w") as zout:
            for info in zin.infolist():
                payload = (
                    bundle
                    if info.filename == "assets/index.android.bundle"
                    else zin.read(info.filename)
                )
                if info.filename.startswith("META-INF/") and (
                    info.filename.endswith(".SF")
                    or info.filename.endswith(".RSA")
                    or info.filename.endswith(".DSA")
                    or info.filename.endswith(".EC")
                    or info.filename == "META-INF/MANIFEST.MF"
                ):
                    continue
                zout.writestr(info, payload, compress_type=info.compress_type)

    tmp.unlink(missing_ok=True)

    orig_dex = zipfile.ZipFile(src_apk).read("classes.dex")
    out_dex = zipfile.ZipFile(out_apk).read("classes.dex")
    if orig_dex != out_dex:
        raise SystemExit("classes.dex changed — abort")


if __name__ == "__main__":
    root = Path(__file__).resolve().parents[1]
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else root / "user_file/virtus_app.apk"
    out = Path(sys.argv[2]) if len(sys.argv) > 2 else root / "apk_no_login_unsigned.apk"
    build(src, out)
    print(f"unsigned apk: {out} ({out.stat().st_size} bytes)")
