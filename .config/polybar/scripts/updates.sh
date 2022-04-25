#!/usr/bin/env bash

NOTIFY_ICON=/usr/share/icons/Papirus/32x32/apps/system-software-update.svg

get_total_updates() { UPDATES=$(checkupdates 2>/dev/null | wc -l); }

while true; do
    get_total_updates

    # when there are updates available
    # every 15 min another check for updates is done
    while (( UPDATES > 0 )); do
        if (( UPDATES >= 1 )); then
            echo " $UPDATES"
        else
            echo " None"
        fi
        sleep 900
        get_total_updates
    done

    # when no updates are available, use a longer loop, this saves on CPU
    # and network uptime, only checking once every 30 min for new updates
    while (( UPDATES == 0 )); do
        echo " None"
        sleep 1800
        get_total_updates
    done
done
