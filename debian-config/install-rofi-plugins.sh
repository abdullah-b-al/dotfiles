#!/bin/sh

rofi_plugin_path="$HOME/.local/lib/rofi-plugins"

[ "$1" != "force" ] && [ -e $rofi_plugin_path/calc.so ] && echo Already installed && exit 0

mkdir -p $rofi_plugin_path

git clone https://github.com/svenstaro/rofi-calc.git /tmp/rofi-calc
cd /tmp/rofi-calc
mkdir -p m4
autoreconf -i
mkdir -p build
cd build/
../configure
make
cp .libs/calc.so $rofi_plugin_path
