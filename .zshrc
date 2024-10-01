# .zshrc
# ----------------------------------------------------------------------------
export EDITOR="vim"
export VISUAL="vim"

# VIM key bindings
bindkey -e		
# ----------------------------------------------------------------------------
# Completion
# ----------------------------------------------------------------------------
# Vi bindings for completion menu
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Extended completion with menu
autoload -Uz compinit && compinit
zstyle ':completion:*' menu yes select

# Completion with up/-down arrow keys.
# Cycle through history based on characters already typed on the line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
# ----------------------------------------------------------------------------
# History
# ----------------------------------------------------------------------------
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000
setopt APPEND_HISTORY
# No duplicates in history file
setopt HIST_SAVE_NO_DUPS
# Add command immediatly to history
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS

# ----------------------------------------------------------------------------
# Prompt
# ----------------------------------------------------------------------------
autoload -U colors && colors
local returncode="%(?..%F{red} %? ↵%f)"

#PS1='%B%F%n@%m%f:%F{red}%1~%b%f %(!.#.$) '
PS1='%n@%m%f:%F{red}%1~%b%f %(!.#.$) '
RPROMPT="$returncode"
# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------
# POSIX/ Bourne Shell compatible
[ -f "$HOME"/.sh_functions ] && . "$HOME"/.sh_functions

# zsh specific functions

# Set terminal tab title
function term_title(){
	printf "\e]1;$1\a"
}
