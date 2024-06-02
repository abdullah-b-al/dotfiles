#!/bin/sh

if [ -t 0 ]; then
    alias menu="fzf"
else
    alias menu="rofi -dmenu -matching fuzzy -i"
fi

picked="$(pulsemixer --list-sinks | grep -o "Name:.*, Mute: ." | menu | cut -f 1 -d ',')"
[ -z "$picked" ] && exit 1
id="$(pulsemixer --list-sinks | grep -F "$picked" | grep -o "sink-.*" | cut -f 1 -d ',')"
[ -z "$id" ] && exit 1
pulsemixer --id "$id" --toggle-mute
