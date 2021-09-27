#!/usr/bin/sh
ignore=".dotfiles/.config/zsh/plugins\|\.png$\|LICENSE\|README\|.dotfiles/.git\|awesome/lain\|awesome/freedesktop"
find "$HOME/.dotfiles" -type f |  grep -v "$ignore" | fzf | xargs -I % nvim %
