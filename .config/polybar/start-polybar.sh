#!/bin/sh
while true;do
  killall polybar 2>/dev/null
  if pgrep dwm; then
    polybar --config=$HOME/.config/polybar/config.ini example
  fi
done
