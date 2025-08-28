#!/usr/bin/env bash


if ! command -v zed; then
    curl -f https://zed.dev/install.sh | sh
fi

if ! command -v kanata; then
    cd /tmp
    wget --no-config https://github.com/jtroo/kanata/releases/download/v1.9.0/kanata
    chmod +x ./kanata
    sudo mv ./kanata /usr/local/bin/kanata
fi
