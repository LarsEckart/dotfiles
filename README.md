# Dotfiles

### Installation

#### Quick start (recommended)

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

This bootstrap script is idempotent and will:
- install Homebrew if needed
- install/update packages from `Brewfile`
- run `make install`

For a full new-machine checklist, see [SETUP.md](./SETUP.md).

#### Manual install

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
mkdir -p ~/.dotfiles/backups

# Backup existing files
mv ~/.gitconfig ~/.dotfiles/backups/ 2>/dev/null || true

# Shell configuration (ZSH)
ln -s ~/.dotfiles/shell/.zshenv ~/.zshenv
ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc
ln -s ~/.dotfiles/shell/.zsh_exports ~/.zsh_exports
ln -s ~/.dotfiles/shell/.zsh_functions ~/.zsh_functions
ln -s ~/.dotfiles/shell/.aliases ~/.aliases

# Git configuration
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/git/.gitattributes ~/.gitattributes
ln -s ~/.dotfiles/git/.gitignore_global ~/.gitignore_global

# Zed configuration
mkdir -p ~/.config/zed/themes
ln -s ~/.dotfiles/zed/settings.json ~/.config/zed/settings.json
ln -s ~/.dotfiles/zed/themes/Casablanca.json ~/.config/zed/themes/Casablanca.json
ln -s ~/.dotfiles/zed/themes/NeoSolarized.json ~/.config/zed/themes/NeoSolarized.json
ln -s ~/.dotfiles/zed/themes/Github\ Theme.json ~/.config/zed/themes/Github\ Theme.json
ln -s ~/.dotfiles/zed/themes/macOS\ Classic.json ~/.config/zed/themes/macOS\ Classic.json

# Ghostty configuration
mkdir -p ~/.config/ghostty
ln -s ~/.dotfiles/ghostty/ghostty.conf ~/.config/ghostty/config

# tmux configuration
mkdir -p ~/.config/tmux
ln -s ~/.dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf

# Other dotfiles
ln -s ~/.dotfiles/.hushlogin ~/.hushlogin
ln -s ~/.dotfiles/.vimrc ~/.vimrc
```

Or use the Makefile:

```bash
make install          # Install all configurations
make setup-macos      # Run macOS defaults setup
make brew-install     # Install Homebrew packages from Brewfile
```

Setup for multiple git identities is also described [here](https://garrit.xyz/posts/2023-10-13-organizing-multiple-git-identities).

### Fonts

* JetBrains Mono

### Others

* [Generate a ssh key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
* Generate gpg key (update gpg and install pinentry-mac through brew, [do after install](https://www.reddit.com/r/emacs/comments/fe165f/pinentry_problems_in_osx/fjlpkqv/?utm_source=reddit&utm_medium=web2x&context=3) do `gpgconf --kill gpg-agent` at the very end
* Paste and match style: https://twitter.com/_overment/status/1627917465295507456
