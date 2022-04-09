#!/bin/sh
ln -sf /usr/share/zoneinfo/Asia/Riyadh /etc/localtime

hwclock --systohc

# locales
sed -i 's|#ar_SA.UTF-8 UTF-8|ar_SA.UTF-8 UTF-8|1' /etc/locale.gen
sed -i 's|#en_US.UTF-8 UTF-8|en_US.UTF-8 UTF-8|1' /etc/locale.gen
locale-gen

printf "LANG=en_US.UTF-8" > /etc/locale.conf
printf "KEYMAP=us" > /etc/vconsole.conf
printf "desktop-arch" > /etc/hostname

mkinitcpio -P

# Set root passwd
cat /install_tmp/root_password | passwd

# doas config lines must end with a new line
printf "permit :wheel\n" > /etc/doas.conf
printf "permit persist :wheel\n" >> /etc/doas.conf
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

# Config grub
