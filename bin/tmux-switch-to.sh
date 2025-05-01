#!/bin/sh

wanted_window="$1"

case $wanted_window in
    "shell" | "build" | "editor")
        ;;
    **)
        echo "wanted_window must be 'shell', 'build' or 'editor'"
        exit 1
        ;;
esac

# grab data from tmux

session="$(tmux.sh active_session)"
active_window="$(tmux.sh active_window)"
has_editor="$(tmux.sh has_editor_window)"
window_count="$(tmux.sh window_count)"

# Make sure the wanted window exist

if [ "$has_editor" = "no" ] && [ "$wanted_window" = "editor" ]; then
    tmux.sh create_editor_window
fi

if [ "$wanted_window" = "shell" ] && [ "$window_count" = "1" ]; then
    cwd=$(active_session_pane_cwd)
    case $active_window in
        "editor" | "build") tmux new-window -c "$cwd" -t "$session" ;;
        **) ;;
    esac
fi

# Select the wanted window

case "$wanted_window" in
    editor)
        tmux switch-client -Z -t "$session:editor.0"

        zoomed=$(tmux display-message -t $session:editor -p "#{window_zoomed_flag}")
        [ "$zoomed" = 0 ] && tmux resize-pane -Z -t "$session:editor.0"
        ;;
    build)
        active=$(tmux display-message -t $session:editor.1 -p "#{pane_active}")

        tmux switch-client -t "$session:editor.1"

        if [ "$active" = "1" ]; then
            tmux resize-pane -Z -t "$session:editor.1"
        fi

        ;;
    shell)
        index=$(tmux.sh non_special_window_index)
        tmux select-window -t "$session:$index"
        ;;
esac
