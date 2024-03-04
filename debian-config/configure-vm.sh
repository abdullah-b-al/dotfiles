#!/bin/sh
set -e

##########
# apparmor

ar_virt_file="/etc/apparmor.d/abstractions/libvirt-qemu"
sed -i "s|/dev/bus/usb/ r,|/dev/bus/usb/** rw,|g" "$ar_virt_file"

grep -q "/run/udev/data/\* rw," "$ar_virt_file" || \
  sed -i "/\/sys\/class\/ r,/a \ \ /run/udev/data/* rw," "$ar_virt_file"

lg="/dev/shm/looking-glass rw,"
grep -q "$lg" "$ar_virt_file" || echo "\n$lg" >> "$ar_virt_file"

systemctl restart apparmor

# apparmor
##########

##########
# libvirt

sub="#unix_sock_group = \"libvirt\""
with="unix_sock_group = \"libvirt\""
sed -i "s|$sub|$with|g" /etc/libvirt/libvirtd.conf

sub="#unix_sock_rw_perms = \"0770\""
with="unix_sock_rw_perms = \"0770\""
sed -i "s|$sub|$with|g" /etc/libvirt/libvirtd.conf

qemu="/etc/libvirt/qemu.conf"
grep -q "user = \"ab55al\"" "$qemu" || echo "user = \"ab55al\"" >> "$qemu"
grep -q "group = \"ab55al\"" "$qemu" || echo "group = \"ab55al\"" >> "$qemu"

# libvirt
##########


##########
# looking glass

echo "f	/dev/shm/looking-glass	0660	ab55al	kvm	-" > /etc/tmpfiles.d/10-looking-glass.conf
systemd-tmpfiles --create /etc/tmpfiles.d/10-looking-glass.conf

# looking glass
##########
