.PHONY: install install-zsh install-zed install-scripts install-githooks install-misc backup-existing restore-backup clean

install: install-zsh install-zed install-scripts install-githooks install-misc

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
	@ln -sf ~/.dotfiles/shell/.zsh_prompt ~/.zsh_prompt
	@ln -sf ~/.dotfiles/shell/.aliases ~/.aliases

install-zed:
	@echo "Installing Zed configuration..."
	@mkdir -p ~/.config/zed/themes
	@ln -sf ~/.dotfiles/zed/settings.json ~/.config/zed/settings.json
	@ln -sf ~/.dotfiles/zed/theme.json ~/.config/zed/themes/Casablanca.json

install-scripts:
	@echo "Installing scripts..."
	@chmod +x ~/.dotfiles/scripts/*.sh
	@mkdir -p ~/bin
	@ln -sf ~/.dotfiles/scripts/curltime.sh ~/bin/curltime

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
	@rm -f ~/.zshrc ~/.zsh_exports ~/.zsh_functions ~/.zsh_prompt ~/.aliases
	@rm -f ~/.vimrc ~/.hushlogin
	@rm -f ~/.config/zed/settings.json ~/.config/zed/themes/Casablanca.json
	@rm -f ~/bin/curltime
	@echo "Use 'make restore-backup' to restore original files"

uninstall: clean restore-backup

setup-macos:
	@echo "Running macOS setup..."
	@chmod +x ~/.dotfiles/scripts/mac-setup.sh
	@~/.dotfiles/scripts/mac-setup.sh

install-brew:
	@echo "Installing Homebrew packages..."
	@chmod +x ~/.dotfiles/scripts/brew.sh
	@~/.dotfiles/scripts/brew.sh
