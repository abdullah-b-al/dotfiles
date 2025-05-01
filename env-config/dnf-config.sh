#!/usr/bin/env bash
set -eu
set -o pipefail

file="/etc/dnf/dnf.conf"
line="max_parallel_downloads=10" 

if ! [ "$(grep "$line" "$file")" ]; then
    echo "$line" >> "$file"
fi

echo "$(basename $0): done"
