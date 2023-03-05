#!/bin/sh
setxkbmap -layout 'us,ar' -option 'grp:alt_shift_toggle'

if lsusb | grep -i ergodox ; then
  setxkbmap -layout 'us,ar' -option 'grp:alt_shift_toggle'
else
  xmodmap ~/.dotfiles/colemak_dh.xmodmap
fi


xset r rate 250 40
