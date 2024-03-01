#!/bin/sh
touch $HOME/.config/wgetrc
wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
mv /tmp/nvim.appimage $HOME/.local/bin/nvim
chmod +x $HOME/.local/bin/nvim
