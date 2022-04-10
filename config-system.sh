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
printf "%s\n%s" "$root_password" "$root_password" | passwd

# Create user
useradd -m "$user_name"
printf "%s\n%s" "$user_password" "$user_password" | passwd "$user_name"
usermod -aG wheel,audio,video,optical,storage "$user_name"


# doas config lines must end with a new line
printf "permit :wheel\n" > /etc/doas.conf
printf "permit persist :wheel\n" >> /etc/doas.conf
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

# Config and install grub
mkdir -p /boot/EFI
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg
