#!/bin/sh

nvim_server_path="/tmp/nvim-server.pipe"

if ! [ -z "$DISPLAY" ]; then
  [ -e "$nvim_server_path" ] || neovide -- --listen "$nvim_server_path" "$@"
  # pgrep neovide || 
  if [ -e "$nvim_server_path" ]; then
    nvim --server "$nvim_server_path" --remote-tab "$1";
    nvim --server "$nvim_server_path" --remote-send ":NeovideFocus<CR>";
  fi
else
  $EDITOR "$@"
fi
