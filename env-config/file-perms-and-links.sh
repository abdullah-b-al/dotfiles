#!/usr/bin/env bash
set -eu
set -o pipefail

personal="$HOME/personal"
dotfiles="$personal/.dotfiles"

chmod +x "$personal"/bin/*
chmod +x "$dotfiles"/bin/*

if ! [ -L "$dotfiles/.zprofile" ]; then
    ln -rs "$dotfiles/.config/shell/profile" "$dotfiles/.zprofile"
fi
