#!/bin/sh
set -e
###########
# functions

neovim() {
  wget --no-config -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
  chmod +x /tmp/nvim.appimage
  sudo mv /tmp/nvim.appimage /usr/local/bin/nvim
}

i3lock() {
  git clone https://github.com/Raymo111/i3lock-color.git /tmp/i3lock
  cd /tmp/i3lock
  ./build.sh
  mv ./build/i3lock $HOME/.local/bin

  rm -rf /tmp/i3lock
}

starship() {
  curl -sS https://starship.rs/install.sh > /tmp/starship.sh
  chmod +x /tmp/starship.sh
  sudo /tmp/starship.sh --yes
}

gf2() {
  git clone https://github.com/nakst/gf.git /tmp/gf2
  cd /tmp/gf2
  ./build.sh
  mv gf2 $HOME/.local/bin
}

looking_glass() {
  cd /tmp

  [ -f /tmp/looking-glass-B6.tar.gz ] || wget --no-config -O /tmp/looking-glass-B6.tar.gz "https://looking-glass.io/artifact/B6/source"
  [ -d /tmp/looking-glass-B6 ] || tar xf /tmp/looking-glass-B6.tar.gz

  mkdir -p looking-glass-B6/client/build
  cd looking-glass-B6/client/build
  cmake -DENABLE_WAYLAND=no -DCMAKE_INSTALL_PREFIX=~/.local ..
  make install
}

auto_cpufreq() {
  git clone https://github.com/AdnanHodzic/auto-cpufreq.git /tmp/auto-cpufreq
  cd /tmp/auto-cpufreq
  sudo ./auto-cpufreq-installer --install
  sudo auto-cpufreq --install
  [ -e /sys/class/power_supply/BAT0 ] || sudo auto-cpufreq --force=powersave

  rm -rf /tmp/auto-cpufreq
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
