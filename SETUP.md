# Setup Guide (new Mac)

Use this when setting up a new machine with these dotfiles.

## 1) Clone and bootstrap

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

What this does:
- installs Homebrew (if missing)
- installs packages from `Brewfile`
- runs `make install` (symlinks/config)

## 2) Optional: apply macOS defaults

```bash
make setup-macos
```

> This applies opinionated system settings from `scripts/mac-setup.sh`.

## 3) Manual follow-up

### 3.1 Secrets

Create local secrets file (loaded by `shell/.zshenv`):

```bash
$EDITOR ~/.dotfiles/shell/.secrets
```

Add the env vars you need (tokens, API keys, etc.).

### 3.2 Git / GitHub auth

```bash
gh auth login
```

If needed, generate/add SSH keys to GitHub:
- https://docs.github.com/en/authentication/connecting-to-github-with-ssh

### 3.3 Git identities

This repo uses conditional git config:
- personal identity by default
- work identity for repos under `~/work/`

## 4) Verify setup

```bash
zsh --version
git --version
brew --version
rg --version
fd --version
fzf --version
tmux -V
```

Check symlinked configs:

```bash
ls -l ~/.zshrc ~/.gitconfig ~/.hushlogin
ls -l ~/.config/ghostty/config ~/.config/tmux/tmux.conf
```

## 5) Maintenance

Install/update declared Homebrew deps:

```bash
make brew-install
```

Update all Homebrew packages:

```bash
make brew-update
```
