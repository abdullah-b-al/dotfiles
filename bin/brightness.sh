#!/bin/sh
brightnessctl s "$1"
info=$(brightnessctl i | grep -i current | sed 's/^\t//g')
notify-send -t 3000 "$info"
