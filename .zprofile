# ~/.zprofile
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

test -d "$HOME/.docker/bin" && PATH="$PATH:$HOME/.docker/bin"

# -- Default tools
export EDITOR="vi"
export VISUAL="vi"
export PAGER="less"

# -- Use vim if available
if [ -z "$EDITOR" ] && command -v vim >/dev/null 2>&1; then
    export EDITOR=vim
    export VISUAL=vim
fi

if [ -f "$HOME/.zshrc" ]; then
	. "$HOME/.zshrc"
fi
