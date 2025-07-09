#!/bin/sh

if [ -t 0 ]; then
    alias menu="fzf"
else
    alias menu="rofi -dmenu -matching fuzzy -i"
fi

id_get() {
    wpctl status \
        | sed -n '/Clients/,$p' \
        | sed '1d' \
        | grep -iv "wireplumber\|xdg-desktop-portal\|pipewire" \
        | sed '/^$/q' \
        | sed -e 's/^\s*//g' \
        | sed -e 's:\[.*\]$::g' \
        | sed '/^\s*$/d' \
        | menu \
        | cut -d . -f 1
}

# picked="$(pulsemixer --list-sinks | grep -o "Name:.*, Mute: ." | menu | cut -f 1 -d ',')"
# [ -z "$picked" ] && exit 1
# id="$(pulsemixer --list-sinks | grep -F "$picked" | grep -o "sink-.*" | cut -f 1 -d ',')"
# [ -z "$id" ] && exit 1
# pulsemixer --id "$id" --toggle-mute

id=$(id_get)
[ -z "$id" ] && exit 0
wpctl set-mute "$id" toggle
# pw-dump | jq '.[] | select(.type=="PipeWire:Interface:Node")' | jq -r '.. | .["application.name"]? // empty'
#  pw-dump | jq -r '.[] | select(.type=="PipeWire:Interface:Node")' | jq -r '.. | .["application.name"]? // empty'
