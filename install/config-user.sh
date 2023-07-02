#!/bin/sh
# Install dotfiles
set -e

if [ "$UID" != 0 ]; then

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

  cd "$HOME"/.dotfiles/.config/dwm
  echo "$root_password" | sudo -S make install

  # Change default shell
  echo "$user_password" | chsh -s /bin/zsh
  # remove bash files
  rm "$HOME"/.bash*

  printf "User configured.\n"
  exit 0
else
  printf "Couldn't login to user $user_name\n"
  exit 1
fi
