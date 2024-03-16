#!/bin/sh
zenity --scale --step=5 --min-value=10 --value=50 | xargs -I {} brightnessctl s {}%
info=$(brightnessctl i | grep -i current | sed 's/^\t//g')
notify-send -t 3000 "$info"
