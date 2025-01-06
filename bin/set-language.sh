#!/bin/sh

toggle() {
    if setxkbmap -query | grep -q "^layout:.*us$"; then
        setxkbmap -layout 'ara'
    else
        setxkbmap -layout 'us'
    fi
}

case "$1" in
    "toggle") toggle;;
    "us") setxkbmap -layout 'us';;
    "ara") setxkbmap -layout 'ara';;
esac

set-keyboard-settings.sh
