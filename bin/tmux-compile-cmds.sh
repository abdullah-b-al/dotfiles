#!/bin/sh

cmds="$(compile-cmds --list-in-cwd)"
[ -z "$cmds" ] && echo Empty compile-cmd list && exit 0

if [ "$1" = "pick-first" ]; then
    cmd="$(echo "$cmds" | head -n 1 )"
    tmux-switch-to.sh shell && tmux send-keys C-c " $cmd" C-M
elif [ "$1" = "popup" ]; then
    out="$(tmux-get-cursor-pos.py)"
    pos_args="$(echo "$out" | cut -d ',' -f 1)"
    reverse="$(echo "$out" | cut -d ',' -f 2)"
    opts="--layout=$reverse --no-sort"

    # recursively call the same script
    tmux popup -d "$(pwd)" -e FZF_DEFAULT_OPTS="$opts" $pos_args -E -- "$0"
else
    result=$(echo "$cmds" | fzf)
    [ -z "$result" ] && exit 0
    tmux-switch-to.sh shell && tmux send-keys C-c " $result" Enter
fi
