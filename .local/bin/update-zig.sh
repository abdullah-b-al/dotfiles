#!/bin/sh
set -e

zigup master

rm -rf "/tmp/installing-zls"

mkdir "/tmp/installing-zls"
cd "/tmp/installing-zls"

git clone https://github.com/zigtools/zls.git
cd "/tmp/installing-zls/zls"

zig build
[ -f "/tmp/installing-zls/zls/zig-out/bin/zls" ] || exit 1

killall zls
cp /tmp/installing-zls/zls/zig-out/bin/zls ~/.local/bin
