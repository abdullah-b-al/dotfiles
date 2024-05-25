#!/bin/sh

sudo-validate.sh || exit 1

sudo systemctl stop NetworkManager
sudo pkill wpa_supplicant
sudo systemctl start NetworkManager
