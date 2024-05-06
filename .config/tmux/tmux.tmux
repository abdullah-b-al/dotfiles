#!/bin/sh
tmux bind C-a run-shell 'tmux-insert-path.sh begin "#{pane_id}"'
