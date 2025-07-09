#!/usr/bin/env bash

dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf config-manager setopt fedora-cisco-openh264.enabled=1

dnf install steam gamescope mangohud gamemode

usermod -aG gamemode ab

# gpu_conf_file="20-amdgpu.conf"
# gpu_conf_file_dir="/etc/X11/xorg.conf.d"
# if ! [ -e "$gpu_conf_file_dir/$gpu_conf_file" ]; then
#     sudo cp "./$gpu_conf_file" "$gpu_conf_file_dir"
# fi
