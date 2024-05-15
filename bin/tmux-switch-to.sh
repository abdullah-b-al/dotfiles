#!/bin/sh

# shell or editor
wanted_window="$1"

session="$(tmux list-sessions -F "#{session_name},#{session_attached},#{session_activity}" | \
    sort -r -k3 --field-separator="," | head --lines 1 | cut -d ',' -f 1)"

active_window="$(tmux list-windows -t "$session" -F "#{?window_active,#{window_name},}")"

tmux has-session -t "$session:editor" 2> /dev/null
has_session="$?"
window_count="$(tmux display-message -p -t "$session" "#{session_windows}" 2> /dev/null)"

if [ "$has_session" = 0 ]; then
    if [ "$wanted_window" = "editor" ]; then
        tmux switch-client -t "$session:editor"
    elif [ "$wanted_window" = "shell" ] && [ "$active_window" = "editor" ]; then
        if [ "$window_count" = "1" ]; then
            tmux new-window -t "$session"
        else
            tmux select-window -l -t "$session"
        fi
    fi
elif [ "$has_session" != 0 ] && [ "$wanted_window" = "editor" ]; then
    nvim_server_path="/tmp/nvim-server-$session.pipe"

    [ -e "$nvim_server_path" ] || tmux new-window -d -t "$session:0" -n editor -d nvim --listen "$nvim_server_path"

    # Wait for nvim to fully start
    while ! [ -e "$nvim_server_path" ]; do
        sleep 0.001
    done
    tmux switch-client -t "$session:editor"
fi
