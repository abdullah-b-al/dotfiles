#!/usr/bin/env bash

sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

sudo dnf install steam gamescope mangohud gamemode

sudo usermod -aG gamemode ab

scopebuddy_path="$HOME/.local/bin/scopebuddy"
curl -Lo "$scopebuddy_path" https://raw.githubusercontent.com/HikariKnight/ScopeBuddy/refs/heads/main/bin/scopebuddy
chmod +x "$scopebuddy_path"

# gpu_conf_file="20-amdgpu.conf"
# gpu_conf_file_dir="/etc/X11/xorg.conf.d"
# if ! [ -e "$gpu_conf_file_dir/$gpu_conf_file" ]; then
#     sudo cp "./$gpu_conf_file" "$gpu_conf_file_dir"
# fi
