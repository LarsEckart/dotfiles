#!/usr/bin/env bash

# Install macOS-specific dotfiles

echo "Installing macOS-specific dotfiles..."

# First install shared configurations
./install-shared.sh

# Create backup directory
mkdir -p ~/.dotfiles/backups

# Backup existing shell files
for file in ~/.zshrc ~/.zsh_exports ~/.zsh_functions ~/.zsh_prompt; do
    if [ -f "$file" ]; then
        echo "Backing up $file"
        mv "$file" ~/.dotfiles/backups/ 2>/dev/null || true
    fi
done

# Create symlinks for macOS shell configuration
echo "Creating symlinks for macOS shell configuration..."
ln -sf ~/.dotfiles/macos/shell/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/macos/shell/.zsh_exports ~/.zsh_exports
ln -sf ~/.dotfiles/macos/shell/.zsh_functions ~/.zsh_functions
ln -sf ~/.dotfiles/macos/shell/.zsh_prompt ~/.zsh_prompt

# Shared shell configurations (sourced by .zshrc)
ln -sf ~/.dotfiles/shared/shell/.aliases ~/.aliases
ln -sf ~/.dotfiles/shared/shell/.exports ~/.exports
ln -sf ~/.dotfiles/shared/shell/.functions ~/.functions

# Zed configuration
echo "Setting up Zed configuration..."
mkdir -p ~/.config/zed/themes
ln -sf ~/.dotfiles/macos/zed/settings.json ~/.config/zed/settings.json
ln -sf ~/.dotfiles/macos/zed/theme.json ~/.config/zed/themes/Casablanca.json

echo "macOS dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run 'source ~/.zshrc'"
echo "2. Run the macOS setup script if needed: ~/.dotfiles/macos/scripts/mac-setup.sh"
echo "3. Install Homebrew packages: ~/.dotfiles/macos/scripts/brew-install.sh"