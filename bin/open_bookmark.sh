#!/bin/sh
set -e

bookmarks="$HOME/personal/bookmarks"

url="$(cat "$bookmarks" | rofi -dmenu -matching fuzzy -i | awk -F '@' '{print $NF}')"

[ -z "$url" ] && exit 1

echo "$url" | xsel --input --clipboard
