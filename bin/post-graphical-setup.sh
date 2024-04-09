#!/usr/bin/env bash
set-keyboar-settings.sh
gammastep -PO 5000
pgrep sxhkd > /dev/null || sxhkd & disown
pgrep nextcloud > /dev/null || nextcloud & disown
