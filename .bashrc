#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
# Aliases
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
alias pdotfiles='dotfiles push origin main'
alias adotfiles='dotfiles add'
alias cdotfiles='dotfiles commit'
alias cadotfiles='dotfiles commit -a'
alias ddotfiles='dotfiles diff'
alias sdotfiles='dotfiles status'

alias v=nvim
alias pac='sudo pacman'

# Session environment variables
export PATH=$PATH:/home/ab55al/bin
export HISTCONTROL=ignoreboth
export EDITOR=nvim
export MANPAGER='nvim +Man!'

eval "$(starship init bash)"
