#!/usr/bin/env bash
set -eu
set -o pipefail

target="/etc/dnf/dnf.conf"
src="./dnf.conf"

cat "$src" > "$target"

echo "$(basename "$0"): done"
