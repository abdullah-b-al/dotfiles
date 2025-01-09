#!/bin/sh 

domain="win10"

if [ "$(virsh domstate "$domain")" = "running" ]; then
    looking-glass.sh
    exit 0
fi

reset_path="/sys/bus/pci/devices/0000:11:00.0/reset_method"
reset_method="$(cat $reset_path)"
while [ "$reset_method" != "device_specific" ]; do
    echo 'device_specific' | sudo -A tee "$reset_path"
    if [ "$?" = "1" ]; then
        notify-send --urgency=critical -t 3000 "$0" "tee command failed"
        exit 1
    fi
    reset_method="$(cat $reset_path)"
    sleep 0.1
done

# lsmod | grep -q bluetooth && {
#   sudo --validate || zenity --password | sudo -S --validate;
#   sudo rmmod btusb btrtl btmtk btintel btbcm bluetooth || true;
# };

usb-hot-plug.sh detach 045e:02ea quiet # xbox controller
# usb-hot-plug.sh detach 8087:0aa7 # bluetooth

output="$(virsh -c "qemu:///system" start "$domain" 2>&1)"
exit_status="$?"
if [ "$exit_status" = "0" ]; then
    looking-glass.sh &

    i=0
    while ! virsh qemu-agent-command --domain "$domain" --cmd '{"execute": "guest-ping"}'; do
        [ "$i" -gt 60 ] && exit 1
        i="$((i+1))"
        sleep 1
    done

    # usb-hot-plug.sh detach 045e:02ea quiet # xbox controller
    usb-hot-plug.sh attach 045e:02ea
else
    notify-send --urgency=critical -t 3000 "Virsh" "$output"
fi
