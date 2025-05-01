#!/usr/bin/env bash
set -eu
set -o pipefail


dir=$(realpath "$(dirname "$0")")
cd "$dir"
export PATH="$PATH:$(pwd)"

if [ "$(whoami)" != "root" ]; then
    echo "Must run as root"
    exit 1
fi

drives-mount.sh
dnf-config.sh
packages-install.sh
services-config.sh
