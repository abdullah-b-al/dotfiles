#!/bin/sh

[ -f /tmp/looking-glass-B6.tar.gz ] || wget -O /tmp/looking-glass-B6.tar.gz "https://looking-glass.io/artifact/B6/source"

cd /tmp
tar xf looking-glass-B6.tar.gz

mkdir -p looking-glass-B6/client/build
cd looking-glass-B6/client/build
cmake -DENABLE_WAYLAND=no -DCMAKE_INSTALL_PREFIX=~/.local ..
make install
