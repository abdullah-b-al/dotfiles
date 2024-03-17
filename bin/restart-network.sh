#!/bin/sh
sudo systemctl stop NetworkManager
sudo pkill wpa_supplicant
sudo systemctl start NetworkManager
