#!/usr/bin/env bash
# Run this ONCE inside Termux on your rooted Android phone.

set -euo pipefail

echo "📱 Installing SMS Monitor (Superuser mode)"
echo "==========================================="

pkg update -y
pkg install -y curl

INSTALL_DIR="${HOME}/sms_monitor"
mkdir -p "$INSTALL_DIR"

# Copy daemon script (assumes repo cloned or files copied to phone)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "$INSTALL_DIR")"

if [ -f "$SCRIPT_DIR/sms_daemon.sh" ]; then
    cp "$SCRIPT_DIR/sms_daemon.sh" "$INSTALL_DIR/"
else
    echo "❌ sms_daemon.sh not found. Copy android/ folder to phone first."
    exit 1
fi

chmod +x "$INSTALL_DIR/sms_daemon.sh"

# Auto-start on boot (optional)
mkdir -p "${HOME}/.termux/boot"
cp "$SCRIPT_DIR/termux_boot.sh" "${HOME}/.termux/boot/sms_monitor.sh" 2>/dev/null || true
chmod +x "${HOME}/.termux/boot/sms_monitor.sh" 2>/dev/null || true

echo ""
echo "✅ Installed to $INSTALL_DIR"
echo ""
echo "Next:"
echo "  cd $INSTALL_DIR"
echo "  bash sms_daemon.sh setup"
echo "  bash sms_daemon.sh start"
echo ""
echo "Magisk mein Termux ko permanent superuser do!"
