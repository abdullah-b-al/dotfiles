#!/bin/sh
if sudo -A virsh start win10; then
  looking-glass.sh
else
  notify-send -t 1000 "Virsh" "Couldn't boot VW"
fi
