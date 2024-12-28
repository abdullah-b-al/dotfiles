#!/bin/sh


operation="$1"
target="$2"

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
    header="Enter=Open ^e=Edit ^x=Copy ^i=Tmux insert\nNvim server: ^v=Vertical split ^s=Horizontal split ^t=New tab\nFind in $target" 
    result=$(_prepend "$header" |\
        fzf --height=$height --layout=$layout \
        --header-lines=3 \
        --bind 'ctrl-e:execute($EDITOR $(find.sh real-result $target {}))+abort'  \
        --bind 'ctrl-s:execute(find.sh real-result $target {} | xsel --input --clipboard )+abort' \
        --bind 'ctrl-i:execute(tmux set-buffer "$(find.sh real-result $target {})" && tmux paste-buffer -p)+abort'  \
        --bind 'ctrl-v:execute(editor.sh -vs "$(find.sh real-result $target {}))+abort'  \
        --bind 'ctrl-x:execute(editor.sh -sp "$(find.sh real-result $target {}))+abort'  \
        --bind 'ctrl-t:execute(editor.sh -tabe "$(find.sh real-result $target {}))+abort' \
    )

    if [ $? = 0 ]; then
        _real_result "$result"
    fi
}

_open_path_rofi() {
    result="$(rofi -dmenu -p "Find in $target")"
    return_value="$?"
    result="$(_real_result "$result")"

    if [ "$1" = "get" ]; then
        echo "$result"
    elif [ "$1" = "open" ]; then
        case $return_value in
            0) open.sh "$result" > /dev/null 2>&1 &;; # enter
            # custom keys
            10) printf "%s" "$result" | xsel -ib > /dev/null 2>&1 &;; # control+s
            11) editor.sh -tabe "$result" > /dev/null 2>&1 &;; # control+t
            12) tmux set-buffer "$result" && tmux paste-buffer -p &;; # control+i
            13) editor.sh -sp "$result" > /dev/null 2>&1 &;; # control+x
            14) editor.sh -vs "$result" > /dev/null 2>&1 &;; # control+v
        esac
    fi
}

# test -t 0 won't work as i expect inside a function. I don't know why so keep this here
test -t 0
export in_terminal="$?"
_menu() {
    if [ "$in_terminal" = 0 ]; then
        _open_path_fzf
    else
        _open_path_rofi "$1"
    fi
}

prog() {
    args="-u -E \.zig-cache -E \.git"
    find_path="$HOME/personal/prog"
}

personal() {
    args="-u -E \.zig-cache -E \.dotfiles -E \.git -E prog"
    find_path="$HOME/personal"
}

dotfiles() {
    args="-u -E \.git"
    find_path="$DOTFILES"
}

cwd() {
    args="-u"
    find_path="$(pwd)"
}

home() {
    args="-u -E $HOME/personal"
    find_path="$HOME"
}

root() {
    args="-u -E /home -E /mnt"
    find_path="/"
}

_find() {
    [ -z "$target" ] && echo "target not set" && exit 1
    "$target" # set the vars in the functions.
    if [ -z "$args" ]; then
        notify-send "$(basename "$0")" "Error in setting args"
        exit 1
    fi
    if [ -z "$find_path" ]; then
        notify-send "$(basename "$0")" "Error in setting path"
        exit 1
    fi

    # fd doesn't provide the directory that's being searched in
    echo "$find_path" # empty so it doesn't conflict with _path_prefix
    fd $args --base-directory "$find_path" .
}

################################################################################

# if ! [ -t 0 ]; then
#     out="$(tmux.sh popup_dims)"
#     pos_args="$(echo "$out" | cut -d ',' -f 1)"
#     layout="$(echo "$out" | cut -d ',' -f 2)"
#     tmux popup -b rounded -e height="100%" -e layout="$layout" -E $pos_args -- $0 $@
#     exit 0
# fi

[ -z "$operation" ] && operation="$(printf "open\nget\nlist\npath-of\nprefix-for\n" | _menu)"
[ -z "$target" ] && target="$(_list_functions | _menu "get")"

# Make sure the argument matches one of the functions
if ! grep -q "^$target()\s*{" "$0"; then
    echo "Command doesn't exist"
    exit 1
fi

case "$operation" in
    *open*) open.sh "$(_find | _menu "open")" ;;
    *get*) echo "$(_find | _menu "get")";;
    *list*) _find;;
    *path-of*) "$target"; echo "$find_path";;
    *real-result*) _real_result $3;;
esac
