# .zshrc
# ----------------------------------------------------------------------------
[ -f "$HOME/.shrc" ] && . "$HOME/.shrc"

bindkey -e

bindkey '^[[5~' backward-word
bindkey '^[[6~' forward-word
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

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

# Edit commands with vim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# kubectl
if command -v kubectl >/dev/null 2>&1; then
	source <(kubectl completion zsh)
	alias k=kubectl
fi
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

# Show the same Git status as Bash (including detached HEAD and tracked changes).
zsh_git_branch() {
	command -v git >/dev/null 2>&1 || return 0

	local branch dirty=''
	branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null)"
	if [ -z "$branch" ]; then
		branch="$(git rev-parse --short HEAD 2>/dev/null)" || return 0
		branch="detached:$branch"
	fi

	git diff --quiet --ignore-submodules HEAD 2>/dev/null || dirty='*'

	# Escape percent signs so branch names cannot inject Zsh prompt sequences.
	branch="${branch//[%]/%%}"
	printf ' [⎇  %s%s]' "$branch" "$dirty"
}

# Display the configured Kubernetes context, without contacting the cluster.
zsh_kube_context() {
	command -v kubectl >/dev/null 2>&1 || return 0

	local ctx
	ctx="$(kubectl config current-context 2>/dev/null)" || return 0
	[ -n "$ctx" ] || return 0

	ctx="${ctx//[%]/%%}"
	printf ' [⎈ %s]' "$ctx"
}

# Evaluate status helpers for every prompt, not only when the shell starts.
setopt PROMPT_SUBST
PS1='%B%F{blue}%n@%m%f:%F{cyan}%1~%b%f$(zsh_kube_context)%F{yellow}$(zsh_git_branch)%f
%(!.#.$) '
RPROMPT="$returncode"
# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------
# zsh specific functions

# Set terminal tab title
function term_title(){
	printf "\e]1;$1\a"
}
# ----------------------------------------------------------------------------
# SSH agent
# ----------------------------------------------------------------------------
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

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/johb/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
