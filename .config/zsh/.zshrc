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

zstyle ':completion:*' menu select

zmodload zsh/complist

stty stop undef		                            # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')                    # Disable highlighting when pasting

# compinit
_comp_options+=(globdots)                       # Include hidden files.

zcompare_source "$ZDOTDIR/zsh-functions"
zcompare_source "$ZDOTDIR/vim-mode"

# Plugins
zsh_add_plugin     "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin     "hlissner/zsh-autopair"
# Must load auto-complete first
zsh_add_plugin     "marlonrichert/zsh-autocomplete"
zsh_add_plugin     "zsh-users/zsh-autosuggestions"

zstyle ':autocomplete:history-search-backward:*' list-lines 8

# Vi mode
bindkey -v

bindkey "^N" menu-select
bindkey -s "^O" popd\\n
bindkey '^r' history-incremental-pattern-search-backward

eval "$(starship init zsh)"
[ -z "$TMUX" ] && tmux new-session -A -s "general"
