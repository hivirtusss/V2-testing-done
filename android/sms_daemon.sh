#!/data/data/com.termux/files/usr/bin/bash
# SMS Monitor Daemon — reads SMS via superuser (su/root) and forwards to server.
# Run inside Termux on a rooted Android phone.

set -euo pipefail

CONFIG_FILE="${HOME}/.sms_monitor_config"
STATE_FILE="${HOME}/.sms_monitor_state"
LOG_FILE="${HOME}/.sms_monitor.log"
POLL_INTERVAL=3

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config missing. Run: bash sms_daemon.sh setup"
        exit 1
    fi
    # shellcheck disable=SC1090
    source "$CONFIG_FILE"
    : "${SERVER_URL:?SERVER_URL not set}"
    : "${API_KEY:?API_KEY not set}"
    DEVICE_NAME="${DEVICE_NAME:-$(getprop ro.product.model 2>/dev/null || echo android)}"
}

save_state() {
    echo "LAST_SMS_ID=${LAST_SMS_ID:-0}" > "$STATE_FILE"
}

load_state() {
    if [ -f "$STATE_FILE" ]; then
        # shellcheck disable=SC1090
        source "$STATE_FILE"
    fi
    LAST_SMS_ID="${LAST_SMS_ID:-0}"
}

check_root() {
    if ! command -v su >/dev/null 2>&1; then
        log "❌ 'su' not found. Phone must be rooted (Magisk/SuperSU)."
        exit 1
    fi

    if ! su -c "id" 2>/dev/null | grep -q "uid=0"; then
        log "❌ Superuser access denied. Grant Termux permanent root in Magisk."
        exit 1
    fi

    log "✅ Superuser access OK"
}

query_sms() {
    su -c "content query --uri content://sms/inbox --projection _id,address,body,date --sort 'date ASC'"
}

forward_sms() {
    local sender="$1"
    local message="$2"
    local sms_id="$3"

    local payload
    payload=$(cat <<EOF
{"sender":"${sender}","message":"${message//\"/\\\"}","device_name":"${DEVICE_NAME}","timestamp":null}
EOF
)

    if curl -sf -X POST "${SERVER_URL}/api/sms?key=${API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$payload" >/dev/null; then
        log "📤 Forwarded SMS #$sms_id from $sender"
        LAST_SMS_ID="$sms_id"
        save_state
    else
        log "❌ Failed to forward SMS #$sms_id (server unreachable?)"
    fi
}

process_sms() {
    local raw
    raw="$(query_sms 2>/dev/null || true)"

    if [ -z "$raw" ]; then
        return
    fi

    while IFS= read -r line; do
        [[ "$line" =~ ^Row: ]] || continue

        local sms_id sender body
        sms_id=$(echo "$line" | sed -n 's/.*_id=\([0-9]*\).*/\1/p')
        sender=$(echo "$line" | sed -n 's/.*address=\([^,]*\).*/\1/p')
        body=$(echo "$line" | sed -n 's/.*body=\([^,]*\), date=.*/\1/p')

        [ -z "$sms_id" ] && continue
        [ "$sms_id" -le "$LAST_SMS_ID" ] && continue
        [ -z "$body" ] && continue

        forward_sms "$sender" "$body" "$sms_id"
    done <<< "$raw"
}

run_daemon() {
    load_config
    load_state
    check_root

    log "🚀 SMS daemon started (device: $DEVICE_NAME, last_id: $LAST_SMS_ID)"
    log "📡 Server: $SERVER_URL"

    while true; do
        process_sms
        sleep "$POLL_INTERVAL"
    done
}

run_setup() {
    echo "📱 SMS Monitor — Superuser Setup (Termux)"
    echo "=========================================="
    echo ""
    echo "Requirements:"
    echo "  - Rooted phone (Magisk recommended)"
    echo "  - Termux app installed"
    echo "  - Termux granted superuser in Magisk"
    echo ""

    read -rp "Server URL (e.g. https://abc.ngrok.io): " SERVER_URL
    read -rp "API Secret Key: " API_KEY
    read -rp "Device name [$(getprop ro.product.model 2>/dev/null || echo my-phone)]: " DEVICE_NAME

    DEVICE_NAME="${DEVICE_NAME:-$(getprop ro.product.model 2>/dev/null || echo my-phone)}"
    SERVER_URL="${SERVER_URL%/}"

    cat > "$CONFIG_FILE" <<EOF
SERVER_URL="$SERVER_URL"
API_KEY="$API_KEY"
DEVICE_NAME="$DEVICE_NAME"
EOF

    echo "0" > "$STATE_FILE"
    echo ""
    echo "✅ Config saved to $CONFIG_FILE"
    echo ""
    echo "Start daemon:"
    echo "  bash sms_daemon.sh start"
    echo ""
    echo "Run in background:"
    echo "  nohup bash sms_daemon.sh start >> $LOG_FILE 2>&1 &"
}

run_test() {
    load_config
    check_root
    log "Testing server connection..."
    curl -sf "${SERVER_URL}/health" && log "✅ Server reachable" || log "❌ Server unreachable"
    log "Sample SMS query:"
    query_sms | tail -3 | tee -a "$LOG_FILE"
}

case "${1:-}" in
    setup)  run_setup ;;
    start)  run_daemon ;;
    test)   run_test ;;
    *)
        echo "Usage: bash sms_daemon.sh {setup|start|test}"
        exit 1
        ;;
esac
