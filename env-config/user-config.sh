#!/usr/bin/env bash
set -eu
set -o pipefail

dir=$(realpath "$(dirname "$0")")
cd "$dir"
export PATH="$PATH:$(pwd)"

if [ "$(whoami)" = "root" ]; then
    echo "Do not run as root"
    exit 1
fi

dirs-setup.sh
chsh -s /bin/zsh "$USER"
user-services-config.sh
files-sync.sh
file-perms-and-links.sh

cd "$HOME/.dotfiles" && stow -S . -t "$HOME"
