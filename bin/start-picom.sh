#!/bin/sh
while true; do
  [[ -d ~/.cache/picom ]] || mkdir -p ~/.cache/picom
  picom --experimental-backends > ~/.cache/picom/picom.log
done
