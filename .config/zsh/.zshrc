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

# compinit
_comp_options+=(globdots)                       # Include hidden files.

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

zcompare_source "$ZDOTDIR/zsh-functions"

# Plugins
zsh_add_plugin     "Aloxaf/fzf-tab"
enable-fzf-tab
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

zsh_add_plugin     "Multirious/zsh-helix-mode"
zsh_add_plugin     "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin     "marlonrichert/zsh-autocomplete"
zsh_add_plugin     "zsh-users/zsh-autosuggestions"

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
  zhm_history_prev
  zhm_history_next
  zhm_prompt_accept
  zhm_accept
  zhm_accept_or_insert_newline
)
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(
  zhm_move_right
  zhm_clear_selection_move_right
)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
  zhm_move_next_word_start
  zhm_move_next_word_end
)

zsh_add_plugin     "hlissner/zsh-autopair"
zsh_add_plugin     "romkatv/powerlevel10k"
zsh_add_plugin     "trapd00r/LS_COLORS" "lscolors"

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

theme_path="$HOME/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"
if [ -f "$theme_path" ]; then
    source "$theme_path"
    source "$HOME/.config/zsh/p10k.zsh"
fi
# eval "$(starship init zsh)"

session_name="general"
[ "$XDG_VTNR" -gt 1 ] && session_name="tty$XDG_VTNR"

[ -z "$TMUX" ] && [ -z "$ZED_TERM" ] && tmux new-session -A -s "$session_name"

add-zsh-hook preexec preexec_hook_for_compile

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
