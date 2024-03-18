#!/bin/sh
set -e

PATH="$PATH:$HOME/.local/bin"
command -v gf2                  || ./install.sh gf2
command -v nvim                 || ./install.sh neovim
command -v i3lock               || ./install.sh i3lock
command -v starship             || ./install.sh starship
command -v looking-glass-client || ./install.sh looking_glass
