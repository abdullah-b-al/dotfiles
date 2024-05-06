#!/bin/sh

if [ "$1" = "begin" ]; then
    pane="$2"
    tmux split-window -v -l 10 -- "$0 $pane"
else
    pane="$1"

    result="$(find ~ | fzf)"
    [ -z "$result" ] && exit 1

    tmux select-pane -l
    tmux set-buffer "$result"
    tmux paste-buffer -p -t "$pane"
fi
