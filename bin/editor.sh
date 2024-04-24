#!/bin/sh

$EDITOR "$@"

# nvim_server_path="/tmp/nvim-server.pipe"

# if [ -z "$DISPLAY" ]; then
#     $EDITOR "$@"
# else
#     [ -e "$nvim_server_path" ] || neovide -- --listen "$nvim_server_path" "$@"
#     if [ -e "$nvim_server_path" ]; then
#         file="$(readlink -f "$1")"
#         nvim --server "$nvim_server_path" --remote-tab "$file";
#         nvim --server "$nvim_server_path" --remote-send ":NeovideFocus<CR>";
#     fi
# fi
