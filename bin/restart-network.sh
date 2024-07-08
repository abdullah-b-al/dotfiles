#!/usr/bin/env bash

sudo -A --validate
sudo systemctl stop NetworkManager
sudo killall wpa_supplicant
sudo systemctl start NetworkManager

sleep 5
nextcloud --quit && nextcloud --background & disown
