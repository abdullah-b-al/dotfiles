#!/usr/bin/env bash
set -eu
set -o pipefail

systemctl enable crond
systemctl enable NetworkManager
systemctl --user enable pipewire

systemctl disable sshd
