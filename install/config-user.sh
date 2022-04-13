# Install dotfiles
su "$user_name"

if [ "$UID" != 0 ]; then

  # Create directories and files
  # XDG
  mkdir -p "$HOME"/.config "$HOME"/.local/share "$HOME"/.local/bin/ "$HOME"/.cache
  # dotfiles
  mkdir -p "$HOME"/.config/zsh
  mkdir -p "$HOME"/.config/nvim
  # git
  mkdir -p "$HOME"/.config/git
  touch "$HOME"/.config/git/config "$HOME"/.config/git/credentials

  if ! [ -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/ab55al/.dotfiles "$HOME"/.dotfiles && \
      cd "$HOME"/.dotfiles && \
      stow -S . -t "$HOME"
  fi

  # Install st
  if ! [ -d "$HOME"/.config/st ]; then
    git clone https://github.com/ab55al/st $HOME/.config/st && \
      cd "$HOME"/.config/st && \
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

  # Install nvim package manager
  [ -d "$HOME"/.local/share/nvim/site/pack/packer/start/packer.nvim ] || \
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim


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
