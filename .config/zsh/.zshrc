#!/bin/sh

function zcompare() {
  if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
    zcompile ${1}
  fi
}

function zcompare_source() {
  zcompare "$1"
  source "$1"
}

# Load if exists
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/profile"

HISTFILE=$XDG_CACHE_HOME/zsh_history
HISTSIZE=3000
SAVEHIST=3000

setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments

setopt APPEND_HISTORY                            
setopt SHARE_HISTORY                            # Immediate history sharing between sessions
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt AUTOPUSHD

unsetopt BEEP                                   # Disable beeping

# this prevents .zcompdump from being generated on every startup
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	autoload -Uz compinit;
else
    autoload -Uz compinit -C;
fi

autoload -Uz colors && colors
autoload -z edit-command-line
zle -N edit-command-line

zstyle ':completion:*' menu select


zmodload zsh/complist

stty stop undef	                                # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')                    # Disable highlighting when pasting

# compinit
_comp_options+=(globdots)                       # Include hidden files.

zcompare_source "$ZDOTDIR/zsh-functions"
zcompare_source "$ZDOTDIR/vim-mode"
zcompare_source "$ZDOTDIR/zoxide"

# Plugins
zsh_add_plugin     "Aloxaf/fzf-tab"
zsh_add_plugin     "marlonrichert/zsh-autocomplete"
zsh_add_plugin     "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin     "hlissner/zsh-autopair"
zsh_add_plugin     "zsh-users/zsh-autosuggestions"

zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':autocomplete:*' delay 0.05  # seconds (float)
zstyle ':autocomplete:history-search-backward:*' list-lines 8
# zstyle ':autocomplete:*' min-input 2

bindkey '^[[A' up-history
bindkey '^[[B' down-history
bindkey -M vicmd 'k' up-history
bindkey -M vicmd 'j' down-history

bindkey '^N' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '^N' menu-complete "$terminfo[kcbt]" reverse-menu-complete
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
# bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
bindkey -M menuselect '^Y' accept-line

bindkey '^E' edit-command-line
bindkey -M vicmd '^E' edit-command-line

bindkey -s "^D" 'echo "Do you really need to close this ?" && sleep 1'\\n
bindkey -s "^O" popd\\n
bindkey '^R' history-incremental-search-backward

eval "$(starship init zsh)"

session_name="general"
[ "$XDG_VTNR" -gt 1 ] && session_name="tty$XDG_VTNR"
[ -z "$TMUX" ] && tmux new-session -A -s "$session_name"

enable-fzf-tab
add-zsh-hook preexec preexec_hook_for_compile
