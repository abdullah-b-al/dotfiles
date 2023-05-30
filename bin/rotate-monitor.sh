#!/bin/sh
monitor=$(xrandr | grep -Ei "\<connected\>" | awk '{print $1}' | menu)
test -z "$monitor" && exit
orientation=$(printf "normal\nleft\nright\ninverted" | menu)
test -z "$orientation" && exit
xrandr --output "$monitor" --rotate "$orientation"
