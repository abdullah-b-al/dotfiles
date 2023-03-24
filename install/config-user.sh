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
  mkdir -p "$HOME"/.config/suckless

  mkdir -p "$HOME"/personal

  # git
  mkdir -p "$HOME"/.config/git
  touch "$HOME"/.config/git/config "$HOME"/.config/git/credentials
  git config --global user.email "abdullah5590x@gmail.com"
  git config --global user.name "ab55al"
  git config --global credential.helper store

  if ! [ -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/ab55al/.dotfiles "$HOME"/.dotfiles && \
      cd "$HOME"/.dotfiles && \
      stow -S . -t "$HOME"
  fi

  # Install st
  st_dir="$HOME"/.config/suckless/st
  if ! [ -d "$st_dir" ]; then
    git clone https://github.com/ab55al/st "$st_dir" && \
      cd "$st_dir" && \
      echo "$root_password" | sudo -S make install && \
      make clean
  fi

  # Install dwm
  dwm_dir="$HOME"/.config/suckless/dwm
  if ! [ -d "$dwm_dir" ]; then
    git clone https://github.com/ab55al/dwm "$dwm_dir" && \
      cd "$dwm_dir" && \
      echo "$root_password" | sudo -S make install && \
      make clean
  fi

  # Install AUR helper
  if ! [ -d "$HOME"/paru ]; then
    git clone https://aur.archlinux.org/paru.git $HOME/paru && \
      cd $HOME/paru && \
      makepkg -s && \
      echo "$root_password" | sudo -S pacman --noconfirm -U paru*.pkg.tar.zst && \
      rm -rf "$HOME/paru"
  fi

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
