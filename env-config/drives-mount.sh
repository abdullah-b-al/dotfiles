#!/usr/bin/env bash

set -eu
set -o pipefail

fstab="/etc/fstab"


# HDD
mount_dir="/mnt/linuxHDD"
uuid="44f16107-3ca4-4739-b2a3-b4dab98d8cc3"
path="/dev/disk/by-uuid/$uuid"
line="UUID=$uuid $mount_dir ext4 defaults,noatime 0 2"

mkdir -p "$mount_dir"

if [ -e "$path" ]; then
    if ! [ "$(grep -F "$line" "$fstab")" ]; then
        echo "$line" >> "$fstab"
    else
        echo "Hard drive already mounted"
    fi
fi

# NVME
mount_dir="/mnt/secondery_nvme"
uuid="97c6897a-e83f-4d09-b0cb-5c957229baa1"
path="/dev/disk/by-uuid/$uuid"
line="UUID=$uuid $mount_dir ext4 defaults,noatime 0 2"

mkdir -p "$mount_dir"

if [ -e "$path" ]; then
    if ! [ "$(grep -F "$line" "$fstab")" ]; then
        echo "$line" >> "$fstab"
    else
        echo "Nvme drive already mounted"
    fi
fi
