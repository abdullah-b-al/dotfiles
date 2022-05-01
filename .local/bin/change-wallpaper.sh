#!/bin/sh
wallpapers="$HOME/.local/wallpapers"
num_of_files="$(ls $wallpapers | wc -l)"
num="$(echo $((RANDOM % num_of_files + 1)))"
img="$(ls $wallpapers | nl | grep -E "^\s+$num\s" | awk '{print $2}')"

num="$(echo $((RANDOM % num_of_files + 1)))"
img_2="$(ls $wallpapers | nl | grep -E "^\s+$num\s" | awk '{print $2}')"

num="$(echo $((RANDOM % num_of_files + 1)))"
lock_img="$(ls $wallpapers | nl | grep -E "^\s+$num\s" | awk '{print $2}')"

feh --no-fehbg --bg-fill $wallpapers/$img $wallpapers/$img_2
wal -i "$wallpapers/$lock_img" -entsq
