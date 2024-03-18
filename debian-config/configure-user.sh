#!/bin/sh
set -e

#########
# checks

path=$(readlink -f "$0")
dir=$(dirname "$path")
export user_password=""

[ "$(whoami)" = "root" ] && echo "Must not run as root" && exit 1
[ -z "$user_password" ] && echo "user password has not been provided" && exit 1

# checks
#########

# Create directories and files
# XDG
mkdir -p "$HOME"/.config "$HOME"/.local/share "$HOME"/.local/bin/ "$HOME"/.cache

# dotfiles
mkdir -p "$HOME"/.config/zsh
mkdir -p "$HOME"/.config/nvim
mkdir -p "$HOME"/personal

# git
mkdir -p "$HOME"/.config/git
touch "$HOME"/.config/git/config "$HOME"/.config/git/credentials
git config --global user.email "abdullah@abal.xyz"
git config --global user.name "ab55al"
git config --global credential.helper store

[ -d "$HOME/.dotfiles" ] || git clone --recursive https://gitlab.com/ab55al/dotfiles.git "$HOME"/.dotfiles
cd "$HOME"/.dotfiles && stow -S . -t "$HOME"

systemctl --user enable pulseaudio
systemctl --user start pulseaudio

# Change default shell
echo "$user_password" | chsh -s /bin/zsh
# remove bash files
rm -f "$HOME"/.bash*

"$dir"/download_fonts.sh

PATH="$PATH:$HOME/.local/bin"
command -v gf2                  || "$dir"/install.sh gf2
command -v nvim                 || "$dir"/install.sh neovim
command -v i3lock               || "$dir"/install.sh i3lock
command -v starship             || "$dir"/install.sh starship
command -v looking-glass-client || "$dir"/install.sh looking_glass

printf "User configured.\n"
