#!/bin/sh

[ "$1" != "force" ] && command -v ols && echo Already installed && exit 0

dir="/tmp/ols"
install_dir="$HOME/.local/bin"

git clone --depth=1 https://github.com/DanielGavin/ols.git "$dir"

cd "$dir" || exit 1

./build.sh
./odinfmt.sh

install --mode +x "$dir/ols" -t "$install_dir"
install --mode +x "$dir/odinfmt" -t "$install_dir"
