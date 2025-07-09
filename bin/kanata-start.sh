#!/bin/sh

[ "$(pgrep 'kanata$')" ] && exit 0

sudo kanata -c "$DOTFILES"/.config/kanata/chch.kbd
sleep 2
"$DOTFILES"/bin/set-keyboard-settings.sh
notify-send -u critical "kanata exited $?"
