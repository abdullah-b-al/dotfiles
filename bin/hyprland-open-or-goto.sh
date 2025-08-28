#!/usr/bin/env bash

declare -A classes
declare -A commands

classes[shell]="Alacritty"
classes[editor]="dev.zed.Zed"
classes[build]="Alacritty"
classes[docs]="org.mozilla.firefox"
classes[browser]="brave-browser"
classes[dev_browser]="Chromium-browser"

commands[shell]="alacritty"
commands[editor]="zed"
commands[build]="alacritty"
commands[docs]="open-docs.sh"
commands[browser]="brave-browser"
commands[dev_browser]="chromium-browser"

class="${classes[$1]}"
cmd="${commands[$1]}"

if [ -z "$class" ]; then
    echo "Unknown window"
    exit 1
elif [ -z "$cmd" ]; then
    echo "Unknown command"
    exit 1
fi

client="$(hyprctl -j clients | jq -r ".[] | select(.class | test(\"$class\"; \"i\"))")"
if [ -n "$client" ]; then
    hyprctl dispatch focuswindow "class:$class"
else
    $cmd
fi
