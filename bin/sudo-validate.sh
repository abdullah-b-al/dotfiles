#!/bin/sh

if ! sudo --validate; then
    if ! zenity --password | sudo -S --validate; then
        notify-send -u critical -t 2000 "Wrong password"
    fi
fi
