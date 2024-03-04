#!/bin/bash
set -e

##########
# checks

user_name=""

[ -z "$user_name" ] && echo "user name has not been provided" && exit 1

# checks
##########

apt update
apt -y install nala
sed -i "s|bookworm main non-free-firmware|bookworm main non-free non-free-firmware|g" /etc/apt/sources.list
./nala_install_packages

grep "^ar_SA.UTF-8 UTF-8" /etc/locale.gen || printf 'ar_SA.UTF-8 UTF-8' >> /etc/locale.gen
/usr/sbin/locale-gen

enable_user_sudo=$(printf "%s ALL=(ALL:ALL) ALL" $user_name)
# sed: insert after pattern
grep "$enable_user_sudo" /etc/sudoers || sed -i "/root\s*ALL/a $enable_user_sudo" /etc/sudoers

# setup groups
/usr/sbin/usermod -aG libvirt,libvirt-qemu,kvm,input,disk $user_name

# setup services
systemctl enable cron
systemctl enable libvirtd.service
systemctl enable NetworkManager

# setup virsh
virsh net-start default || true
virsh net-autostart default

hdd_uuid="44f16107-3ca4-4739-b2a3-b4dab98d8cc3"
if [[ $(file /dev/disk/by-uuid/$hdd_uuid) ]]; then
  printf "\nUUID=%s /mnt/linuxHDD ext4      	rw,relatime	0 2\n" $hdd_uuid >> /etc/fstab
  mount -m "/dev/disk/by-uuid/$hdd_uuid" /mnt/linuxHDD
fi

echo "system configuration done"
