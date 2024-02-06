# Dotfiles

### Installation

Quick installation guide, backs up original dot files and stores them out of the way in a git ignored directory.

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
mv ~/.bash_profile ~/.dotfiles/backups/
mv ~/.bashrc ~/.dotfiles/backups/
mv ~/.gitconfig ~/.dotfiles/backups/
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.bash_logout ~/.bash_logout
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.gitattributes ~/.gitattributes
ln -s ~/.dotfiles/.gitignore_global ~/.gitignore_global 
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
