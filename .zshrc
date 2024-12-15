# .zshrc
# ----------------------------------------------------------------------------
export EDITOR="vim"
export VISUAL="vim"

# ----------------------------------------------------------------------------
# Path
# ----------------------------------------------------------------------------
OS=$(uname)

if [ "$OS" = "Darwin" ]; then
	# Homebrew
	[ -d "/opt/homebrew" ] && PATH="$PATH":/opt/homebrew/bin

	# MacPorts
	[ -d "/opt/local/bin" ] && PATH="$PATH":/opt/local/bin
	# local installation
	[ -d "$HOME/ports" ] && PATH="$PATH":"$HOME"/ports/bin

	# Local docker installation
	[ -d "$HOME/.docker/bin" ] && PATH="$PATH":"$HOME"/.docker/bin

	# Open man page in Preview app.
	function man_preview(){
		mandoc -T pdf "$(/usr/bin/man -w $@)" | open -fa Preview
	}

	# Open man page in separate yellow terminal window.
	function xman(){
		# If more than one arg, then assume the first arg is the section.
		if [ ! -z "$2" ]; then
			section="$1"
			shift
			open x-man-page://$section/$@
		else
			open x-man-page://$@
		fi
	}
fi

[ -d "$HOME/bin" ] && PATH="$PATH":"$HOME/bin"

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
# Aliases
# ----------------------------------------------------------------------------
alias ls="ls --color=always"
alias ll="ls --color=always -oh"
alias la="ls --color=always -oha"
alias tree="tree -C"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------
# POSIX/ Bourne Shell compatible
[ -f "$HOME"/.secrets ] && . "$HOME"/.secrets
[ -f "$HOME"/.sh_functions ] && . "$HOME"/.sh_functions

# zsh specific functions

# Set terminal tab title
function term_title(){
	printf "\e]1;$1\a"
}
