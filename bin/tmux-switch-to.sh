#!/bin/sh

wanted_window="$1" # 'shell', 'build' or 'editor'

if [ "$wanted_window" != "shell" ] && [ "$wanted_window" != "editor" ] && [ "$wanted_window" != "build" ]; then
    echo "wanted_window must be 'shell', 'build', or 'editor'"
    exit 1
fi

# grab data from tmux

session="$(tmux.sh active_session)"
active_window="$(tmux.sh active_window)"
has_editor="$(tmux.sh has_editor_window)"
has_build="$(tmux.sh has_build_window)"
window_count="$(tmux.sh window_count)"

# Make sure the wanted window exist

if [ "$has_editor" = "no" ] && [ "$wanted_window" = "editor" ]; then
    tmux.sh create_editor_window
fi

if [ "$has_build" = "no" ] && [ "$wanted_window" = "build" ]; then
    tmux.sh create_build_window
fi

if [ "$wanted_window" = "shell" ] && [ "$window_count" = "1" ] && [ "$active_window" != "shell" ]; then
    tmux new-window -t "$session"
fi

# Select the wanted window

case "$wanted_window" in
    editor) 
    tmux switch-client -t "$session:editor"
;;
build)
    tmux switch-client -t "$session:build"
;;
shell)
    index=$(tmux.sh non_special_window_index)
    tmux select-window -t "$session:$index"
;;
esac
