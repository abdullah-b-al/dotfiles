#!/usr/bin/env bash
set -eu
set -o pipefail

mkdir "$HOME/.dotfiles/"
printf "Nextcloud URL: https://"
read nextcloud_url
nextcloudcmd --path "/dotfiles" "$HOME/.dotfiles/" "https://$nextcloud_url"
# Ensures I can add this directory to be synced in the GUI
rm -f "$HOME/.dotfiles/.sync_*.db"
