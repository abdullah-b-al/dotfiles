#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
# Aliases
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
alias pdotfiles="dotfiles push origin main"
alias nv=nvim

# Session environment variables
export HISTCONTROL=ignoreboth

eval "$(starship init bash)"
