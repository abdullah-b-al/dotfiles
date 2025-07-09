#!/usr/bin/env bash
set -eu
set -o pipefail

printf "Nextcloud URL: "
read nextcloud_url
nextcloudcmd --path "/personal" "$HOME/personal/" "$nextcloud_url"
# Ensures I can add this directory to be synced in the GUI
rm -f "$HOME/personal/.sync_*.db"
