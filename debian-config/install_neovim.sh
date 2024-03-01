#!/bin/sh
touch $HOME/.config/wgetrc
wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
mv nvim.appimage $HOME/.local/bin/nvim
chmod +x $HOME/.local/bin/nvim
