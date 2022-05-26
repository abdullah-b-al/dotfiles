#!/bin/sh
wallpapers="$HOME/personal/wallpapers"
num_of_files="$(ls $wallpapers | wc -l)"
num="$(echo $((RANDOM % num_of_files + 1)))"
img="$(ls $wallpapers | nl | grep -E "^\s+$num\s" | awk '{print $2}')"

num="$(echo $((RANDOM % num_of_files + 1)))"
lock_img="$(ls $wallpapers | nl | grep -E "^\s+$num\s" | awk '{print $2}')"

feh --no-fehbg --bg-fill $wallpapers/$img &
wal -i "$wallpapers/$lock_img" -entsq &
# ~/.config/polybar/scripts/pywal.sh $wallpapers/$img
