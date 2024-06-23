#!/bin/sh

setxkbmap -layout 'us'
if [ -e /dev/input/by-path/platform-i8042-serio-0-event-kbd ] && ! bluetoothctl info DA:18:B2:3C:8E:3B | grep -q Connected; then
  xmodmap ~/.dotfiles/colemak_dh.xmodmap
fi

xset r rate 250 40
xinput --set-prop "Cooler Master Technology Inc. MM710 Gaming Mouse" 'libinput Accel Speed' -0.5
