#!/bin/sh
_sub_and_abs() {
    if [ "$1" -lt "$2" ]; then
        echo "$(($2 - $1))"
    else
        echo "$(($1 - $2))"
    fi
}

_popup_half_screen() {
    x="100%"
    y="100%" # adjust y by changing h
    h="60%"
    w="100%"
    layout="reverse"
    echo "-x $x -y $y -w $w -h $h,$layout"
}

_popup_follow_cursor_half_screen() {
    cursor_y="$(tmux display-message -p "#{cursor_y}")"
    pane_top="$(tmux display-message -p "#{pane_top}")"
    pane_left="$(tmux display-message -p "#{pane_left}")"
    pane_w="$(tmux display-message -p "#{pane_width}")"
    win_h="$(tmux display-message -p "#{window_height}")"
    win_w="$(tmux display-message -p "#{window_width}")"

    x=0
    w="$pane_w"
    if [ $((x + pane_left)) -ge $((win_w / 2)) ]; then
        x="$((win_w / 2))"
    fi

    # cursor_y=0 is top of the screen
    # but the popup will start at the top, go down to y and draw from the bottom to top
    y="$((cursor_y + pane_top))"
    if [ "$y" -lt "$((win_h / 2))" ]; then # upper half
        h="$((win_h - y))"
        y="$(( y + h + 1 ))"
        layout="reverse" # top to bottom listing
    else # lower half
        diff=$(_sub_and_abs "$y" "$win_h")
        h=$((win_h - diff))
        layout="default" # bottom to top listing
    fi

    echo "-x $x -y $y -w $w -h $h,$layout"
}

_popup_follow_cursor() {
    out_x="$(tmux display-message -p "#{cursor_x}")"
    out_y="$(tmux display-message -p "#{cursor_y}")"
    out_top="$(tmux display-message -p "#{pane_top}")"
    out_left="$(tmux display-message -p "#{pane_left}")"
    out_pane_h="$(tmux display-message -p "#{pane_height}")"
    out_pane_w="$(tmux display-message -p "#{pane_width}")"
    out_win_h="$(tmux display-message -p "#{window_height}")"
    out_win_w="$(tmux display-message -p "#{window_width}")"

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

active_session() {
   session="$(tmux list-sessions -F "#{session_name},#{session_activity}" | \
       sort -r -k2 --field-separator="," | head --lines 1 | cut -d ',' -f 1)"

   echo "$session"
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

has_build_window() {
    session="$(active_session)"
    tmux has-session -t "$session:build" 2> /dev/null
    has_build="$?"
    [ "$has_build" = 0 ] && echo yes
    [ "$has_build" != 0 ] && echo no
}

window_count() {
    session="$(active_session)"
    tmux display-message -p -t "$session" "#{session_windows}" 2> /dev/null
}

create_editor_window() {
    cwd=$(active_session_pane_cwd)
    if [ "$(has_editor_window)" = "no" ]; then
        session="$(active_session)"
        tmux new-window -d -c "$cwd" -t "$session:0" -n editor -d
    fi
}

create_build_window() {
    cwd=$(active_session_pane_cwd)
    if [ "$(has_build_window)" = "no" ]; then
        session="$(active_session)"
        tmux new-window -d -c "$cwd" -t "$session:10" -n build
    fi
}

non_special_window_index() {
    # the window index is always the last used non-special window
    tmux list-windows -t "$(active_session)" -F "#{window_index},#{window_name},#{window_activity}" | \
        grep -v "editor," | grep -v "build," | sort -r -k3 --field-separator="," | head --lines 1 | cut -d ',' -f 1
}

current_pane_argv() {
    ps -p $(tmux display -p "#{pane_pid}") -o args=
}

prompt_respawn_current_pane() {
    tmux command-prompt -I "$(current_pane_argv)" -p "Run:" "respawn-pane -k '%%'"
}

# Return empty string if the editor window doesn't exist
editor_window_name() {
    tmux list-windows -t "$(active_session)" -F "#{window_index},#{window_name},#{window_activity}" | \
        grep "editor," | sort -r -k3 --field-separator="," | head --lines 1 | cut -d ',' -f 2
}

create_editor_and_build() {
    create_editor_window
    create_build_window
    
}

popup_dims() {
    _popup_follow_cursor_half_screen
    # _popup_follow_cursor
    # _popup_half_screen
}

active_session_pane_cwd() {
    session="$(active_session)"
    tmux display -t "$session" -p "#{pane_current_path}"
}

active_session_cwd() {
    session="$(active_session)"
    tmux display -t "$session" -p "#{session_path}"
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
