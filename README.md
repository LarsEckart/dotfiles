# Dotfiles

### Installation

Quick installation guide, backs up original dot files and stores them out of the way in a git ignored directory.

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
mkdir -p ~/.dotfiles/backups

# Backup existing files
mv ~/.gitconfig ~/.dotfiles/backups/ 2>/dev/null || true

# Shell configuration (ZSH)
ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc
ln -s ~/.dotfiles/shell/.zsh_exports ~/.zsh_exports
ln -s ~/.dotfiles/shell/.zsh_functions ~/.zsh_functions
ln -s ~/.dotfiles/shell/.zsh_prompt ~/.zsh_prompt
ln -s ~/.dotfiles/shell/.aliases ~/.aliases
ln -s ~/.dotfiles/shell/.exports ~/.exports
ln -s ~/.dotfiles/shell/.functions ~/.functions

# Git configuration
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/git/.gitattributes ~/.gitattributes
ln -s ~/.dotfiles/git/.gitignore_global ~/.gitignore_global

# Other dotfiles
ln -s ~/.dotfiles/.hushlogin ~/.hushlogin
ln -s ~/.dotfiles/.vimrc ~/.vimrc
```

Setup for multiple git identities is also described [here](https://garrit.xyz/posts/2023-10-13-organizing-multiple-git-identities).

### Fonts

* Jetbrains Mono

### Others

* [Generate a ssh key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
* Generate gpg key (update gpg and install pinentry-mac through brew, [do after install](https://www.reddit.com/r/emacs/comments/fe165f/pinentry_problems_in_osx/fjlpkqv/?utm_source=reddit&utm_medium=web2x&context=3) do `gpgconf --kill gpg-agent` at the very end
* Paste and match style: https://twitter.com/_overment/status/1627917465295507456
