#!/bin/sh
wallpapers="$HOME/.local/wallpapers"
num_of_files="$(ls $wallpapers | wc -l)"
num="$(echo "$RANDOM % ($num_of_files + 1)" | bc)"
img="$(ls $wallpapers | nl | grep -E "^\s+$num\s" | awk '{print $2}')"

num="$(echo "$RANDOM % ($num_of_files + 1)" | bc)"
img_2="$(ls $wallpapers | nl | grep -E "^\s+$num\s" | awk '{print $2}')"

echo $wallpapers/$img > $HOME/.cache/main_wallpaper
feh --no-fehbg --bg-fill $wallpapers/$img $wallpapers/$img_2 $wallpapers/$img_3
wal -i "$wallpapers/$img" -entsq
