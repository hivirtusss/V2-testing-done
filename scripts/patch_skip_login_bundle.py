#!/usr/bin/env python3
"""Patch Hermes bundle: App useState(false) -> useState(true) to skip LoginScreen."""
import sys

PATCH_OFFSET = 0xE55B6
FALSE_OPCODE = 121  # LoadConstFalse (HBC v96)
TRUE_OPCODE = 120   # LoadConstTrue


def patch(path: str) -> None:
    data = bytearray(open(path, "rb").read())
    if data[PATCH_OFFSET] != FALSE_OPCODE:
        raise SystemExit(
            f"unexpected opcode 0x{data[PATCH_OFFSET]:02x} at 0x{PATCH_OFFSET:x}; bundle layout changed"
        )
    data[PATCH_OFFSET] = TRUE_OPCODE
    open(path, "wb").write(data)
    print(f"patched {path}: skip login (LoadConstFalse -> LoadConstTrue @ 0x{PATCH_OFFSET:x})")

if __name__ == "__main__":
    patch(sys.argv[1] if len(sys.argv) > 1 else "assets/index.android.bundle")
