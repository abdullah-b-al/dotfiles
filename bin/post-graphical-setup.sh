#!/bin/sh
dbus-update-activation-environment --all
set-keyboard-settings.sh
gammastep -PO 4800
pgrep sxhkd > /dev/null || sxhkd &
pgrep nextcloud > /dev/null || nextcloud --background &
brightnessctl s 20%
