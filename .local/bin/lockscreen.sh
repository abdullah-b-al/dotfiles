#!/bin/sh
monitor_height="$(xrandr | grep primary | awk -F "x|+| " '{print $5}')"
y="$(($monitor_height - 80))"
pos="80:$y"

font="FiraCode"
font_color="D0D0D0"

i3lock -n \
-c 000000      \
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
--date-str="%a, %d %b %Y"

change-wallpaper.sh
