#!/bin/sh
sudo systemctl set-property --runtime -- user.slice AllowedCPUs=0,1,6,7
sudo systemctl set-property --runtime -- system.slice AllowedCPUs=0,1,6,7
sudo systemctl set-property --runtime -- init.scope AllowedCPUs=0,1,6,7
notify-send -t 3000 CPUs "$(nproc)"
