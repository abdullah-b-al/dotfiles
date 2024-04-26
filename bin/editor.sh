#!/bin/sh

session="$(tmux list-sessions -F "#{session_name},#{session_attached},#{session_activity}" | \
    sort -r -k3 --field-separator="," | head --lines 1 | cut -d ',' -f 1)"

if [ -z "session" ] || [ -z "$TMUX" ]; then
    nvim "$@"
else
    tmux-switch-to.sh editor
    nvim_server_path="/tmp/nvim-server-$session.pipe"
    file="$(readlink -f "$1")"
    nvim --server "$nvim_server_path" --remote-tab "$file";
fi
