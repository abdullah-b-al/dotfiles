source $HOME/.dotfiles/.config/shell/exports

set PAGER bat

bind -M insert ctrl-o 'prevd; commandline -f repaint'
bind -M default ctrl-o 'prevd; commandline -f repaint'
bind -M insert ctrl-n 'nextd; commandline -f repaint'
bind -M default ctrl-n 'nextd; commandline -f repaint'
bind -M default alt-f fm
bind -M insert alt-f fm
bind -M visual alt-f fm

if status is-login
    if test -z "$DISPLAY" && test "$XDG_VTNR" -eq 1 && test -z "$TMUX"
        set -x MOZ_ENABLE_WAYLAND 1
        # set -x WLR_RENDERER vulkan

        if test -e /sys/class/power_supply/BAT0
            set sway_config "$HOME/.config/sway/laptop"
        else
            set sway_config "$HOME/.config/sway/desktop"
        end

        echo "== New Session ==" >>"/tmp/sway.log"
        exec sway --config "$sway_config" &>>"/tmp/sway.log"
    end
else if status is-interactive

    set session_name general
    if test "$XDG_VTNR" -gt 1
        set session_name "tty$XDG_VTNR"
    end

    if test -z "$TMUX" && test -z "$ZED_TERM"
        tmux new-session -A -s "$session_name"
    end
end
