#!/usr/bin/env bash

export PATH="$PATH:$(pwd):/usr/sbin:$HOME/.local/bin"

if ! command -v nix; then
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes
fi

nix-channel --add https://nixos.org/channels/nixos-25.05
nix-channel --update
