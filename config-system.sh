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
if ! grep -i "$user_name" /etc/passwd >/dev/null; then
  printf "Creating user %s\n" "$user_name"
  useradd -m "$user_name"
  printf "%s\n%s" "$user_password" "$user_password" | passwd "$user_name"
  usermod -aG wheel,audio,video,optical,storage "$user_name"
fi


# doas config lines must end with a new line
printf "permit :wheel\n" > /etc/doas.conf
printf "permit persist :wheel\n" >> /etc/doas.conf
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

# sudo
sed -i "s|# %wheel ALL=(ALL) ALL|%wheel ALL=(ALL) ALL|g" /etc/sudoers
sed -i "s|# %wheel ALL=(ALL:ALL) ALL|%wheel ALL=(ALL) ALL|g" /etc/sudoers

# Set up network
systemctl enable NetworkManager

# Config and install grub
mkdir -p /boot/EFI

if ! [ -f /boot/grub/grub.cfg ]; then
  grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
  grub-mkconfig -o /boot/grub/grub.cfg
fi


# Install dotfiles
export user_home="/home/$user_name"
su "$user_name" -c '[ -d "$user_home/.dotfiles" ] || git clone https://github.com/ab55al/.dotfiles $user_home/.dotfiles'

# Create directories
# XDG
su "$user_name" -c 'mkdir -p "$user_home"/.config "$user_home"/.local/share "$user_home"/.local/bin/ "$user_home"/.cache'
# dotfiles
su "$user_name" -c 'mkdir -p "$user_home"/.config/zsh'

su "$user_name" -c 'cd "$user_home"/.dotfiles && stow -S . -t "$user_home"'

# Install st
su "$user_name" -c '[ -d "$user_home"/.config/st ] || git clone https://github.com/ab55al/st $user_home/.config/st'

su "$user_name" -c 'cd "$user_home"/.config/st && echo "$root_password" | sudo -S make install && make clean'

# Install AUR helper
su "$user_name" -c '[ -d "$user_home"/paru ] || git clone https://aur.archlinux.org/paru.git $user_home/paru'
su "$user_name" -c 'cd $user_home/paru && makepkg -s'
su "$user_name" -c 'cd $user_home/paru && echo $root_password | sudo -S pacman --noconfirm -U paru*.pkg.tar.zst'
su "$user_name" -c 'echo "$root_password" | sudo -S echo && paru --noconfirm -S - < "$user_home/.dotfiles/aur-packages.txt"'


# Change default shell
su "$user_name" -c 'echo "$user_password" | chsh -s /bin/zsh'
# remove bash files
su "$user_name" -c 'rm $user_home/.bash*'
