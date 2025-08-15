.PHONY: install install-zsh install-zed install-claude-code install-scripts install-githooks install-misc install-scripts-bin backup-existing restore-backup clean

install: install-zsh install-zed install-claude-code install-scripts install-githooks install-misc

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

install-claude-code:
	@echo "Installing Claude Code commands..."
	@mkdir -p ~/.claude/commands
	@ln -sf ~/.dotfiles/claude-code/commands/* ~/.claude/commands/
	@echo "Installing Claude Code agents..."
	@mkdir -p ~/.claude/agents
	@ln -sf ~/.dotfiles/claude-code/agents/* ~/.claude/agents/

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
	@rm -f ~/.claude/commands/*
	@rm -f ~/.claude/agents/*
	@rm -f ~/bin/curltime
	@echo "Use 'make restore-backup' to restore original files"

uninstall: clean restore-backup

setup-macos:
	@echo "Running macOS setup..."
	@chmod +x ~/.dotfiles/scripts/mac-setup.sh
	@~/.dotfiles/scripts/mac-setup.sh

brew-install:
	@echo "Installing Homebrew packages..."
	@chmod +x ~/.dotfiles/scripts/brew-install.sh
	@~/.dotfiles/scripts/brew-install.sh

brew-update:
	@echo "Updating Homebrew packages..."
	@chmod +x ~/.dotfiles/scripts/brew-update.sh
	@~/.dotfiles/scripts/brew-update.sh

install-scripts-bin:
	@echo "Installing scripts to /usr/local/bin..."
	@chmod +x ~/.dotfiles/scripts/*
	@sudo ln -sf ~/.dotfiles/scripts/bumbailiff /usr/local/bin/bumbailiff
	@sudo ln -sf ~/.dotfiles/scripts/curltime.sh /usr/local/bin/curltime
	@sudo ln -sf ~/.dotfiles/scripts/next-version.sh /usr/local/bin/next-version
