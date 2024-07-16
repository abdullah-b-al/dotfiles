#!/bin/sh


bookmarks="$HOME/personal/bookmarks"
selection="$(rofi -kb-custom-1 "Control+c" -dmenu -matching fuzzy -i < "$bookmarks")"
rofi_exit_status="$?"

url="$(echo "$selection" | awk -F '@' '{print $NF}')"

[ -z "$url" ] && exit 1

case $rofi_exit_status in
    *10*) echo "$url" | xsel --input --clipboard;;
    **) "$BROWSER" "$url"
esac
