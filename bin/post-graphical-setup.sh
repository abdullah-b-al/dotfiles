#!/usr/bin/env bash
dbus-update-activation-environment --all
set-keyboar-settings.sh
gammastep -PO 4800
pgrep sxhkd > /dev/null || sxhkd & disown
pgrep nextcloud > /dev/null || nextcloud --background & disown
