#!/bin/sh
set -e

mount -o remount,size=10G /run/archiso/cowspace
pacman -Sy --noconfirm git
./live-install.sh
