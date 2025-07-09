#!/bin/sh

toggle() {
    if setxkbmap -query | grep -q "^layout:.*us$"; then
        setxkbmap -layout 'ara'
    else
        setxkbmap -layout 'us'
    fi
}

if [ $XDG_SESSION_TYPE = x11 ]; then

    case "$1" in
        "toggle") toggle;;
        "us") setxkbmap -layout 'us';;
        "ara") setxkbmap -layout 'ara';;
    esac
else
    hyprctl switchxkblayout all next
fi

# set-keyboard-settings.sh
