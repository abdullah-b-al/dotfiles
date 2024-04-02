#!/bin/sh

file="$HOME/personal/a.md"
line="$(cat "$file" | rofi -dmenu -matching fuzzy -i)"

[ -z "$line" ] && exit

num=$(echo "$line" | awk '{print $NF}')
new_num="$((num+1))"
new_line="$(echo "$line" | sed "s|$num|$new_num|g")"
sed -i "s|$line|$new_line|g" "$file" && notify-send -t 3000 "$new_line"
