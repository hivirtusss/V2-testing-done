#!/usr/bin/env python3
"""Patch System Error Hermes bundle: keep login screen, whitelist 5 license keys."""
from __future__ import annotations

import struct
import sys
from pathlib import Path

from hashlib import sha1

SHA1_NUM_BYTES = 20

# Hermes file layout for this bundle (v96)
SMALL_TABLE_END = 155324
STRING_STORAGE_END = 266442

HANDLE_LOGIN_OFF = 0xE7021
CHECK_START_REL = 0x7F
SUCCESS_REL = 0x197
FAIL_REL = 0x203

LICENSE_KEYS = (
    "HIVIRTUS-KEY-001-AB12",
    "HIVIRTUS-KEY-002-CD34",
    "HIVIRTUS-KEY-003-EF56",
    "HIVIRTUS-KEY-004-GH78",
    "HIVIRTUS-KEY-005-IJ90",
)


def pack_string_entry(length: int, offset: int, is_utf16: int = 0) -> bytes:
    value = (is_utf16 & 1) | ((offset & 0x7FFFFF) << 1) | ((length & 0xFF) << 24)
    return struct.pack("<I", value)


def update_footer(data: bytearray) -> None:
    file_len = len(data)
    struct.pack_into("<I", data, 32, file_len)
    data[file_len - SHA1_NUM_BYTES : file_len] = sha1(bytes(data[: file_len - SHA1_NUM_BYTES])).digest()


def append_license_strings(data: bytearray) -> None:
    base_count = struct.unpack_from("<I", data, 52)[0]
    storage_base = struct.unpack_from("<I", data, 60)[0]
    new_entries = b"".join(
        pack_string_entry(len(key), storage_base + i * 21) for i, key in enumerate(LICENSE_KEYS)
    )
    new_storage = b"".join(key.encode("ascii") for key in LICENSE_KEYS)

    data[SMALL_TABLE_END:SMALL_TABLE_END] = new_entries
    storage_insert_at = STRING_STORAGE_END + len(new_entries)
    data[storage_insert_at:storage_insert_at] = new_storage

    grow = len(new_entries) + len(new_storage)
    struct.pack_into("<I", data, 52, base_count + len(LICENSE_KEYS))
    struct.pack_into("<I", data, 60, storage_base + len(new_storage))
    struct.pack_into("<I", data, 104, struct.unpack_from("<I", data, 104)[0] + grow)


def u16(v: int) -> bytes:
    return struct.pack("<H", v)


def patch_handle_login(data: bytearray, key_ids: list[int]) -> None:
    base = HANDLE_LOGIN_OFF
    check_start = base + CHECK_START_REL
    success = base + SUCCESS_REL
    fail = base + FAIL_REL

    checks = bytearray()
    for sid in key_ids:
        load_off = check_start + len(checks)
        jmp_off = load_off + 4
        checks += bytes([0x73, 0x0D]) + u16(sid)
        checks += bytes([0xBC, (success - jmp_off) & 0xFF, 0x08, 0x0D])

    fail_jmp_off = check_start + len(checks)
    checks += bytes([0x8F]) + struct.pack("<i", fail - fail_jmp_off)

    # Replace validateLicense + status handling (0x7f..0x12f) with key whitelist.
    region_len = 0x130 - CHECK_START_REL
    if len(checks) > region_len:
        raise ValueError(f"whitelist bytecode too large ({len(checks)} > {region_len})")

    patch = checks + bytes([0x00]) * (region_len - len(checks))
    data[check_start : check_start + region_len] = patch


def patch_bundle(data: bytearray) -> list[str]:
    base_count = struct.unpack_from("<I", data, 52)[0]
    key_ids = list(range(base_count, base_count + len(LICENSE_KEYS)))
    patch_handle_login(data, key_ids)
    append_license_strings(data)
    update_footer(data)
    return list(LICENSE_KEYS)


def patch(path: str) -> list[str]:
    p = Path(path)
    data = bytearray(p.read_bytes())
    keys = patch_bundle(data)
    p.write_bytes(data)
    print(f"patched {path} with {len(keys)} license keys")
    for key in keys:
        print(f"  {key}")
    return keys


if __name__ == "__main__":
    patch(sys.argv[1] if len(sys.argv) > 1 else "assets/index.android.bundle")
