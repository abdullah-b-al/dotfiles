#!/bin/sh

[ "$1" != "force" ] && command -v starship && echo Already installed && exit 0

curl -sS https://starship.rs/install.sh > /tmp/starship.sh
chmod +x /tmp/starship.sh
sudo /tmp/starship.sh --yes
