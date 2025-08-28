#!/usr/bin/env bash

class_from_adress() {
    address="$(echo $1 | cut -d '>' -f 3)"
    object="$(hyprctl -j clients | jq ".[] | select (.address == \"0x$address\")")"
    echo "$object" | jq -r ".class"
}

socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -U - UNIX-CONNECT:"$socket" | while read -r line; do
    if [[ "$line" == activewindow* ]]; then
        sleep 1
        class="$(hyprctl -j activewindow | jq -r ".class")"
        monitor="$(hyprctl -j activewindow | jq -r ".monitor")"
        if [[ $class == "gamescope" ]] ; then
            screen-settings-set.sh gaming
        elif [[ $class == "steam_proton" ]]; then
            screen-settings-set.sh gaming
        elif [[ $class =~ "steam_app" ]]; then
            screen-settings-set.sh gaming
        elif [[ "$monitor" = "0" ]]; then
            screen-settings-set.sh
        fi
    fi
done
