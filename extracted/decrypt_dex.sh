#!/system/bin/sh
# Decrypt AES-256-CBC protected classes.dex.enc (16-byte IV prefix).
MODDIR="${1:-${0%/*}}"
ENC="$MODDIR/classes.dex.enc"
OUT="$MODDIR/classes.dex"

[ -f "$ENC" ] || exit 0
[ -f "$OUT" ] && [ "$OUT" -nt "$ENC" ] && exit 0

K1="Vrt3_Hivirtus_Virtus"
K2="SelectionKey"
KEY="${K1}${K2}"

hexify() {
  if command -v xxd >/dev/null 2>&1; then
    printf '%s' "$1" | xxd -p | tr -d '\n'
  else
    printf '%s' "$1" | od -An -tx1 | tr -d ' \n'
  fi
}

KEYHEX="$(hexify "$KEY")"
IVFILE="$MODDIR/.virtus_iv.bin"
PAYLOAD="$MODDIR/.virtus_payload.bin"

dd if="$ENC" of="$IVFILE" bs=1 count=16 2>/dev/null
dd if="$ENC" of="$PAYLOAD" bs=1 skip=16 2>/dev/null
IVHEX="$(hexify "$(cat "$IVFILE")")"

if command -v openssl >/dev/null 2>&1; then
  openssl enc -d -aes-256-cbc -nosalt -in "$PAYLOAD" -out "$OUT.tmp" -K "$KEYHEX" -iv "$IVHEX" 2>/dev/null \
    && mv "$OUT.tmp" "$OUT" \
    && chmod 644 "$OUT" 2>/dev/null
fi

rm -f "$IVFILE" "$PAYLOAD" "$OUT.tmp" 2>/dev/null
