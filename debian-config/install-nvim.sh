#!/bin/sh

[ "$1" != "force" ] && command -v nvim && echo Already installed && exit 0

wget --no-config -O /tmp/nvim https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.appimage
sudo install --mode +rx /tmp/nvim -t /usr/local/bin
