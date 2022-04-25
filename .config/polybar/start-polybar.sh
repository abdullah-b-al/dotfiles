#!/bin/sh

DIR="$HOME/.config/polybar"

while true; do
  killall -q polybar

  # Wait until the processes have been shut down
  while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

  polybar -q main -c "$DIR"/config.ini
done
