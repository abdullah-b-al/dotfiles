#!/usr/bin/env bash
set -eu
set -o pipefail

dir=$(realpath "$(dirname "$0")")
cd "$dir"
export PATH="$PATH:$(pwd):/usr/sbin:$HOME/.local/bin"

if [ "$(whoami)" = "root" ]; then
    echo "Do not run as root"
    exit 1
fi

dirs-make.sh
audio.sh

[ $SHELL != "/bin/zsh" ] && chsh -s /bin/zsh "$USER"
[ -d $HOME/.dotfiles ] || git clone https://github.com/abdullah-b-al/dotfiles $HOME/.dotfiles

file-perms-and-links.sh

cd "$HOME/.dotfiles" && stow -S . -t "$HOME"
