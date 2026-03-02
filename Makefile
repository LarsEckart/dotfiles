.PHONY: install install-zsh install-zed install-ghostty install-tmux install-starship install-githooks install-misc install-scripts-bin backup-existing restore-backup clean uninstall setup-macos brew-install brew-update
DOTFILES_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
BREWFILE ?= $(DOTFILES_DIR)/Brewfile

install: install-zsh install-zed install-ghostty install-tmux install-starship install-githooks install-misc

backup-existing:
	@echo "Creating backups of existing dotfiles..."
	@test -f ~/.zshrc && cp ~/.zshrc ~/.zshrc.backup || true
	@test -f ~/.vimrc && cp ~/.vimrc ~/.vimrc.backup || true
	@test -f ~/.hushlogin && cp ~/.hushlogin ~/.hushlogin.backup || true
	@test -d ~/.config/zed && cp -r ~/.config/zed ~/.config/zed.backup || true

install-zsh: backup-existing
	@echo "Installing ZSH configuration..."
	@ln -sf ~/.dotfiles/shell/.zshrc ~/.zshrc
	@ln -sf ~/.dotfiles/shell/.zsh_exports ~/.zsh_exports
	@ln -sf ~/.dotfiles/shell/.zsh_functions ~/.zsh_functions
	@ln -sf ~/.dotfiles/shell/.aliases ~/.aliases

install-zed:
	@echo "Installing Zed configuration..."
	@mkdir -p ~/.config/zed/themes
	@ln -sf ~/.dotfiles/zed/settings.json ~/.config/zed/settings.json
	@ln -sf ~/.dotfiles/zed/themes/Casablanca.json ~/.config/zed/themes/Casablanca.json
	@ln -sf ~/.dotfiles/zed/themes/NeoSolarized.json ~/.config/zed/themes/NeoSolarized.json
	@ln -sf ~/.dotfiles/zed/themes/Github\ Theme.json ~/.config/zed/themes/Github\ Theme.json
	@ln -sf ~/.dotfiles/zed/themes/macOS\ Classic.json ~/.config/zed/themes/macOS\ Classic.json

install-ghostty:
	@echo "Installing Ghostty configuration..."
	@mkdir -p ~/.config/ghostty
	@ln -sf ~/.dotfiles/ghostty/ghostty.conf ~/.config/ghostty/config

install-tmux:
	@echo "Installing tmux configuration..."
	@mkdir -p ~/.config/tmux
	@ln -sf ~/.dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf

install-starship:
	@echo "Installing Starship configuration..."
	@mkdir -p ~/.config
	@ln -sf ~/.dotfiles/starship/starship.toml ~/.config/starship.toml

install-githooks:
	@echo "Installing global git hooks..."
	@chmod +x ~/.dotfiles/githooks/*
	@git config --global core.hooksPath ~/.dotfiles/githooks

install-misc:
	@echo "Installing misc dotfiles..."
	@ln -sf ~/.dotfiles/.vimrc ~/.vimrc
	@ln -sf ~/.dotfiles/.hushlogin ~/.hushlogin

restore-backup:
	@echo "Restoring backups..."
	@test -f ~/.zshrc.backup && mv ~/.zshrc.backup ~/.zshrc || true
	@test -f ~/.vimrc.backup && mv ~/.vimrc.backup ~/.vimrc || true
	@test -f ~/.hushlogin.backup && mv ~/.hushlogin.backup ~/.hushlogin || true
	@test -d ~/.config/zed.backup && rm -rf ~/.config/zed && mv ~/.config/zed.backup ~/.config/zed || true

clean:
	@echo "Removing symlinks..."
	@rm -f ~/.zshrc ~/.zsh_exports ~/.zsh_functions ~/.aliases
	@rm -f ~/.vimrc ~/.hushlogin
	@rm -f ~/.config/zed/settings.json ~/.config/zed/themes/Casablanca.json ~/.config/zed/themes/NeoSolarized.json ~/.config/zed/themes/Github\ Theme.json ~/.config/zed/themes/macOS\ Classic.json
	@rm -f ~/.config/ghostty/config
	@rm -f ~/.config/tmux/tmux.conf
	@rm -f ~/.config/starship.toml
	@echo "Use 'make restore-backup' to restore original files"

uninstall: clean restore-backup

setup-macos:
	@echo "Running macOS setup..."
	@chmod +x ~/.dotfiles/scripts/mac-setup.sh
	@~/.dotfiles/scripts/mac-setup.sh

brew-install:
	@echo "Installing Homebrew packages from Brewfile..."
	@brew bundle --file "$(BREWFILE)"

brew-update:
	@echo "Updating Homebrew packages..."
	@brew update
	@brew upgrade
	@brew cleanup

install-scripts-bin:
	@echo "Installing scripts to /usr/local/bin..."
	@chmod +x ~/.dotfiles/scripts/*
	@sudo ln -sf ~/.dotfiles/scripts/bumbailiff /usr/local/bin/bumbailiff
	@sudo ln -sf ~/.dotfiles/scripts/curltime.sh /usr/local/bin/curltime
	@sudo ln -sf ~/.dotfiles/scripts/next-version.sh /usr/local/bin/next-version
