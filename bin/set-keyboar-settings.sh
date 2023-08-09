#!/bin/sh

setxkbmap -layout 'us,ara' -option 'grp:alt_shift_toggle'
if ! lsusb | grep -i ergodox; then
  xmodmap ~/.dotfiles/colemak_dh.xmodmap
fi

xset r rate 250 40
xinput --set-prop "Cooler Master Technology Inc. MM710 Gaming Mouse" 'libinput Accel Speed' -0.5
