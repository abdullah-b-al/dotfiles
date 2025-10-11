#!/bin/sh


nvim_server_pipe() {
    session="$(tmux.sh active_session)"
    echo "/tmp/nvim-server-$session.pipe"
}

editor_zed() {
    if [ $(command -v zed-fhs) ]; then
        zed-fhs --add "$@"
    else
        zed --add "$@"
    fi
}

editor_nvim() {

    session="$(tmux.sh active_session)"
    [ -z "$session" ] && exit 1

    if [ -z "$TMUX" ] && [ -t 0 ]; then
        "$EDITOR" "$@"
        exit "$?"
    fi


    case "$1" in
        "--start-server")
            nvim_server_pipe="$(nvim_server_pipe)"
            session="$(tmux.sh active_session)"
            [ -e "$nvim_server_pipe" ] || nvim --listen "$(nvim_server_pipe)"

            exit 0
            ;;
        "--save-files")
            nvim --server "$(nvim_server_pipe)" --remote-send "<CMD>wa<CR>"

            exit 0
            ;;
        "--vim-make-and-switch")
            tmux-switch-to.sh editor

            shift
            makeprg="$1"
            shift
            vim_make="make $@"
            nvim --server "$(nvim_server_pipe)" --remote-send "<CMD>set makeprg=$makeprg<CR>"
            nvim --server "$(nvim_server_pipe)" --remote-send "<CMD>wa | $vim_make<CR>"

            exit 0
            ;;
    esac



    editor_window_name=$(tmux.sh editor_window_name)
    tmux.sh create_editor_window
    # wait for the window to be created
    if [ "$editor_window_name" = "" ];then
        sleep 0.25
    fi

    i=1
    while [ "$i" -le "$#" ]; do
        eval "arg=\$$i"

        cmd=""
        case "$arg" in
            *-vs*) cmd="vs";;
            *-sp*) cmd="sp";;
            *-e*) cmd="e";;
            *-tabe*) cmd="tabe";;
        esac

        if [ -z "$cmd" ]; then
            cmd="e"
            file="$(readlink -f "$arg")"
        else
            i="$(( i + 1 ))"
            eval "arg=\$$i"
            file="$(readlink -f "$arg")"
        fi

        nvim --server "$(nvim_server_pipe)" --remote-send "<CMD>$cmd $file<CR>"

        i="$(( $i + 1 ))"
    done
}

editor_zed $@
sway-open-or-goto.sh editor

# if pgrep zed; then
#     editor_zed $@
#     hyprland-open-or-goto.sh editor
# elif [ -z $TMUX ]; then
#     editor_zed $@
#     hyprland-open-or-goto.sh editor
# else
#     editor_nvim $@
#     tmux-switch-to.sh editor
# fi
