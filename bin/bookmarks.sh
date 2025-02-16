#!/bin/sh

bookmarks="$HOME/personal/bookmarks"

if [ "$1" = "put" ]; then
    [ -z "$2" ] && exit 1
    url="$2"
    title="$(curl --connect-timeout 1 -L "$url" | grep -o '<title>.*</title>' | sed -e "s:<title>::" -e "s:</title>::" -e "s:^\s*::")"
    [ -z "$title" ] && exit 1
    echo "$title @ $url" >> "$bookmarks"
    notify-send "$(basename "$0")" "$title"

elif [ "$1" = "get" ]; then
    selection="$(rofi -theme-str "listview{ columns:1; }" -dmenu -matching fuzzy -i < "$bookmarks")"
    rofi_exit_status="$?"

    url="$(echo "$selection" | awk -F '@' '{print $NF}' | sed -e "s:^\s*::")"
    [ -z "$url" ] && exit 1

    case $rofi_exit_status in
        *10*) echo "$url" | xsel --input --clipboard;;
        **) "$BROWSER" "$url"
    esac
fi
