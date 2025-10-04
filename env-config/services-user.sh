#!/usr/bin/env bash
set -eu
set -o pipefail

systemctl --user enable pipewire
systemctl --user enable pipewire-pulse
