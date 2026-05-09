#!/bin/sh

operation="$1"
target="$2"
ignore="$3"

################################################################################

_list_functions() {
    pat="^.*()\s*{"
    grep "$pat" "$0" | grep -v "^_" | cut -f 1 -d "("
}

_prepend() {
    echo "$@"
    cat -
}

_path_prefix() {
    "$target"
    prefix="$find_path"
    if [ "$find_path" != '/' ]; then
        if [ "$(printf "%s" "$find_path" | tail -c 1)" != "/" ]; then
            prefix="$find_path/"
        else
            prefix="$find_path"
        fi
    fi
    printf "%s" "$prefix"
}

_real_result() {
    [ -z "$1" ] && exit 1
    result="$1"
    prefix="$(_path_prefix)"
    if [ "$(echo "$result" | head -c 1)" != "/" ]; then
        result="$prefix$result"
    fi
    printf "%s" "$result"
}

_open_path_fzf() {
    # these should come as exported variables from the 'tmux popup -e'
    [ -z "$prefix" ] && layout="reverse"
    [ -z "$prefix" ] && height="33%"

    export target
    header="Enter=Open ^e=Edit ^x=Copy ^i=Tmux insert\nEditor server: ^v=Vertical split ^s=Horizontal split ^t=New tab\nFind in $target"
    result=$(_prepend "$header" |\
        fzf --height=$height --layout=$layout \
        --header-lines=1 \
        --bind 'ctrl-e:execute($EDITOR "$(find.sh real-result "$target" {})")+abort'  \
        --bind 'ctrl-s:execute(find.sh real-result "$target" {} | xsel --input --clipboard )+abort' \
        --bind 'ctrl-i:execute(tmux set-buffer "$(find.sh real-result "$target" {})" && tmux paste-buffer -p)+abort'  \
        --bind 'ctrl-v:execute(find.sh real-result "$target" {} | xargs -I % editor.sh -vs "%")+abort'  \
        --bind 'ctrl-x:execute(find.sh real-result "$target" {} | xargs -I % editor.sh -sp "%")+abort'  \
        --bind 'ctrl-t:execute(find.sh real-result "$target" {} | xargs -I % editor.sh -tabe "%")+abort' \
    )

    if [ $? = 0 ]; then
        _real_result "$result"
    fi
}

prog() {
    if [ "$ignore" = "no-ignore" ]; then
        args="-u "
    fi
    args="$args-E \.zig-cache -E \.git"
    find_path="$HOME/prog"
}

personal() {
    if [ "$ignore" = "no-ignore" ]; then
        args="-u "
    fi
    args="$args-E \.zig-cache -E \.dotfiles -E \.git -E prog"
    find_path="$HOME/personal"
}

notes() {
    if [ "$ignore" = "no-ignore" ]; then
        args="-u "
    fi
    args="$args--glob *.md"
    find_path="$HOME/personal/notes"
}

dotfiles() {
    if [ "$ignore" = "no-ignore" ]; then
        args="-u "
    fi
    args="$args-E \.git -E \.zig-cache -E zig-out"
    find_path="$DOTFILES"
}

cwd() {
    if [ "$ignore" = "no-ignore" ]; then
        args="-u"
    fi
    args="$args"
    find_path="$(pwd)"
}

home() {
    if [ "$ignore" = "no-ignore" ]; then
        args="-u "
    fi
    args="$args-E $HOME/personal"
    find_path="$HOME"
}

root() {
    if [ "$ignore" = "no-ignore" ]; then
        args="-u "
    fi
    args="$args-E /home -E /mnt"
    find_path="/"
}


_find() {
    [ -z "$target" ] && echo "target not set" && exit 1
    "$target" # set the vars in the functions.
    if [ "$target" != "cwd" ] && [ -z "$args" ]; then
        notify-send "$(basename "$0")" "Error in setting args"
        exit 1
    fi
    if [ -z "$find_path" ]; then
        notify-send "$(basename "$0")" "Error in setting path"
        exit 1
    fi

    # fd doesn't provide the directory that's being searched in
    echo "$find_path"
    fd $args --base-directory "$find_path" .
}

################################################################################

[ -z "$operation" ] && operation="$(printf "open\nget\nlist\npath-of\nprefix-for\n" | _open_path_fzf)"
[ -z "$target" ] && target="$(_list_functions | _open_path_fzf "get")"
[ -z "$ignore" ] && ignore="no-ignore"

# Make sure the argument matches one of the functions
if ! grep -q "^$target()\s*{" "$0"; then
    echo "Command doesn't exist"
    exit 1
fi

case "$operation" in
    *open*) open.sh "$(_find | _open_path_fzf "open")" ;;
    *get*) echo "$(_find | _open_path_fzf "get")";;
    *list*) _find;;
    *path-of*) "$target"; echo "$find_path";;
    *real-result*) _real_result "$3";;
esac
