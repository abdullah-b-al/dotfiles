#!/usr/bin/env bash
set -eu
set -o pipefail


dir=$(realpath "$(dirname "$0")")
cd "$dir"
export PATH="$PATH:$(pwd):/usr/sbin"
export my_user="ab"

if [ "$(whoami)" != "root" ]; then
    echo "Must run as root"
    exit 1
fi

mount-drives.sh
install-packages.sh
services.sh
sudo.sh
