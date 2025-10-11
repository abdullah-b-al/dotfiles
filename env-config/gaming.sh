#!/usr/bin/env bash

# sudo usermod -aG gamemode ab

# scopebuddy_path="$HOME/.local/bin/scopebuddy"
# curl -Lo "$scopebuddy_path" https://raw.githubusercontent.com/HikariKnight/ScopeBuddy/refs/heads/main/bin/scopebuddy
# chmod +x "$scopebuddy_path"

file="/etc/apt/sources.list"
line="deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware"
if ! [ "$(grep "$line" "$file")" ]; then
    echo "$line" | sudo tee -a "$file"
fi

line="deb-src http://deb.debian.org/debian trixie main contrib non-free non-free-firmware"
if ! [ "$(grep "$line" "$file")" ]; then
    echo "$line" | sudo tee -a "$file"
fi

sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y steam mangohud
