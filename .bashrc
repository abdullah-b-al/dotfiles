#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
# Aliases
alias pgit='git push origin main'
alias agit='git add'
alias cgit='git commit'
alias cagit='git commit -a'
alias dgit='git diff'
alias sgit='git status'

alias v=nvim
alias pac='sudo pacman'

# Session environment variables
export PATH=$PATH:$HOME/bin
export HISTCONTROL=ignoreboth
export EDITOR=nvim
export MANPAGER='bat'

eval "$(starship init bash)"
