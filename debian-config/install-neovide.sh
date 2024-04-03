#!/bin/sh

[ "$1" != "force" ] && command -v neovide && echo Already installed && exit 0

location="$HOME/.local/bin/neovide"
wget --no-config -O "$location" https://github.com/neovide/neovide/releases/download/0.12.2/neovide.AppImage
chmod +x "$location"
