#!/bin/sh
wallpapers="$HOME/.local/wallpapers"
num_of_files="$(ls $wallpapers | wc -l)"
num="$(echo "$RANDOM % ($num_of_files + 1)" | bc)"
img="$(ls $wallpapers | nl | grep -E "^\s+$num\s" | awk '{print $2}')"

monitor_height="$(xrandr | grep primary | awk -F "x|+| " '{print $5}')"
y="$(echo "$monitor_height * 0.94445" | bc)"
pos="100:$y"

i3lock -i $wallpapers/$img \
--scale                    \
--clock                    \
--screen=1                 \
--indicator                \
--date-color=D0D0D0        \
--time-color=D0D0D0        \
--date-font=FiraCode       \
--time-font=FiraCode       \
--date-size=12             \
--time-size=26             \
--date-str="%a, %d %b %Y"  \
--time-pos="$pos"          \
--ind-pos="$pos"           \
--radius 70                \
--ind-pos="$pos"           \
--ring-width=5             \
--ring-color=0080CC
