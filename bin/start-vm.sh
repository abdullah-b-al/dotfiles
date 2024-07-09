#!/bin/sh 

if [ "$(virsh domstate win10)" = "running" ]; then
    looking-glass.sh
    exit 0
fi

reset_method="$(cat /sys/bus/pci/devices/0000:11:00.0/reset_method)"
if [ "$reset_method" != "device_specific" ]; then
    echo 'device_specific' | sudo -A tee /sys/bus/pci/devices/0000:11:00.0/reset_method
    if [ "$?" = "1" ]; then
        notify-send --urgency=critical -t 3000 "$0" "tee command failed"
        exit 1
    fi
fi

# lsmod | grep -q bluetooth && {
#   sudo --validate || zenity --password | sudo -S --validate;
#   sudo rmmod btusb btrtl btmtk btintel btbcm bluetooth || true;
# };

usb-hot-plug.sh detach 045e:02ea # xbox controller
# usb-hot-plug.sh detach 8087:0aa7 # bluetooth

output="$(virsh -c "qemu:///system" start win10 2>&1)"
exit_status="$?"
if [ "$exit_status" = "0" ]; then
    looking-glass.sh &
else
    notify-send --urgency=critical -t 3000 "Virsh" "$output"
fi
