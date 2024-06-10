#!/bin/sh

[ "$1" != "force" ] && command -v fzf && echo Already installed && exit 0

wget --no-config -O /tmp/fzf.tar.gz https://github.com/junegunn/fzf/releases/download/0.53.0/fzf-0.53.0-linux_amd64.tar.gz
cd /tmp
tar xf /tmp/fzf.tar.gz
sudo mv /tmp/fzf /usr/local/bin/fzf
