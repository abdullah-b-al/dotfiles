#!/usr/bin/env bash

should_sleep=false
[ -z "$DISPLAY" ] && should_sleep=true

export DISPLAY=:0
export XAUTHORITY=/run/user/1000/Xauthority

# The `sleep` and `& disown` are workarounds to make this script work when ran by udev
(
[ "$should_sleep" = true ] && sleep 1

if bluetoothctl info DA:18:B2:3C:8E:3B | grep -qi "connected: no"; then
    if setxkbmap -query | grep "layout:\s*us$"; then
        xmodmap ~/.dotfiles/colemak_dh.xmodmap
    fi
fi

xset r rate 250 50
xinput --set-prop "Cooler Master Technology Inc. MM710 Gaming Mouse" 'libinput Accel Speed' -0.5

) & disown
