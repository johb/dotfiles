# Dotfiles repository

Git working and config directories are kept separate:

- git directory is `$HOME/.dotfiles`
- working directory is $HOME

This makes linking dotfiles not necessary. The alias dotfiles (for `git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME`) makes the management more comfortable.

## Installation

__To avoid problems when checking dotfiles out after cloning, backup and remove all existing dotfiles!__

```sh
alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
git clone --bare https://github.com/johb/dotfiles.git $HOME/.dotfiles
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
```
