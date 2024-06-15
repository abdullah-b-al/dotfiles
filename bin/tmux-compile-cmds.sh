#!/bin/sh

cmds="$(compile-cmds --list-in-cwd)"
[ -z "$cmds" ] && echo "Empty compile-cmd list" && exit 0

if [ "$1" = "popup" ]; then
    switch="$2"
    out="$(tmux.sh popup_dims)"
    pos_args="$(echo "$out" | cut -d ',' -f 1)"
    reverse="$(echo "$out" | cut -d ',' -f 2)"
    opts="--layout=$reverse --no-sort"

    # recursively call the same script
    tmux popup -d "$(pwd)" -e FZF_DEFAULT_OPTS="$opts" $pos_args -E -- "$0" "$switch"
    exit 0
elif [ "$1" = "pick-first" ]; then
    switch="$2"
    cmd="$(echo "$cmds" | head -n 1 )"
else
    switch="$1"
    cmd=$(echo "$cmds" | fzf)
fi

[ -z "$cmd" ] && echo "Empty command" && exit 1

[ "$switch" = "switch" ] && tmux-switch-to.sh shell
nvim --server "$(tmux.sh nvim_server)" --remote-send "<CMD>w<CR>"
tmux send-keys -t "$(tmux.sh non_editor_window_index)" C-c " $cmd" C-M

if [ "$switch" = "no-switch" ]; then
    notify-send "Command sent" "$cmd" -t 1000
fi
