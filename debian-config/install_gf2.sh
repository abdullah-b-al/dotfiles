#!/bin/sh
git clone https://github.com/nakst/gf.git /tmp/gf2
cd /tmp/gf2
./build.sh
mv gf2 $HOME/.local/bin
