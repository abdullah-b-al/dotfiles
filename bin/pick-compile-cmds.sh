#!/bin/sh

notify() {
    [ -t 0 ] && echo "$1"
    [ -t 0 ] || notify-send "$(basename "$0")" "$1"
}

if ! [ -t 0 ]; then
    cd "$(tmux.sh active_session_pane_cwd)"
fi

insert_or_run="run"
cmds="$(compile-cmds.sh list_in_cwd)"
[ -z "$cmds" ] && notify "Empty compile command list" && exit 0

if [ "$1" = "popup" ]; then
    switch="$2"
    out="$(tmux.sh popup_dims)"
    pos_args="$(echo "$out" | cut -d ',' -f 1)"
    reverse="$(echo "$out" | cut -d ',' -f 2)"
    opts="--layout=$reverse --no-sort"

    # recursively call the same script
    tmux popup -d "$(pwd)" -e FZF_DEFAULT_OPTS="$opts" $pos_args -E -- "$0" "$switch"
    exit 0

elif [ "$1" = "rofi" ]; then
    switch="$2"
    cmd="$(echo "$cmds" | tac | rofi -dmenu -theme-str "listview {columns: 1;}")"
    rofi_exit_code="$?"
    case "$rofi_exit_code" in
        0);;
        1);;
        12) insert_or_run="insert";; # control-i
        **) notify "Unknown key" && exit 1;;
    esac
    [ -z "$cmd" ] && exit 0

elif [ "$1" = "pick-last-used" ]; then
    switch="$2"
    cmd="$(echo "$cmds" | tail -n 1 )"

else
    switch="$1"
    cmd=$(echo "$cmds" | fzf \
        --header "^d=delete line" \
        --bind 'ctrl-d:execute(compile-cmds.sh --delete {})+reload(compile-cmds.sh list_in_cwd)' )
fi

[ -z "$cmd" ] && notify "Empty command" && exit 1

if [ "$switch" = "switch" ]; then
    tmux-switch-to.sh build
    editor.sh --save-files
    sleep 0.1
    tmux send-keys -t "build" C-c
    tmux send-keys -t "build" C-l "$cmd"
    if [ "$insert_or_run" = "run" ]; then
        tmux send-keys -t "build" C-M
    fi

elif [ "$switch" = "vim" ]; then
    set $cmd
    editor.sh --vim-make-and-switch $@
fi


if [ "$switch" = "no-switch" ]; then
    notify-send "Command sent" "$cmd" -t 1000
fi
