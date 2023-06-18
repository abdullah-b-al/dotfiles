#!/bin/sh

setxkbmap -layout 'us,ara' -option 'grp:alt_shift_toggle'
if ! lsusb | grep -i ergodox; then
  xmodmap ~/.dotfiles/colemak_dh.xmodmap
fi

xset r rate 250 40
