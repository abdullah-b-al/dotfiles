#!/usr/bin/env bash


[ -z "$1" ] && exit 1

ext="$(echo "$1" | awk -F . '{print $NF}')"

if [ "$ext" = "pdf" ]; then
    $BROWSER "$1" & disown
elif ! [ -f "$1" ] && ! [ -d "$1" ]; then # For urls
    xdg-open "$1"
else
    editor.sh "$1"
fi
