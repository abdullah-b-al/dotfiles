#!/usr/bin/env bash

export PATH="$PATH:$(pwd):/usr/sbin:$HOME/.local/bin"

_zed() {
    if ! command -v zed; then
        curl -f https://zed.dev/install.sh | sh
    fi
}

_zed
