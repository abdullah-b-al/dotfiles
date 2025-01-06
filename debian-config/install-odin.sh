#!/bin/sh

[ "$1" != "force" ] && command -v odin && echo Already installed && exit 0

dir="/tmp/odin"
tar="$dir/odin.tar.gz"
install_dir="$HOME/.local/bin"

mkdir -p "$dir/odin"
cd "$dir"
wget --no-config -O "$tar" 'https://github.com/odin-lang/Odin/releases/download/dev-2024-12/odin-linux-amd64-dev-2024-12.tar.gz'
tar xf "$tar" -C odin --strip-components=1
cp -r "odin" -t "$install_dir"
