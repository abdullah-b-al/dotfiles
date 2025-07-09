#!/bin/sh

[ -z "$1" ] && exit 1

ext="$(echo "$1" | awk -F . '{print $NF}')"

if [ "$ext" = "pdf" ]; then
    "$BROWSER" "$1" &
elif ! [ -f "$1" ] && ! [ -d "$1" ]; then # For urls
    xdg-open "$1"
else
    if [ "$XDG_SESSION_TYPE" = "x11" ]; then
        awesome-client 'require("rc2").spawn_or_goto_terminal()'
    fi
    editor.sh "$1"
fi
