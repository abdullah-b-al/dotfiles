#!/bin/sh

if [ "$1" = "begin" ]; then
    pane="$2"
    tmux split-window -v -l 10 -- "$0 $pane"
else
    pane="$1"
    result="$(fzf | tr -d "\n")"
    [ -z "$result" ] && exit 1
    tmux select-pane -l
    tmux set-buffer "$result"
    tmux paste-buffer -p
fi
