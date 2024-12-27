#!/usr/bin/env bash

path_prefix() {
    prefix=$(find.sh path-of $path_to_find)
    [ "$prefix" = '/' ] && prefix=""
    [ "$prefix" != '/' ] && prefix="$prefix/"
    echo $prefix
}

target="$1"
if [ -z "$target" ]; then
    notify-send $(basename $0) "Target not provided"
    exit 1
fi

if [ "$1" = "--init-run" ]; then
    export path_to_find="$2"
    rofi -modi "find:rofi-find.sh" -show find
elif [ -z "$1" ]; then
    if [ -z "$path_to_find" ]; then
        echo "path to find was not provided\n"
    else
        printf "\0use-hot-keys\x1ftrue\n"
        printf "\0prompt\x1ffind in $path_to_find\n"

        find.sh list "$path_to_find" relative
    fi
else
    result="$(path_prefix)$1"
    case $ROFI_RETV in
        1) open.sh "$result" 2>&1 > /dev/null &;; # enter
        # custom keys
        10) printf "%s" $result | xsel -ib 2>&1 > /dev/null &;; # control+s
        11) editor.sh -tabe $result 2>&1 > /dev/null &;; # control+t
        12) tmux set-buffer $result && tmux paste-buffer -p &;; # control+i
        13) editor.sh -sp $result 2>&1 > /dev/null &;; # control+x
        14) editor.sh -vs $result 2>&1 > /dev/null &;; # control+v
    esac
fi
