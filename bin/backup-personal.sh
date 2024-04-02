#!/bin/sh
export DISPLAY=:0
export XAUTHORITY=/run/user/1000/Xauthority
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
rsync -a --exclude "*/zig-cache" --exclude "*/zig-out" "$HOME"/personal/* /mnt/linuxHDD/personal_backup && notify-send -t 3000 "backup-personal.sh" "Done backing-up" || notify-send --urgency=critical -t 3000 "backup-personal.sh" "Backing-up failed"
