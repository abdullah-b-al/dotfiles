#!/bin/env bash

set -e

reset_method="$(cat /sys/bus/pci/devices/0000:11:00.0/reset_method)"

if [ "$reset_method" != "device_specific" ]; then
  sudo --validate || zenity --password | sudo -S --validate

  echo 'device_specific' | sudo tee /sys/bus/pci/devices/0000:11:00.0/reset_method
fi

# lsmod | grep -q bluetooth && {
#   sudo --validate || zenity --password | sudo -S --validate;
#   sudo rmmod btusb btrtl btmtk btintel btbcm bluetooth || true;
# };

usb-hot-plug.sh detach 045e:02ea || true # xbox controller
# usb-hot-plug.sh detach 8087:0aa7 || true # bluetooth

if virsh -c "qemu:///system" start win10; then
  looking-glass.sh > /dev/null & disown

  usb-hot-plug.sh attach 045e:02ea || true # xbox controller
  # usb-hot-plug.sh attach 8087:0aa7 || true # bluetooth
else
  notify-send --urgency=critical -t 3000 "Virsh" "Couldn't boot VM"
fi
