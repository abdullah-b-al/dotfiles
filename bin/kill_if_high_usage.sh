#!/bin/sh

if [ -z "$1" ]; then
    echo "Who to kill ?"
    exit 1
fi

target="$1"

while true; do
    name="$(ps -eo comm --sort=-%mem | head -n 2 | sed -n '2p')"
    usage_percent="$(ps -eo %mem --sort=-%mem | head -n 2 | sed -n '2p')"
    usage_single_digit="$(echo "$usage_percent" | cut -d '.' -f 1)"
    if [ "$target" = "$name" ] && [ $usage_single_digit -gt "50" ]; then
        pkill "$name"
        notify-send "$(basename "$0")" "Killed $name"
    fi
done
