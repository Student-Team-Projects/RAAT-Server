#!/bin/bash

# Usage: raat-close-session.sh [rfb port] 
#
# Example:
#   ./raat-close-session.sh 5901 

if [ $# -ne 1 ]; then
    echo "Usage: $0 [rfb port]"
    exit 1
fi

rfb_port=$1

display=$((rfb_port - 5900))

# --- CLEANUP SECTION ---
# Kill any leftover Xvnc processes on this display
pkill -f "Xvnc.*:$display"
# Kill leftover desktop environment processes that might still be running
pkill -f "startlxde.*DISPLAY=:$display"
pkill -f "startxfce4.*DISPLAY=:$display"

# If you used dbus-run-session, it may have leftover processes too:
pkill -f "dbus-run-session.*:$display"