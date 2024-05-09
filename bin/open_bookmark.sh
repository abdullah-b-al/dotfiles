#!/bin/sh
set -e

bookmarks="$HOME/personal/bookmarks"

url="$(rofi -dmenu -matching fuzzy -i < "$bookmarks" | awk -F '@' '{print $NF}')"

[ -z "$url" ] && exit 1

echo "$url" | xsel --input --clipboard
