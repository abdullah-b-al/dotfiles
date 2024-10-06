#!/bin/sh

_list_functions() {
    pat="^.*()\s*{"
    grep "$pat" "$0" | grep -v "^_" | cut -f 1 -d "("
}

_prepend() {
    echo "$@"
    cat -
}

_open_path_fzf() {
    header="Enter=Open ^e=Edit ^x=Copy ^i=Tmux insert\nNvim server: ^v=Vertical split ^s=Horizontal split ^t=New tab" 
    _prepend "$header" |\
    fzf $height_and_layout \
        --header-lines=2 \
        --bind 'ctrl-e:execute($EDITOR {})+abort'  \
        --bind 'ctrl-x:execute(echo {} | xsel --input --clipboard )+abort' \
        --bind 'ctrl-i:execute(tmux set-buffer {} && tmux paste-buffer -p)+abort'  \
        --bind 'ctrl-v:execute(editor.sh -vs {})+abort'  \
        --bind 'ctrl-s:execute(editor.sh -sp {})+abort'  \
        --bind 'ctrl-t:execute(editor.sh -tabe {})+abort'
}

alias menu="_open_path_fzf"

if ! [ -t 0 ]; then
    out="$(tmux.sh popup_dims)"
    pos_args="$(echo "$out" | cut -d ',' -f 1)"
    layout="$(echo "$out" | cut -d ',' -f 2)"
    tmux popup -e height_and_layout="--layout=$layout --height=100%" -E $pos_args -- $0 $@
    exit 0
elif [ -n "$TMUX" ] && [ -z "$height_and_layout" ]; then
    height_and_layout="--height=25%"
fi

personal() {
    ignore_dir=".*zig-cache|.*dotfiles"
    find  "$HOME/personal"  \( -regextype posix-egrep -regex "$ignore_dir" \) -prune -o -print | menu
}

dotfiles() {
    ignore_file="\.png$|LICENSE|README|\.jpg$|\.pdf$"
    ignore_dir=".*local/share|.*local/lib|.*clj-kondo/.cache|.*dotfiles/.config/zsh/plugins|.*git|.*awesome/lain|.*awesome/freedesktop|.*ccls-cache"
    find "$DOTFILES"  \( -regextype posix-egrep -regex "$ignore_dir" \) -prune -o -print \
        | grep -E -v "$ignore_file" \
        | menu
}

cwd() {
    find "$(pwd)" -name ".git" -prune -o -print  | menu
}

home() {
    find "$HOME" -wholename "$HOME/personal" -prune -name ".git" -prune -o -print  | menu
}

root() {
    ignore_dir="^/home|^/mnt"
    find "/" \( -regextype posix-egrep -regex "$ignore_dir" \) -prune -o -print 2>/dev/null | menu
}

################################################################################

operation="$1"
target="$2"

[ -z "$operation" ] && operation="$(printf "open\nget" | fzf)"
[ -z "$target" ] && target="$(_list_functions | fzf)"

# Make sure the argument matches one of the functions
if ! grep -q "^$target()\s*{" "$0"; then
    echo "Command doesn't exist"
    exit 1
fi

# Run the function
result="$($target)"
case "$operation" in
    *open*) open.sh "$result";;
    *get*) echo "$result";;
esac
