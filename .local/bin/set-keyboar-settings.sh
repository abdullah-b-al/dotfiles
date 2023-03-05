#!/bin/sh
if lsusb | grep -i ergodox; then
  setxkbmap -layout 'us,ar' -option 'grp:alt_shift_toggle' &
else
  setxkbmap -layout 'us,ar' -option 'grp:alt_shift_toggle' &
fi

xset r rate 250 40
