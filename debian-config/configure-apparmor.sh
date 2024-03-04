#!/bin/sh
set -e

ar_virt_file="/etc/apparmor.d/abstractions/libvirt-qemu"
sed -i "s|/dev/bus/usb/ r,|/dev/bus/usb/** rw,|g" "$ar_virt_file"

grep -q "/run/udev/data/\* rw," "$ar_virt_file" || \
  sed -i "/\/sys\/class\/ r,/a \ \ /run/udev/data/* rw," "$ar_virt_file"

lg="/dev/shm/looking-glass rw,"
grep -q "$lg" "$ar_virt_file" || echo "\n$lg" >> "$ar_virt_file"

systemctl restart apparmor
