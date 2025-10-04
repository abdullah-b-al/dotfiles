#!/usr/bin/env bash
set -eu
set -o pipefail

dotfiles="$HOME/.dotfiles"

chmod +x "$dotfiles"/bin/*

if ! [ -L "$dotfiles/.zprofile" ]; then
    ln -rs "$dotfiles/.config/shell/profile" "$dotfiles/.zprofile"
fi
