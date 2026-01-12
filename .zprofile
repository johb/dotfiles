# ~/.zprofile
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# -- Default tools
export EDITOR="vi"
export VISUAL="vi"
export PAGER="less"

if [ -z "$EDITOR" ] && command -v vim >/dev/null 2>&1; then
    export EDITOR=vim
    export VISUAL=vim
fi

if [ -f "$HOME/.zshrc" ]; then
	. "$HOME/.zshrc"
fi
