# ~/.profile

# Avoid re-sourcing
[ -n "$PROFILE_LOADED" ] && return
export PROFILE_LOADED=1

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# -- Default tools
export EDITOR="vi"
export VISUAL="vi"
export PAGER="less"

if [ -z "$EDITOR" ] && command -v vim >/dev/null 2>&1; then
    export EDITOR=vim
    export VISUAL=vim
fi

# if running bash, then .profile loads .bashrc
# if running zsh, .zprofile sources .profile
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
