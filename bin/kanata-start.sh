#!/bin/sh

[ "$(pgrep 'kanata$')" ] && exit 0

sudo kanata -c "$DOTFILES"/.config/kanata/chch.kbd
notify-send -u critical "kanata exited $?"
