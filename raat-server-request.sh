#!/usr/bin/env bash

set -euo pipefail

COMMAND=""
VNC_PASSWORD=""
RFB_PORT=""
GEOMETRY=""
DE_CHOICE=""

CONFIG_DIR="$HOME/.config/raat-server"
CONFIG_FILE="$CONFIG_DIR/sessions.json"
RAAT_CLOSE_SCRIPT="./raat-close-session.sh"  # Adjust path if needed

usage() {
    echo "Usage:"
    echo "$0 open-session --vnc_password=<pass> --rfb_port=<port> --geometry=<WxH> --de_choice=<lxde|xfce>"
    echo "$0 kill-session --rfb_port=<port>"
    echo "$0 get-session-status --rfb_port=<port>"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        open-session|kill-session|get-session-status)
            COMMAND="$1"
            shift
            ;;
        --vnc_password=*)
            VNC_PASSWORD="${1#*=}"
            shift
            ;;
        --rfb_port=*)
            RFB_PORT="${1#*=}"
            shift
            ;;
        --geometry=*)
            GEOMETRY="${1#*=}"
            shift
            ;;
        --de_choice=*)
            DE_CHOICE="${1#*=}"
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            ;;
    esac
done

if [ -z "$COMMAND" ]; then
    usage
fi

mkdir -p "$CONFIG_DIR"

# Ensure we have a sessions file
if [ ! -f "$CONFIG_FILE" ]; then
    echo "{}" > "$CONFIG_FILE"
fi

# Load a function to get session info from JSON
get_session_field() {
    local port="$1"
    local field="$2"
    jq -r ".[\"$port\"].$field // empty" "$CONFIG_FILE"
}

set_session() {
    local port="$1"
    local vnc_password="$2"
    local rfb_port="$3"
    local geometry="$4"
    local de_choice="$5"
    jq --arg port "$port" \
       --arg vnc_password "$vnc_password" \
       --argjson rfb_port "$rfb_port" \
       --arg geometry "$geometry" \
       --arg de_choice "$de_choice" \
       '.[$port] = {vnc_password: $vnc_password, rfb_port: $rfb_port, geometry: $geometry, de_choice: $de_choice}' \
       "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
}

remove_session() {
    local port="$1"
    jq "del(.\"$port\")" "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
}

is_session_alive() {
    local port="$1"
    local display=$((port - 5900))
    # Check if Xvnc is running
    if pgrep -f "Xvnc.*:$display" >/dev/null; then
        return 0
    else
        return 1
    fi
}

kill_existing_session() {
    local port="$1"
    setsid "$RAAT_CLOSE_SCRIPT" "$port"
}

start_new_session() {
    local vnc_password="$1"
    local rfb_port="$2"
    local geometry="$3"
    local de_choice="$4"
    
    # This script assumes it runs in background:
    bash raat-server "$vnc_password" "$rfb_port" "$geometry" "$de_choice"
    # We are not waiting for it, so we return immediately.
}

if [ "$COMMAND" = "open-session" ]; then
    if [ -z "$VNC_PASSWORD" ] || [ -z "$RFB_PORT" ] || [ -z "$GEOMETRY" ] || [ -z "$DE_CHOICE" ]; then
        usage
    fi

    # Check if session exists
    EXISTING_VNC_PASSWORD=$(get_session_field "$RFB_PORT" "vnc_password")
    EXISTING_RFB_PORT=$(get_session_field "$RFB_PORT" "rfb_port")
    EXISTING_GEOMETRY=$(get_session_field "$RFB_PORT" "geometry")
    EXISTING_DE_CHOICE=$(get_session_field "$RFB_PORT" "de_choice")

    if [ -n "$EXISTING_RFB_PORT" ]; then
        # Session exists in config
        same_params="false"
        if [ "$EXISTING_VNC_PASSWORD" = "$VNC_PASSWORD" ] && \
           [ "$EXISTING_RFB_PORT" = "$RFB_PORT" ] && \
           [ "$EXISTING_GEOMETRY" = "$GEOMETRY" ] && \
           [ "$EXISTING_DE_CHOICE" = "$DE_CHOICE" ]; then
            same_params="true"
        fi
        if is_session_alive "$RFB_PORT"; then
            if [ "$same_params" = "true" ]; then
                echo "Session already running with the same parameters."
                exit 0
            else
                # Different params or need refresh: kill first
                kill_existing_session "$RFB_PORT"
            fi
        else
            # Session not alive but exists in config, kill to cleanup if needed
            kill_existing_session "$RFB_PORT"
        fi
    fi

    # Start a new session
    set_session "$RFB_PORT" "$VNC_PASSWORD" "$RFB_PORT" "$GEOMETRY" "$DE_CHOICE"
    start_new_session "$VNC_PASSWORD" "$RFB_PORT" "$GEOMETRY" "$DE_CHOICE"
    echo "Session started."

elif [ "$COMMAND" = "kill-session" ]; then
    if [ -z "$RFB_PORT" ]; then
        usage
    fi
    EXISTING_RFB_PORT=$(get_session_field "$RFB_PORT" "rfb_port")
    if [ -z "$EXISTING_RFB_PORT" ]; then
        echo "No session found for that port."
        exit 0
    fi
    kill_existing_session "$RFB_PORT"
    remove_session "$RFB_PORT"
    echo "Session killed."

elif [ "$COMMAND" = "get-session-status" ]; then
    if [ -z "$RFB_PORT" ]; then
        usage
    fi
    EXISTING_RFB_PORT=$(get_session_field "$RFB_PORT" "rfb_port")
    if [ -z "$EXISTING_RFB_PORT" ]; then
        echo "No session found for that port."
        exit 0
    fi
    if is_session_alive "$RFB_PORT"; then
        echo "Session alive."
    else
        echo "Session not alive."
    fi

else
    echo "Unknown command: $COMMAND"
    usage
fi
