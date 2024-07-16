#!/bin/sh

session="$(tmux.sh active_session)"
[ -z "$session" ] && exit 1

if [ -z "$TMUX" ] && [ -t 0 ]; then
    nvim "$@"
else
    tmux.sh create_editor_window
    server="$(tmux.sh nvim_server)"

    i=1
    while [ "$i" -le "$#" ]; do
        eval "arg=\$$i"

        cmd=""
        case "$arg" in
            *-vs*) cmd="vs";;
            *-sp*) cmd="sp";;
            *-e*) cmd="e";;
            *-tabe*) cmd="tabe";;
        esac

        if [ -z "$cmd" ]; then
            cmd="e"
            file="$(readlink -f "$arg")"
        else
            i="$(( $i + 1 ))"
            eval "arg=\$$i"
            file="$(readlink -f "$arg")"
        fi

        if [ "$cmd" = "tabe" ]; then
            # This allows the tab to overtake an empty buffer
            nvim --server "$server" --remote-tab "$file"
        else
            nvim --server "$server" --remote-send "<CMD>$cmd $file<CR>"
        fi
        i="$(( $i + 1 ))"
    done

    tmux-switch-to.sh editor
fi
