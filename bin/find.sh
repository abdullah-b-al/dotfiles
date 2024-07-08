#!/bin/sh

_open_path_fzf() {
    fzf --bind 'ctrl-e:execute($EDITOR {})+abort' --header 'CTRL-e open in editor'
}

_list_functions() {
    pat="^.*()\s*{"
    grep "$pat" "$0" | grep -v "^_" | cut -f 1 -d "("
}

if [ -t 0 ]; then
    alias menu="_open_path_fzf"
else
    alias menu="rofi -dmenu -matching regex -i"
fi

personal() {
    ignore_dir=".*zig-cache|.*zig-out"
    find  "$HOME/personal"  \( -regextype posix-egrep -regex "$ignore_dir" \) -prune -o -print | menu
}

dotfiles() {
    ignore_file="\.png$|LICENSE|README|\.jpg$|\.pdf$"
    ignore_dir=".*local/share|.*local/lib|.*clj-kondo/.cache|.*dotfiles/.config/zsh/plugins|.*git|.*awesome/lain|.*awesome/freedesktop|.*ccls-cache"
    find "$DOTFILESDIR"  \( -regextype posix-egrep -regex "$ignore_dir" \) -prune -o -print \
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

[ -z "$operation" ] && operation="$(echo "open\nget" | menu)"
[ -z "$target" ] && target="$(_list_functions | menu)"

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
