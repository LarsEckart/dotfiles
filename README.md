# Dotfiles

### Installation

Quick installation guide, backs up original dot files and stores them out of the way in a git ignored directory.

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
mv ~/.bash_profile ~/.dotfiles/backups/
mv ~/.bashrc ~/.dotfiles/backups/
mv ~/.gitconfig ~/.dotfiles/backups/
ln -s ~/.bash_profile ~/.dotfiles/.bash_profile 
ln -s ~/.bashrc ~/.dotfiles/.bashrc 
ln -s ~/.gitconfig ~/.dotfiles/.gitconfig 
ln -s ~/.hushlogin ~/.dotfiles/.hushlogin 
ln -s ~/.dotfiles/z.sh ~/.z.sh
```

