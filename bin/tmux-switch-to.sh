#!/bin/sh

# shell or editor
wanted_window="$1"

session="$(tmux list-sessions -F "#{session_name},#{session_attached},#{session_activity}" | \
    sort -r -k3 --field-separator="," | head --lines 1 | cut -d ',' -f 1)"

active_window="$(tmux list-windows -t "$session" -F "#{?window_active,#{window_name},}")"

tmux has-session -t "$session:editor" 2> /dev/null
has_session="$?"

if [ "$has_session" = 0 ]; then
    if [ "$wanted_window" = "editor" ]; then
        tmux switch-client -t "$session:editor"
    elif [ "$wanted_window" = "shell" ] && [ "$active_window" = "editor" ]; then
        tmux select-window -l -t "$session"
    fi
elif [ "$has_session" != 0 ] && [ "$wanted_window" = "editor" ]; then
    tmux new-window -d -t "$session:0" -n editor
    tmux switch-client -t "$session:editor"
fi
