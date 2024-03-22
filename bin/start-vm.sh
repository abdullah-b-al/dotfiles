#!/bin/sh

set -e

reset_method="$(cat /sys/bus/pci/devices/0000:11:00.0/reset_method)"

if [ "$reset_method" != "device_specific" ]; then
  sudo --validate || zenity --password | sudo -S --validate

  echo 'device_specific' | sudo tee /sys/bus/pci/devices/0000:11:00.0/reset_method
fi

if virsh -c "qemu:///system" start win10; then
  looking-glass.sh & disown
else
  notify-send --urgency=critical -t 3000 "Virsh" "Couldn't boot VM"
fi
