#!/bin/sh

sudo --validate || zenity --password | sudo -S --validate

sudo systemctl stop NetworkManager
sudo pkill wpa_supplicant
sudo systemctl start NetworkManager
