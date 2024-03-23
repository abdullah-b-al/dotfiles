#!/bin/sh
set -e

path=$(readlink -f "$0")
dir=$(dirname "$path")

PATH="$PATH:/usr/local/bin:$HOME/.local/bin"
is_root="$(whoami)"

if [ "$is_root" = "root" ]; then
  command -v nvim                 || "$dir"/install.sh neovim
  command -v starship             || "$dir"/install.sh starship

  [ -e /sys/class/power_supply/BAT0 ] && {
    command -v auto-cpufreq || "$dir"/install.sh auto_cpufreq
  };
else
  command -v gf2                  || "$dir"/install.sh gf2
  command -v i3lock               || "$dir"/install.sh i3lock
  command -v looking-glass-client || "$dir"/install.sh looking_glass
fi
