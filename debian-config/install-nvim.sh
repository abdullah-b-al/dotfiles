#!/bin/sh

[ "$1" != "force" ] && command -v nvim && echo Already installed && exit 0

wget --no-config -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v0.10.2/nvim.appimage
sudo install --mode +x /tmp/nvim.appimage -t /usr/local/bin/nvim
