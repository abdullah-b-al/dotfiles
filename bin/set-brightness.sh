#!/bin/sh
zenity --entry --text="Brightness percent" --entry-text=50 | xargs -I {} brightnessctl s {}%
info=$(brightnessctl i | grep -i current | sed 's/^\t//g')
notify-send -t 3000 "$info"
