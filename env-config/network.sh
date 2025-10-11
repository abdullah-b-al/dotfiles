#!/usr/bin/env bash

apt remove ifupdown
rm -f /etc/network/interfaces

systemctl enable NetworkManager --now
