#!/bin/sh

session="$(tmux.sh active_session)"

if [ -z "$session" ] || [ -z "$TMUX" ]; then
    nvim "$@"
else
    tmux-switch-to.sh editor
    server="--server $(tmux.sh nvim_server)"

    if [ "$1" = "--vs" ] && [ "$#" -gt "1" ]; then
        file="$(readlink -f "$2")"
        nvim $server --remote-send "<ESC>:vs $file<CR>"
    elif [ "$1" = "--hs" ] && [ "$#" -gt "1" ]; then
        file="$(readlink -f "$2")"
        nvim $server --remote-send "<ESC>:sp $file<CR>"
    elif [ "$#" = "1" ]; then
        file="$(readlink -f "$1")"
        nvim $server --remote-tab "$file"
    fi
fi
