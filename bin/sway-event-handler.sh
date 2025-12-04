#!/usr/bin/env bash

pid_name() {
    cat /proc/$1/comm 2>/dev/null
}
ancestors() {
    pid="$1"
    while [ "$pid" -ne 1 ]; do
        name=$(pid_name $pid)
        printf "%s\n" "$name"

        pid=$(awk '{print $4}' /proc/$pid/stat 2>/dev/null)
    done
}

is_steam_game() {
    pid="$1"
    if [ "$(pid_name $pid)" = "steamwebhelper" ]; then
        echo no
    elif [ "$(ancestors "$pid" | grep "^steam$")" ]; then
        echo yes
    else
        echo no
    fi
}

while true; do
    event="$(swaymsg -t subscribe '[ "window" ]')"
    focused="$(echo "$event" | jq -r '.change | select(test("focus"))')"
    [ -z $focused ] && continue
    result="$(echo "$event" | jq -r '.. | strings | select(test("gamescope|steam_proton|steam_app"))' | tail -n 1)"
    pid="$(echo "$event" | jq '.. | .pid? // empty' )"
    monitor="$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .output')"
    if [[ $result == "gamescope" ]] || [ "$(is_steam_game "$pid")" = "yes" ]; then
        screen-settings-set.sh gaming
    elif [[ $result == "steam_proton" ]]; then
        screen-settings-set.sh gaming
    elif [[ $result =~ "steam_app" ]]; then
        screen-settings-set.sh gaming
    elif [[ "$monitor" = "DP-1" ]]; then
        screen-settings-set.sh
    fi

done
