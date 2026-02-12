#!/bin/sh

while true; do
    echo "== New Session ==" >> /tmp/alacritty-daemon.log
    alacritty --daemon 2>&1 >> /tmp/alacritty-daemon.log
    notify-send "Alacritty daemon stopped. Restarting..."
    sleep 1
done
