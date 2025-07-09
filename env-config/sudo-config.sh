#!/usr/bin/env bash
set -eu
set -o pipefail

file="/etc/sudoers"

line="ALL ALL=(ALL) NOPASSWD: "$(which ddcutil)""
if ! [ "$(grep "$line" "$file")" ]; then
    echo "$line" >> "$file"
fi

line="ALL ALL=(ALL) NOPASSWD: /usr/local/bin/kanata"
if ! [ "$(grep "$line" "$file")" ]; then
    echo "$line" >> "$file"
fi
