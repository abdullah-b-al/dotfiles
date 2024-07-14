#!/usr/bin/env bash

export DISPLAY=:0
export XAUTHORITY=/run/user/1000/Xauthority

# The `sleep` and `& disown` are workarounds to make this script work when ran by udev
(
sleep 1

setxkbmap -layout 'us'

if [ -e /dev/input/by-path/platform-i8042-serio-0-event-kbd ] && bluetoothctl info DA:18:B2:3C:8E:3B | grep -qi "connected: no"; then
    xmodmap ~/.dotfiles/colemak_dh.xmodmap
fi

xset r rate 250 50
xinput --set-prop "Cooler Master Technology Inc. MM710 Gaming Mouse" 'libinput Accel Speed' -0.5

) & disown
