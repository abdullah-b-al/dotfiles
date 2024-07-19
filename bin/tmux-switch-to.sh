#!/bin/sh

wanted_window="$1" # 'shell' or 'editor'

if [ "$wanted_window" != "shell" ] && [ "$wanted_window" != "editor" ]; then
    echo "wanted_window must be 'shell' or 'editor'"
    exit 1
fi

# grab data from tmux

session="$(tmux.sh active_session)"
active_window="$(tmux.sh active_window)"
has_editor="$(tmux.sh has_editor_window)"
window_count="$(tmux.sh window_count)"

# Make sure the wanted window exist

if [ "$has_editor" = "no" ] && [ "$wanted_window" = "editor" ]; then
    tmux.sh create_editor_window
fi

if [ "$window_count" = "1" ] && [ "$wanted_window" = "shell" ] && [ "$active_window" = "editor" ]; then
    tmux new-window -t "$session"
fi

# Select the wanted window

if [ "$wanted_window" = "editor" ]; then
    tmux switch-client -t "$session:editor"
elif [ "$wanted_window" = "shell" ] && [ "$active_window" = "editor" ]; then
    tmux select-window -l -t "$session"
fi
