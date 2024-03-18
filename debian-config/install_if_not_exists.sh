#!/bin/sh
set -e

path=$(readlink -f "$0")
dir=$(dirname "$path")

PATH="$PATH:$HOME/.local/bin"
command -v gf2                  || "$dir"/install.sh gf2
command -v nvim                 || "$dir"/install.sh neovim
command -v i3lock               || "$dir"/install.sh i3lock
command -v starship             || "$dir"/install.sh starship
command -v looking-glass-client || "$dir"/install.sh looking_glass
