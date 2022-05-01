#!/bin/sh
wallpaper=$(cat $HOME/.cache/main_wallpaper)
monitor_height="$(xrandr | grep primary | awk -F "x|+| " '{print $5}')"
y="$(echo "$monitor_height * 0.94445" | bc)"
pos="100:$y"

colors="$(cat $HOME/.cache/wal/colors | nl -v 0)"
ring_color=$(echo "$colors" | grep -E "^\s*10\s" | cut -d "#" -f2)
inside_color=$(echo "$colors" | grep -E "^\s*0\s" | cut -d "#" -f2)

font="FiraCode"
font_color="D0D0D0"

change-wallpaper.sh &

i3lock -i $wallpaper \
--scale        \
--clock        \
--screen=1     \
--indicator    \
--radius 70    \
--ring-width=5 \
\
--date-color=$font_color  \
--time-color=$font_color  \
--verif-color=$font_color \
--wrong-color=$font_color \
\
--date-font=$font  \
--time-font=$font  \
--verif-font=$font \
--wrong-font=$font \
\
--date-size=12  \
--time-size=26  \
--verif-size=20 \
--wrong-size=20 \
\
--date-str="%a, %d %b %Y" \
\
--time-pos="$pos"          \
--ind-pos="$pos"           \
\
--ring-color=$ring_color          \
--inside-color=$inside_color      \
--insidever-color=$inside_color   \
--insidewrong-color=$inside_color \
