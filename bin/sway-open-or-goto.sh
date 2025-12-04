#!/usr/bin/env bash

goto_id() {
    wanted_id="$1"
    found_id="$(swaymsg --raw -t get_tree | jq -r '.. | .app_id? // empty' | grep "$wanted_id" | head -n 1)"
    [ -n "$found_id" ] && swaymsg "[app_id=$found_id] focus"
}

declare -A app_ids
declare -A commands

app_ids[shell]="Alacritty"
app_ids[build]="Alacritty"
# app_ids[editor]="dev.zed.Zed"
app_ids[editor]="Alacritty"
app_ids[docs]=".*firefox.*"
app_ids[browser]="brave-browser"
app_ids[dev_browser]="chromium.*"

title[test_window]="TestWindow"

commands[shell]="alacritty"
commands[build]="alacritty"
commands[editor]="tmux-switch-to.sh editor"
commands[docs]="firefox"
commands[browser]="brave"
commands[dev_browser]="chromium"
commands[test_window]="TestWindow"


wanted="$1"
app_id="${app_ids[$wanted]}"
title="${title[$wanted]}"
cmd="${commands[$wanted]}"


if [ -n "$app_id" ] ; then
    if [ -z "$cmd" ]; then
        echo "Unknown command"
        exit 1
    fi


    if ! [ "$(goto_id "$app_id")" ]; then
        $cmd &

        while ! [ "$(goto_id "$app_id")" ]; do
            sleep 0.05
        done
    fi

    if [ "$wanted" = editor ]; then
        $cmd
    fi

elif [ -n "$title" ]; then
    swaymsg "[title=$title] focus"
fi
