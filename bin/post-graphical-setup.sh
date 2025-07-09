#!/bin/sh
dbus-update-activation-environment --all
screen-settings-set.sh
pgrep sxhkd > /dev/null || sxhkd &
pgrep nextcloud > /dev/null || nextcloud --background &
brightnessctl s 20%
kanata-start.sh &

if [ $XDG_SESSION_TYPE = x11 ]; then
    set-keyboard-settings.sh

    if command -v otd-daemon > /dev/null; then
        set-tablet-settings.sh &
    fi

fi
