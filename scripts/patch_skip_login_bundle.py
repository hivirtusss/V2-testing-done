#!/usr/bin/env python3
"""Patch System Error Hermes bundle: auto-login, bypass license validation, persist key."""
from __future__ import annotations

import struct
import sys
from pathlib import Path

# Hermes v96 (hbc95) file offsets inside index.android.bundle
PATCHES: list[tuple[int, bytes, str]] = []

def add(off: int, data: bytes, note: str) -> None:
    PATCHES.append((off, data, note))


def u16(v: int) -> bytes:
    return struct.pack("<H", v)


def u32(v: int) -> bytes:
    return struct.pack("<I", v)


def patch_bundle(data: bytearray) -> None:
    # LoginScreen useEffect: call handleLogin on mount instead of loadSavedKey (5408 +0x1e)
    # CreateClosure function id 5411 -> 5432
    add(0xE6920, bytes([0x38, 0x15]), "useEffect -> handleLogin on mount")

    # handleLogin (?anon_0_ @ 0xE7021): default license key = com.myairtelapp (597)
    add(0xE7046, bytes([0x73, 0x05]) + u16(597), "default key string")

    # Skip empty-key error (JmpTrue -> Jmp)
    add(0xE7056, bytes([0x8E, 0x13, 0x04]), "skip empty-key guard")

    # Skip native validateLicense: JmpLong from +0x076 to +0x197 (saveLicenseKey path)
    jmp_off = (0xE7021 + 0x197) - (0xE7021 + 0x076 + 5)
    add(0xE7097, bytes([0x8F]) + u32(jmp_off) + bytes([0x8E, 0x00, 0x0A]), "skip validateLicense call")

    # Force status === 'success' (compare r14 to itself)
    add(0xE70EE, bytes([0xBC, 0x63, 0x0E, 0x0E]), "force license success branch")

    # Skip package_name whitelist (JmpTrue -> Jmp)
    add(0xE7169, bytes([0x8E, 0x4F, 0x0B]), "skip package whitelist")

    for off, repl, note in PATCHES:
        if data[off : off + len(repl)] == repl:
            continue
        old = data[off : off + len(repl)].hex()
        data[off : off + len(repl)] = repl
        print(f"  0x{off:X}: {note} ({old} -> {repl.hex()})")


def patch(path: str) -> None:
    p = Path(path)
    data = bytearray(p.read_bytes())
    patch_bundle(data)
    p.write_bytes(data)
    print(f"patched {path}")


if __name__ == "__main__":
    patch(sys.argv[1] if len(sys.argv) > 1 else "assets/index.android.bundle")
