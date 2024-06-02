#!/bin/sh

session="$(tmux list-sessions -F "#{session_name},#{session_attached},#{session_activity}" | \
    sort -r -k3 --field-separator="," | head --lines 1 | cut -d ',' -f 1)"

if [ -z "$session" ] || [ -z "$TMUX" ]; then
    nvim "$@"
else
    tmux-switch-to.sh editor
    nvim_server_path="/tmp/nvim-server-$session.pipe"
    server="--server "$nvim_server_path""

    if [ "$1" = "--vs" ] && [ "$#" -gt "1" ]; then
        file="$(readlink -f "$2")"
        nvim $server --remote-send "<ESC>:vs $file<CR>"
    elif [ "$1" = "--hs" ] && [ "$#" -gt "1" ]; then
        file="$(readlink -f "$2")"
        nvim $server --remote-send "<ESC>:sp $file<CR>"
    else
        if [ "$#" = "1" ]; then
            file="$(readlink -f "$1")"
            nvim $server --remote-tab "$file"
        else
            nvim $server $@
        fi

    fi
fi
