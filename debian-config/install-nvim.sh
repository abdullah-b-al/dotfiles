#!/bin/sh

[ "$1" != "force" ] && command -v nvim && echo Already installed && exit 0

wget --no-config -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
chmod +x /tmp/nvim.appimage
sudo mv /tmp/nvim.appimage /usr/local/bin/nvim
