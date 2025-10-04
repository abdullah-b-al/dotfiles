#!/usr/bin/env bash
set -eu
set -o pipefail

[ -z "$my_user" ] && "user not provide" && exit 1

file="/etc/sudoers"
nix_bin="/home/$my_user/.nix-profile/bin"

line="ALL ALL=(ALL) NOPASSWD: "$(which ddcutil)""
if ! [ "$(grep "$line" "$file")" ]; then
    echo "$line" >> "$file"
fi

line="ALL ALL=(ALL) NOPASSWD: $nix_bin/kanata"
if ! [ "$(grep "$line" "$file")" ]; then
    echo "$line" >> "$file"
fi

if ! [ "$(grep "secure_path.*$nix_bin" "$file")" ]; then
    search='(.*\ssecure_path=".*)"'
    replace="\1:$nix_bin\""
    sed -i -E "s|$search|$replace|" "$file"
fi

usermod -aG sudo "$my_user"
