#!/usr/bin/env bash

declare -A app_ids
declare -A commands

app_ids[shell]="Alacritty"
app_ids[build]="Alacritty"
app_ids[editor]="dev.zed.Zed"
app_ids[docs]=".*firefox.*"
app_ids[browser]="brave-browser"
app_ids[dev_browser]="chromium.*"

commands[shell]="alacritty"
commands[build]="alacritty"
commands[editor]="zed"
commands[docs]="firefox"
commands[browser]="brave-browser"
commands[dev_browser]="chromium"

app_id="${app_ids[$1]}"
cmd="${commands[$1]}"

if [ -z "$app_id" ]; then
    echo "Unknown window"
    exit 1
elif [ -z "$cmd" ]; then
    echo "Unknown command"
    exit 1
fi



client="$(swaymsg --raw -t get_tree | jq -r '.. | .app_id? // empty' | grep "$app_id")"
if [ -n "$client" ]; then
    swaymsg "[app_id=$app_id] focus"
else
    $cmd
fi
