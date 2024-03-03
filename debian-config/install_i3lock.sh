#!/bin/sh
set -e

git clone https://github.com/Raymo111/i3lock-color.git /tmp/i3lock
cd /tmp/i3lock
./build.sh
mv ./build/i3lock $HOME/.local/bin

rm -rf /tmp/i3lock
