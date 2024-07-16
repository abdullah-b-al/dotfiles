#!/bin/sh
_sub_and_abs() {
    if [ "$1" -lt "$2" ]; then
        echo "$(($2 - $1))"
    else
        echo "$(($1 - $2))"
    fi
}

active_session() {
    tmux list-sessions -F "#{session_name},#{session_attached},#{session_activity}" | \
        sort -r -k3 --field-separator="," | head --lines 1 | cut -d ',' -f 1
}

nvim_server() {
    session="$(active_session)"
    echo "/tmp/nvim-server-$session.pipe"
}

active_window() {
    session="$(active_session)"
    tmux list-windows -t "$session" -F "#{?window_active,#{window_name},}"
}

has_editor_window() {
    session="$(active_session)"
    tmux has-session -t "$session:editor" 2> /dev/null
    has_editor="$?"
    [ "$has_editor" = 0 ] && echo yes
    [ "$has_editor" != 0 ] && echo no
}

window_count() {
    session="$(active_session)"
    tmux display-message -p -t "$session" "#{session_windows}" 2> /dev/null
}

# If a session is renamed and an editor opened before renaming this will not start an nvim server
create_editor_window() {
    if [ "$(has_editor_window)" = "no" ]; then
        nvim_server_path="$(nvim_server)"
        session="$(active_session)"
        [ -e "$nvim_server_path" ] || tmux new-window -d -t "$session:0" -n editor -d nvim --listen "$nvim_server_path"
    fi
}

non_editor_window_index() {
    # the window index is always the last used non-editor window
    tmux list-windows -t "$(active_session)" -F "#{window_index},#{window_name},#{window_activity}" | \
        grep -v "editor," | sort -r -k3 --field-separator="," | head --lines 1 | cut -d ',' -f 1
}

popup_dims() {
    out="$(tmux display-message -p "#{cursor_x} #{cursor_y} #{pane_top} #{pane_left} #{pane_height} #{pane_width} #{window_height} #{window_width}")"
    out_x="$(echo "$out" | cut -f 1 -d ' ' )"
    out_y="$(echo "$out" | cut -f 2 -d ' ' )"
    out_top="$(echo "$out" | cut -f 3 -d ' ' )"
    out_left="$(echo "$out" | cut -f 4 -d ' ' )"
    out_pane_h="$(echo "$out" | cut -f 5 -d ' ' )"
    out_pane_w="$(echo "$out" | cut -f 6 -d ' ' )"
    out_win_h="$(echo "$out" | cut -f 7 -d ' ' )"
    out_win_w="$(echo "$out" | cut -f 8 -d ' ' )"

    w="$out_pane_w"
    h="$((out_win_h / 2))"
    x="$((out_x + out_left))"
    x="$(_sub_and_abs $x 3)"
    y="$((out_y + out_top + h + 1))"


    layout="reverse"

    if [ "$y" -gt "$out_win_h" ]; then
        y="$((y - h - 1))"
        layout="default"
    fi

    right="$((x+w))"
    if [ "$w" = "$out_win_w" ] || [ "$right" -ge "$out_win_w" ]; then
        w="$(_sub_and_abs "$x" "$out_win_w")"
    fi

    echo "-x $x -y $y -w $w -h $h,$layout"
}

if [ "$1" = "--help" ] || [ -z "$1" ]; then
    pat="^.*()\s*{"
    echo "Avaliable commands:"
    grep "$pat" "$0" | grep -v "^_" | cut -f 1 -d "("
    exit 0
fi

# If an argument is provided then run the function with the same name
# Make sure the argument matches one of the functions
if grep -q "^$1()\s*{" "$0"; then
    # Call the function
    "$1"
else
    echo "Command doesn't exist"
    exit 1
fi
