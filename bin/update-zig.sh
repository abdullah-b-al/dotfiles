#!/bin/sh

set -e

update_zls() {
    rm -rf "/tmp/installing-zls"

    mkdir "/tmp/installing-zls"
    cd "/tmp/installing-zls"

    git clone --depth 1 https://github.com/zigtools/zls.git
    cd "/tmp/installing-zls/zls"

    zig build -Doptimize=ReleaseSafe
    [ -f "/tmp/installing-zls/zls/zig-out/bin/zls" ] || exit 1

    pkill zls || true
    cp /tmp/installing-zls/zls/zig-out/bin/zls ~/.local/bin
}

if ! command -v zigup > /dev/null; then
  mkdir -p /tmp/zigup
  cd /tmp/zigup

  wget --no-config -O zigup.zip https://github.com/marler8997/zigup/releases/download/v2024_03_13/zigup.ubuntu-latest-x86_64.zip
  unzip zigup.zip
  chmod +x zigup
  mv zigup "$HOME"/.local/bin

  rm -rf /tmp/zigup
fi

if [ "$1" = "zls" ]; then
    update_zls
else
    zigup master 2>&1 | grep already && exit 0
    update_zls
fi
