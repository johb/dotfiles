# .bashrc
# ----------------------------------------------------------------------------
# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# source generic sh config
[ -f "$HOME"/.shrc ] && . "$HOME"/.shrc
# ----------------------------------------------------------------------------
# Env
# ----------------------------------------------------------------------------
#export FZF_DEFAULT_OPTS='--color=fg:#d0d0d0,bg:#121212,hl:#5f87af
#			--color=fg+:black,bg+:208,hl+:#5fd7ff
#			--color=info:#afaf87,prompt:208,pointer:#af5fff
#			--color=marker:#87ff00,spinner:#af5fff,header:#87afaf'
# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------

# Bash specific functions

# ----------------------------------------------------------------------------
# History
# ----------------------------------------------------------------------------
# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# Append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000
# ----------------------------------------------------------------------------
# Prompt
# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
# Prompt
# ----------------------------------------------------------------------------

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

kube_context() {
	command -v kubectl >/dev/null 2>&1 || return 0

	local ctx
	ctx="$(kubectl config current-context 2>/dev/null)" || return 0
	[ -n "$ctx" ] || return 0

	printf "[⎈ %s]" "$ctx"
}

git_branch() {
	command -v git >/dev/null 2>&1 || return 0

	local branch dirty

	# normal branch
	branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null)"

	# detached HEAD fallback
	if [ -z "$branch" ]; then
		branch="$(git rev-parse --short HEAD 2>/dev/null)" || return 0
		branch="detached:${branch}"
	fi

	# dirty working tree
	git diff --quiet --ignore-submodules HEAD 2>/dev/null
	[ "$?" != "0" ] && dirty='*'

	printf "[⎇  %s%s]" "$branch" "$dirty"
}

ssh_context() {
	[[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" ]] || return 0

	printf "[ssh:%s]" "$(hostname -s)"
}

prompt_char() {
	if [ "$EUID" = "0" ]; then
		printf "#"
	else
		printf "$"
	fi
}

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		color_prompt=yes
	else
		color_prompt=
	fi
fi

# ----------------------------------------------------------------------------
# Farben (einmalig definieren)
# ----------------------------------------------------------------------------
C_RESET='\[\e[0m\]'
C_OK='\[\e[32m\]'
C_ERROR='\[\e[31m\]'
C_WARN='\[\e[33m\]'
C_INFO='\[\e[34m\]'
C_HILITE='\[\e[36m\]'
C_DIM='\[\e[90m\]'

# ----------------------------------------------------------------------------
# Prompt
# ----------------------------------------------------------------------------
__build_prompt() {
	local exit_code=$?

	PS1='\n'

	# Exit-Code nur bei Fehler anzeigen
	if [ "$exit_code" != "0" ]; then
		PS1+="${C_ERROR}↪[${exit_code}]${C_RESET} "
	fi

	# user@host
	PS1+="${C_INFO}\u@\h${C_RESET}"

	# working dir
	PS1+=":${C_HILITE}\w${C_RESET}"

	# more contexts
	PS1+=" \$(ssh_context)"
	PS1+=" \$(kube_context)"

	# git branch
	PS1+=" ${C_WARN}\$(git_branch)${C_RESET}"

	PS1+='\n'
	PS1+="\$(prompt_char) "
}

PROMPT_COMMAND="__build_prompt${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

#TODO
if [ "$color_prompt" = "yes" ]; then
	true
else
	PS1='\n''$(prompt_exit_code $?) ''$(ssh_context) ''$(kube_context) ''$(git_branch)\n''${debian_chroot:+($debian_chroot)}\u@\h:\w\n''$(prompt_char) '
fi

unset color_prompt force_color_prompt
# ----------------------------------------------------------------------------
# SSH agent
# ----------------------------------------------------------------------------

# === SSH agent
SSH_AGENT_ENV="$HOME"/.ssh/agent.env

ssh_agent_load_env() {
	test -f "$SSH_AGENT_ENV" && . "$SSH_AGENT_ENV" >|/dev/null
}

ssh_agent_start() {
	(
		umask 077
		ssh-agent >|"$SSH_AGENT_ENV"
	)
	. "$SSH_AGENT_ENV" >|/dev/null
}

ssh_agent_load_env

# ssh_agent_run_state:
# 0=running with key; 1=running without key; 2=agent not working
SSH_AGENT_RUNNING_STATE=$(
	ssh-add -l >|/dev/null 2>&1
	echo $?
)

if [ ! "$SSH_AUTH_SOCK" ] || [ "$SSH_AGENT_RUNNING_STATE" = "2" ]; then
	ssh_agent_start
	ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ "$SSH_AGENT_RUNNING_STATE" = "1" ]; then
	ssh-add
fi

unset SSH_AGENT_ENV
