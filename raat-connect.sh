#!/bin/bash

if (($# > 2))
then
    echo "Usage:"
    echo "raat-connect          - List all vnc servers"
    echo "raat-connect [port]     - Connect to a vnc server on given port"
    exit 1
fi

ports=($(ss -lptn | grep Xvnc | awk '{split($4, a, ":"); print a[2]}'))

if (($# == 0))
then
    if [ ${#ports[@]} -eq 0 ]; then
            echo "There are no active vnc sessions"
    else
            echo "There are active sessions on ports:"
            for port in "${ports[@]}"; do
                echo "    - $port"
            done
    fi
else
    echo "${ports[*]} ||| $1"
    if [[ ${ports[*]} =~ "$1" ]]; then
        vncviewer 0.0.0.0:$1 &
    else
        echo "There is no active session on port $1"
    fi    
fi
