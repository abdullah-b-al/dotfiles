#!/bin/sh
st_master="$(git ls-remote git://git.suckless.org/st | grep "HEAD" | cut -f1)"
dwm_master="$(git ls-remote git://git.suckless.org/dwm | grep "HEAD" | cut -f1)"

st_dir="$HOME/.config/suckless/st"
dwm_dir="$HOME/.config/suckless/dwm/"

if [ -d "$st_dir" ]; then
  cd "$st_dir"
  if ! git log -20 | grep "$st_master">/dev/null; then
    printf "ST"
  fi
fi

if [ -d "$dwm_dir" ]; then
  cd "$dwm_dir"
  if ! git log -20 | grep "$dwm_master">/dev/null; then
    printf " DWM"
  fi
fi

printf "\n"
