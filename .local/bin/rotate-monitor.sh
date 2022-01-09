#!/bin/sh
monitor=$(xrandr | grep -Ei "\<connected\>" | awk '{print $1}' | rofi -dmenu)
test -z "$monitor" && exit
orientation=$(printf "normal\nleft\nright\ninverted" | rofi -dmenu)
test -z "$orientation" && exit
xrandr --output "$monitor" --rotate "$orientation"
