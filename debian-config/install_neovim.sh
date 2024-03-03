#!/bin/sh

[ -z "$user_password" ] && echo "Enter Password:" && read user_password

touch $HOME/.config/wgetrc
wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
chmod +x /tmp/nvim.appimage
echo $user_password | sudo -S mv /tmp/nvim.appimage /usr/bin/nvim
