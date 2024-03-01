#!/bin/sh
set -e

#########
# checks

user_password=""

if [ "$UID" == 0 ]; then
  printf "Must not run as root"
  exit 1
fi

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

if ! [ -d "$HOME/.dotfiles" ]; then
  git clone --recursive https://gitlab.com/ab55al/dotfiles.git "$HOME"/.dotfiles && \
    cd "$HOME"/.dotfiles && \
    stow -S . -t "$HOME"
fi

# Change default shell
echo "$user_password" | chsh -s /bin/zsh
# remove bash files
rm -f "$HOME"/.bash*

[ -f "$HOME/.local/bin/nvim" ] || ./install_neovim.sh &
[ -f "$HOME/.local/bin/gf2" ] || ./install_gf2.sh &
command -v starship || echo $user_password | sudo -S ./install_starship.sh &
./install_looking_glass.sh &
echo $user_password | sudo -S ./install_brave.sh

wait


printf "User configured.\n"
