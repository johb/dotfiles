# .bashrc
# ----------------------------------------------------------------------------
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# source generic sh config
[ -f "$HOME"/.shrc ] && . "$HOME"/.shrc

# ----------------------------------------------------------------------------
# Env
# ----------------------------------------------------------------------------

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
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
	FG_RED='\[\033[01;31m\]'
	FG_GREEN='\[\033[01;32m\]'
	FG_RESET='\[\033[00m\]'
	FG_BLUE='\[\033[01;34m\]'
	#PS1='\n\[\033[01;31m\]${?##0}\n${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	PS1='\n'${FG_RED}'${?##0}\n${debian_chroot:+($debian_chroot)}'${FG_GREEN}'\u@\h'${FG_RESET}':'${FG_BLUE}'\w'${FG_RESET}'\n\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# ----------------------------------------------------------------------------
# SSH agent
# ----------------------------------------------------------------------------
=======
if type vim > /dev/null 2>&1; then
	export EDITOR="vim"
	export VISUAL="vim"
fi


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

if [ ! "$SSH_AUTH_SOCK" ] || [ "$SSH_AGENT_RUNNING_STATE" = "2" ]; then
	ssh_agent_start
	ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ "$SSH_AGENT_RUNNING_STATE" = "1" ]; then
	ssh-add
fi

unset SSH_AGENT_ENV
