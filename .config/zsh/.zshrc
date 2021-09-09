#!/bin/sh
HISTFILE=~/.local/share/zsh/zsh_history

setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
setopt appendhistory                            # Immediate history sharing between sessions

unsetopt BEEP                                   # Disable beeping

autoload -Uz compinit
autoload -Uz colors && colors

zstyle ':completion:*' menu select

zmodload zsh/complist

stty stop undef		                            # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')                    # Disable highlighting when pasting

# compinit
_comp_options+=(globdots)                       # Include hidden files.

source "$ZDOTDIR/zsh-functions"
# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"

# Plugins
zsh_add_plugin     "zsh-users/zsh-autosuggestions"
zsh_add_plugin     "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin     "hlissner/zsh-autopair"

# Vi mode
bindkey -v

# Environment variables
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export PATH=$PATH:$HOME/bin
export HISTCONTROL=ignoreboth
export EDITOR=nvim
export MANPAGER='bat'

# Aliases
alias ls='ls --color=auto'

alias pgit='git push origin master'
alias agit='git add'
alias cgit='git commit'
alias cagit='git commit -a'
alias dgit='git diff'
alias sgit='git status'

alias v=nvim
alias pac='sudo pacman'

eval "$(starship init zsh)"
