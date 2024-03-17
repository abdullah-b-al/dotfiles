#!/bin/sh
set -e
###########
# functions

get_password() {
  [ -z "$user_password" ] && echo "Enter Password:" && read user_password
}

brave() {
  get_password

  echo $user_password | sudo -S curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  channel="deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"
  echo $channel > /tmp/brave-browser-release.list
  echo $user_password | sudo -S cp /tmp/brave-browser-release.list /etc/apt/sources.list.d/brave-browser-release.list

  sudo nala update
  sudo nala install --assume-yes brave-browser
}

neovim() {
  get_password

  touch $HOME/.config/wgetrc
  wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
  chmod +x /tmp/nvim.appimage
  echo $user_password | sudo -S mv /tmp/nvim.appimage /usr/bin/nvim
}

i3lock() {
  git clone https://github.com/Raymo111/i3lock-color.git /tmp/i3lock
  cd /tmp/i3lock
  ./build.sh
  mv ./build/i3lock $HOME/.local/bin

  rm -rf /tmp/i3lock
}

libvirt() {
  get_password

  echo $user_password | sudo -S apt build-dep --assume-yes libvirt

  cd /tmp

  libvirt="libvirt-10.1.0"
  tar_libvirt="/tmp/$libvirt.tar.xz"
  touch $HOME/.config/wgetrc
  [ -f $tar_libvirt ] || wget -O $tar_libvirt https://download.libvirt.org/$libvirt.tar.xz
  [ -d $libvirt ] || xz -dc $tar_libvirt | tar xvf -

  cd $libvirt
  meson setup --reconfigure build -Dsystem=true -Ddocs=disabled -Dprefix=/usr/local -Dtests=disabled
  ninja -C build
  echo $user_password | sudo -S ninja -C build install
  echo $user_password | sudo -S ldconfig
}

starship() {
  get_password

  curl -sS https://starship.rs/install.sh > /tmp/starship.sh
  chmod +x /tmp/starship.sh
  echo $user_password | sudo /tmp/starship.sh --yes
}

gf2() {
  git clone https://github.com/nakst/gf.git /tmp/gf2
  cd /tmp/gf2
  ./build.sh
  mv gf2 $HOME/.local/bin
}

looking_glass() {
  cd /tmp

  [ -f /tmp/looking-glass-B6.tar.gz ] || wget -O /tmp/looking-glass-B6.tar.gz "https://looking-glass.io/artifact/B6/source"
  [ -d /tmp/looking-glass-B6 ] || tar xf /tmp/looking-glass-B6.tar.gz

  mkdir -p looking-glass-B6/client/build
  cd looking-glass-B6/client/build
  cmake -DENABLE_WAYLAND=no -DCMAKE_INSTALL_PREFIX=~/.local ..
  make install
}

# functions
###########

functions="$(grep "^.*\(\) {" "$0" | cut -d '(' -f 1 | grep -v "password\|grep\|functions")"
if [ "$1" = "list" ] || [ -z "$1" ] || ! echo "$functions" | grep -q "$1"; then
  echo "$functions"
  exit 1
fi

# run the function who's name is the first arg
$1
