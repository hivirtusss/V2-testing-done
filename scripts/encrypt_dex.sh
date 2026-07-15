#!/usr/bin/env bash
# Encrypt classes.dex -> classes.dex.enc (IV prepended, AES-256-CBC, nosalt).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEX="$ROOT/extracted/classes.dex"
ENC="$ROOT/extracted/classes.dex.enc"
KEY="Vrt3_Hivirtus_VirtusSelectionKey"

[ -f "$DEX" ] || { echo "Missing $DEX" >&2; exit 1; }

python3 - "$DEX" "$ENC" "$KEY" <<'PY'
import hashlib, os, subprocess, sys
from pathlib import Path

dex, enc, key = sys.argv[1:4]
keyhex = key.encode().hex()
ivhex = os.urandom(16).hex()
tmp = Path(dex).with_suffix('.payload.tmp')
subprocess.check_call([
    'openssl', 'enc', '-aes-256-cbc', '-nosalt',
    '-in', dex, '-out', str(tmp),
    '-K', keyhex, '-iv', ivhex,
])
Path(enc).write_bytes(bytes.fromhex(ivhex) + tmp.read_bytes())
tmp.unlink(missing_ok=True)
print(f"Encrypted {dex} -> {enc} ({Path(enc).stat().st_size} bytes)")
PY
