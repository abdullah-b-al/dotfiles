#!/bin/sh

[ "$1" != "force" ] && command -v fd && echo Already installed && exit 0

wget --no-config -O /tmp/fd.deb https://github.com/sharkdp/fd/releases/download/v10.2.0/fd_10.2.0_amd64.deb
sudo apt install /tmp/fd.deb
