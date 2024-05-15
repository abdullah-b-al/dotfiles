#!/bin/sh

if [ "$1" = "begin" ]; then
    pane="$2"

    out="$(tmux-get-cursor-pos.py)"
    pos_args="$(echo "$out" | cut -d ',' -f 1)"
    reverse="$(echo "$out" | cut -d ',' -f 2)"
    tmux popup -E $pos_args -- "$0" "$pane" "$reverse"
else
    pane="$1"
    export FZF_DEFAULT_OPTS="--layout=$2"
    result="$(find ~ | fzf)"
    [ -z "$result" ] && exit 0

    tmux set-buffer "$result"
    tmux paste-buffer -p -t "$pane"
fi
