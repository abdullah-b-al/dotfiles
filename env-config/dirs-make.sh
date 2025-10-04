#!/usr/bin/env bash
set -eu
set -o pipefail

mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.cache"
mkdir -p "$HOME/personal"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/zsh"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/git"
mkdir -p "$HOME/.config/xournalpp"

touch "$HOME/.config/wgetrc"
touch "$HOME/.config/git/config"
touch "$HOME/.config/git/credentials"
