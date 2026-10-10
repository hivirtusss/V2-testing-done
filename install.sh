#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "📱 SMS Monitor Bot — Superuser Install"
echo "======================================="

if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ python3 not found. Install Python 3 first."
    exit 1
fi

if [ ! -f .env ]; then
    cp .env.example .env
    echo "✅ Created .env from .env.example"
    echo "   Edit .env and add TELEGRAM_BOT_TOKEN + API_SECRET_KEY"
fi

python3 -m pip install -r requirements.txt --user -q
echo "✅ Python dependencies installed"

if [ "$(id -u)" -eq 0 ]; then
    INSTALL_DIR="/opt/sms-monitor"
    echo "🔐 Running as root — installing to $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
    rsync -a --exclude '.git' --exclude '__pycache__' --exclude '*.db' "$ROOT_DIR/" "$INSTALL_DIR/"
    cd "$INSTALL_DIR"

    if [ ! -f "$INSTALL_DIR/.env" ]; then
        cp .env.example .env
    fi

    python3 -m pip install -r requirements.txt -q

    cat > /etc/systemd/system/sms-monitor.service <<EOF
[Unit]
Description=Remote SMS Monitor Bot
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$INSTALL_DIR
EnvironmentFile=$INSTALL_DIR/.env
ExecStart=/usr/bin/python3 $INSTALL_DIR/run.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable sms-monitor
    echo "✅ systemd service installed: sms-monitor"
    echo ""
    echo "Next steps:"
    echo "  1. Edit $INSTALL_DIR/.env"
    echo "  2. sudo systemctl start sms-monitor"
    echo "  3. sudo systemctl status sms-monitor"
else
    echo "✅ Installed for current user"
    echo ""
    echo "Start server:"
    echo "  ./start.sh"
fi
