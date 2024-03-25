#!/bin/sh

[ "$1" != "force" ] && command -v looking-glass-client && echo Already installed && exit 0

cd /tmp

[ -f /tmp/looking-glass-B6.tar.gz ] || wget --no-config -O /tmp/looking-glass-B6.tar.gz "https://looking-glass.io/artifact/B6/source"
[ -d /tmp/looking-glass-B6 ] || tar xf /tmp/looking-glass-B6.tar.gz

mkdir -p looking-glass-B6/client/build
cd looking-glass-B6/client/build
cmake -DENABLE_WAYLAND=no -DCMAKE_INSTALL_PREFIX=~/.local ..
make install
