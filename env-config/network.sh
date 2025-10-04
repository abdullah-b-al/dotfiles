#!/usr/bin/env bash

rm -f /etc/network/interfaces
systemctl enable NetworkManager
systemctl start NetworkManager
