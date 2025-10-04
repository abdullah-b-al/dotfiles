#!/usr/bin/env bash

export PATH="$PATH:$(pwd):/usr/sbin:$HOME/.local/bin"

_zed() {
    if ! command -v zed; then
        curl -f https://zed.dev/install.sh | sh
    fi
}

_kanata() {
    if ! command -v kanata; then
        cd /tmp
        wget --no-config https://github.com/jtroo/kanata/releases/download/v1.9.0/kanata
        chmod +x ./kanata
        sudo mv ./kanata /usr/local/bin/kanata
    fi
}

_nix() {
    version="nixos-25.05"
    if ! [ "$(nix-channel --list | grep "$version")" ]; then
        nix-channel --add https://nixos.org/channels/$version
        nix-channel --update
    fi

    nix-env -if software.nix
}

_zed
_kanata
_nix
