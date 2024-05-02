#!/bin/sh

[ "$1" != "force" ] && command -v looking-glass-client && echo Already installed && exit 0

cd /tmp

[ -f /tmp/looking-glass-B7-rc1.tar.gz ] || wget --no-config -O /tmp/looking-glass-B7-rc1.tar.gz "https://looking-glass.io/artifact/B7-rc1/source"
[ -d /tmp/looking-glass-B7-rc1 ] || tar xf /tmp/looking-glass-B7-rc1.tar.gz

mkdir -p looking-glass-B7-rc1/client/build
cd looking-glass-B7-rc1/client/build
cmake -DENABLE_WAYLAND=no -DCMAKE_INSTALL_PREFIX=~/.local ..
make install
