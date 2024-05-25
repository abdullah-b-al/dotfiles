#!/bin/sh

allowed_cpu=""
if [ "$1" = "unpin" ]; then
    allowed_cpu="0-11"
elif [ "$1" = "pin" ]; then
    allowed_cpu="0,1,6,7"
elif [ -z "$1" ]; then
    cores="$(nproc)"
    [ "$cores" = "4" ] && allowed_cpu="0-11"
    [ "$cores" = "12" ] && allowed_cpu="0,1,6,7"
else
    exit 1
fi

sudo-validate.sh || exit 1
sudo systemctl set-property --runtime -- user.slice AllowedCPUs="$allowed_cpu"
sudo systemctl set-property --runtime -- system.slice AllowedCPUs="$allowed_cpu"
sudo systemctl set-property --runtime -- init.scope AllowedCPUs="$allowed_cpu"
notify-send -t 3000 CPUs "$(nproc)"
