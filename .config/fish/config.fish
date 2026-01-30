source $HOME/.dotfiles/.config/shell/exports

set PAGER bat

bind -M insert ctrl-o 'prevd; commandline -f repaint'
bind -M default ctrl-o 'prevd; commandline -f repaint'
bind -M insert ctrl-n 'nextd; commandline -f repaint'
bind -M default ctrl-n 'nextd; commandline -f repaint'

if status is-login
    if test -z "$DISPLAY" && test "$XDG_VTNR" -eq 1 && test -z "$TMUX"
        set -x MOZ_ENABLE_WAYLAND 1

        if test -e /sys/class/power_supply/BAT0
            exec sway --config ~/.config/sway/laptop
        else
            exec sway --config ~/.config/sway/desktop
        end
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
