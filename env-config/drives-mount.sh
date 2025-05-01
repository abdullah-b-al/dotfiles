#!/usr/bin/env bash

set -eu
set -o pipefail


mount_dir="/mnt/linuxHDD"
path="/dev/disk/by-uuid/44f16107-3ca4-4739-b2a3-b4dab98d8cc3"
line="$path $mount_dir ext4 rw,relatime 0 0"
file="/etc/fstab"

make -p "$mount_dir"

if [ -e "$path" ]; then
    if ! [ "$(grep -F "$line" "$file")" ]; then
        echo "$line" >> "$file"
    else
        echo "Hard drive already mounted"
    fi
fi
