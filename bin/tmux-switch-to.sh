#!/bin/sh


wanted_window="$1" # 'shell' or 'editor'
operation="$2" # 'print' or 'select'

###################
# Argument checking

if [ "$wanted_window" != "shell" ] && [ "$wanted_window" != "editor" ]; then
    echo "wanted_window must be 'shell' or 'editor'"
    exit 1
fi

[ -z "$operation" ] && operation="select"
if [ "$operation" != "print" ] && [ "$operation" != "select" ]; then
    echo "operation must be 'print' or 'select'"
    exit 1
fi

#####################
# grab data from tmux

session="$(tmux list-sessions -F "#{session_name},#{session_attached},#{session_activity}" | \
    sort -r -k3 --field-separator="," | head --lines 1 | cut -d ',' -f 1)"

active_window="$(tmux list-windows -t "$session" -F "#{?window_active,#{window_name},}")"

tmux has-session -t "$session:editor" 2> /dev/null
has_editor="$?"
window_count="$(tmux display-message -p -t "$session" "#{session_windows}" 2> /dev/null)"

###################################
# Make sure the wanted window exist

if [ "$has_editor" != 0 ] && [ "$wanted_window" = "editor" ]; then
    nvim_server_path="/tmp/nvim-server-$session.pipe"
    [ -e "$nvim_server_path" ] || tmux new-window -d -t "$session:0" -n editor -d nvim --listen "$nvim_server_path"
fi

if [ "$window_count" = "1" ] && [ "$wanted_window" = "shell" ] && [ "$active_window" = "editor" ]; then
    tmux new-window -t "$session"
fi

#############################
# Select to the wanted window

if [ "$operation" = "select" ]; then
    if [ "$wanted_window" = "editor" ]; then
        tmux switch-client -t "$session:editor"
    elif [ "$wanted_window" = "shell" ] && [ "$active_window" = "editor" ]; then
        tmux select-window -l -t "$session"
    fi
elif [  "$operation" = "print"  ]; then
    if [ "$wanted_window" = "editor" ]; then
        echo "$session:editor"
    elif [ "$wanted_window" = "shell" ]; then
        # the shell window index is always the last used non-editor window
        shell_window_index="$(tmux list-windows -t general -F "#{window_index},#{window_name},#{window_activity}" | \
            grep -v "editor," | sort -r -k3 --field-separator="," | head --lines 1 | cut -d ',' -f 1)"

        echo "$session:$shell_window_index"
    fi
fi
