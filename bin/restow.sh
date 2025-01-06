#!/bin/sh

$HOME/.local/share
$HOME/.local/bin
$HOME/.cache
$HOME/personal
$HOME/.config
$HOME/.config/zsh
$HOME/.config/nvim
$HOME/.config/git

[ -z $DOTFILES ] && DOTFILES="$HOME/personal/.dotfiles"

cd "$DOTFILES"

# nextcloud doesn't sync symlinks so this ensures that on every new install
# the links will exist
ln -s ".config/shell/profile" ".zprofile" 

cd "$DOTFILES"
stow -S . -t "$HOME"
