#!/usr/bin/env bash

while true; do
    event="$(swaymsg -t subscribe '[ "window" ]')"
    focused="$(echo "$event" | jq -r '.change | select(test("focus"))')"
    [ -z $focused ] && continue
    result="$(echo "$event" | jq -r '.. | strings | select(test("gamescope|steam_proton|steam_app"))' | tail -n 1)"
    monitor="$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .output')"
    if [[ $result == "gamescope" ]] ; then
        screen-settings-set.sh gaming
    elif [[ $result == "steam_proton" ]]; then
        screen-settings-set.sh gaming
    elif [[ $result =~ "steam_app" ]]; then
        screen-settings-set.sh gaming
    elif [[ "$monitor" = "DP-1" ]]; then
        screen-settings-set.sh
    fi

done
