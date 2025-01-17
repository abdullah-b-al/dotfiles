#!/bin/sh

[ -z "$1" ] && exit 1

ext="$(echo "$1" | awk -F . '{print $NF}')"

if [ "$ext" = "pdf" ]; then
    "$BROWSER" "$1" &
elif ! [ -f "$1" ] && ! [ -d "$1" ]; then # For urls
    xdg-open "$1"
else
    awesome-client 'require("rc2").spawn_or_goto_terminal()'
    editor.sh "$1"
fi
