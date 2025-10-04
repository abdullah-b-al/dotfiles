#!/usr/bin/env bash

export PATH="$PATH:$(pwd):/usr/sbin:$HOME/.local/bin"

if ! command -v nix; then
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes
    exit 0
fi


version="nixos-25.05"
if ! [ "$(nix-channel --list | grep $version )" ]; then
    nix-channel --add https://nixos.org/channels/$version
    nix-channel --update
fi

nix-env -if software.nix
