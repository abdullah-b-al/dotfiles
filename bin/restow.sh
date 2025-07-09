#!/bin/sh

mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.cache"
mkdir -p "$HOME/personal"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/zsh"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/git"
mkdir -p "$HOME/.config/xournalpp"

[ -z "$DOTFILES" ] && DOTFILES="$HOME/.dotfiles"

cd "$DOTFILES" || exit 1
stow -S . -t "$HOME"

if ! [ -L "$DOTFILES/.zprofile" ]; then
    ln -rs "$DOTFILES/.config/shell/profile" "$DOTFILES/.zprofile"
fi
