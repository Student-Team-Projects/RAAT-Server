#!/bin/bash

if (($# != 3))
then
    echo "Usage: raat-server [vnc password] [rfb port] [geometry]"
    exit 1
fi

display=$(($2-5900))

mkdir -p ~/.vnc && touch ~/.vnc/$2.passwd
echo $1 | vncpasswd -f > ~/.vnc/$2.passwd
setsid Xvnc -AlwaysShared -geometry $3 -rfbauth ~/.vnc/$2.passwd :$display &
DISPLAY=:$display setsid startlxde &
vncviewer -passwd ~/.vnc/$2.passwd  0.0.0.0:$2

