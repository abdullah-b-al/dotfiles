#!/bin/sh
if virsh -c "qemu:///system" start win10; then
  looking-glass.sh
else
  notify-send --urgency=critical -t 3000 "Virsh" "Couldn't boot VM"
fi
