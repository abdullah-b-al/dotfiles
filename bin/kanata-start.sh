#!/bin/sh

[ "$(pgrep 'kanata$')" ] && exit 0

file="/tmp/kanata-chch"
rm "$file"
sudo kanata -c "$DOTFILES"/.config/kanata/chch.kbd
echo "kanata for charachorder is down" > "$file"
