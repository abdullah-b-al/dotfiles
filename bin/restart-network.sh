#!/bin/sh

sudo -A --validate
sudo systemctl stop NetworkManager
sudo killall wpa_supplicant
sudo systemctl start NetworkManager

while ! ping -c 1 google.com 2>&1 > /dev/null; do
    sleep 1
done

nextcloud --quit && nextcloud --background &
notify-send "Netowork restarted successfully"
