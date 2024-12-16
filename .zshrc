# .zshrc
# ----------------------------------------------------------------------------
if type vim > /dev/null 2>&1; then
	export EDITOR="vim"
	export VISUAL="vim"
fi

# VIM key bindings
bindkey -e		

# === SSH agent
SSH_AGENT_ENV="$HOME"/.ssh/agent.env

ssh_agent_load_env()
{
	test -f "$SSH_AGENT_ENV" && . "$SSH_AGENT_ENV" >| /dev/null
}

ssh_agent_start()
{
	(umask 077; ssh-agent >| "$SSH_AGENT_ENV")
	. "$SSH_AGENT_ENV" >| /dev/null
}

ssh_agent_load_env

# ssh_agent_run_state:
# 0=running with key; 1=running without key; 2=agent not working
SSH_AGENT_RUNNING_STATE=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ !"$SSH_AUTH_SOCK" ] || [ "$SSH_AGENT_RUN_STATE" = "2" ]; then
	ssh_agent_start
	ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ "$SSH_AGENT_RUN_STATE" = "1" ]; then
	ssh-add
fi

unset SSH_AGENT_ENV
# /=== SSH agent
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
[ -f "$HOME"/.secrets ] && . "$HOME"/.secrets
[ -f "$HOME"/.shrc ] && . "$HOME"/.shrc

# zsh specific functions

# Set terminal tab title
function term_title(){
	printf "\e]1;$1\a"
}
