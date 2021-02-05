# Dotfiles

### Installation

Quick installation guide, backs up original dot files and stores them out of the way in a git ignored directory.

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
mv ~/.bash_profile ~/.dotfiles/backups/
mv ~/.bashrc ~/.dotfiles/backups/
mv ~/.gitconfig ~/.dotfiles/backups/
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.gitattributes ~/.gitattributes
ln -s ~/.dotfiles/.gitignore_global ~/.gitignore_global 
ln -s ~/.dotfiles/.hushlogin ~/.hushlogin 
ln -s ~/.dotfiles/.vimrc ~/.vimrc
```

### System Preferences

#### Dock

Position on screen: right
- [x] Automatically hide and show the dock

#### Keyboard

- [x] Use F1, F2, etc keys as standard function keys

#### Trackpad

- [x] Tap to click
- [ ] Scroll direction: Natural


### Applications
* brew
* Jetbrains Toolbox
* [Rectangle](https://github.com/rxhanson/Rectangle)
* [iTerm2](https://iterm2.com/)
* [Fork](https://git-fork.com/)
* Flycut ? or [maccy](https://maccy.app/)


### Fonts

* Jetbrains Mono
