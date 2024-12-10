#!/bin/bash

# Usage: raat-server.sh [vnc password] [rfb port] [geometry] [lxde|xfce]
#
# Example:
#   ./raat-server.sh mypassword 5901 1280x800 lxde
#   ./raat-server.sh mypassword 5902 1280x800 xfce

if [ $# -ne 4 ]; then
    echo "Usage: $0 [vnc password] [rfb port] [geometry] [lxde|xfce]"
    exit 1
fi

vnc_password=$1
rfb_port=$2
geometry=$3
de_choice=$4

display=$((rfb_port - 5900))
config_dir="$HOME/.config/raat-server"
passwd_file="$config_dir/$rfb_port.passwd"

mkdir -p "$config_dir"
echo "$vnc_password" | vncpasswd -f > "$passwd_file"

# Decide which desktop environment to launch
if [ "$de_choice" = "Lxde" ] || [ "$de_choice" = "lxde" ]; then
    DE_CMD="startlxde"
elif [ "$de_choice" = "Xfce" ] || [ "$de_choice" = "xfce" ]; then
    # Using dbus-run-session for XFCE
    DE_CMD="dbus-run-session startxfce4"
else
    echo "Error: Unknown desktop environment: $de_choice"
    echo "Please choose either 'Lxde' or 'Xfce'."
    exit 1
fi

# Start the Xvnc server
setsid Xvnc -AlwaysShared -geometry "$geometry" -rfbauth "$passwd_file" :$display &
vnc_pid=$!

# Wait for the display to initialize
sleep 2

# Start the chosen desktop environment
DISPLAY=:$display setsid $DE_CMD &
de_pid=$!

# Optionally start a VNC viewer
vncviewer -passwd "$passwd_file" 0.0.0.0:$rfb_port &
viewer_pid=$!

# Wait for processes to end
wait $vnc_pid $de_pid $viewer_pid
