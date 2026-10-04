#!/usr/bin/env python3
"""Generate Virtus GL activation keys and push to Firebase RTDB."""

from __future__ import annotations

import argparse
import json
import secrets
import sys
import urllib.error
import urllib.request


def make_key() -> str:
    raw = secrets.token_hex(8).upper()
    return f"KEY-{raw[0:4]}-{raw[4:8]}-{raw[8:12]}-{raw[12:16]}"


def firebase_put(base_url: str, path: str, payload: dict) -> None:
    url = f"{base_url.rstrip('/')}/{path.strip('/')}.json"
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, method="PUT")
    req.add_header("Content-Type", "application/json")
    with urllib.request.urlopen(req, timeout=15) as resp:
        if resp.status >= 300:
            raise RuntimeError(f"Firebase PUT failed: {resp.status}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Create Virtus GL recharge key")
    parser.add_argument(
        "--firebase-url",
        default="https://virtus-gl-default-rtdb.firebaseio.com",
        help="Firebase RTDB base URL",
    )
    parser.add_argument("--days", type=int, default=30, help="Subscription days")
    parser.add_argument("--count", type=int, default=1, help="Number of keys")
    args = parser.parse_args()

    created: list[str] = []
    for _ in range(max(1, args.count)):
        key = make_key()
        payload = {
            "active": True,
            "days": args.days,
            "redeemed_by": None,
            "redeemed_at": None,
        }
        try:
            firebase_put(args.firebase_url, f"virtus_gl/keys/{key}", payload)
        except urllib.error.URLError as exc:
            print(f"Failed to upload {key}: {exc}", file=sys.stderr)
            return 1
        created.append(key)

    print("Created keys:")
    for key in created:
        print(key)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
