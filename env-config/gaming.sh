#!/usr/bin/env bash

# sudo dnf install -y \
#     https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
#     https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

# sudo dnf install steam gamescope mangohud gamemode

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
sudo apt install steam
