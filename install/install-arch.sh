#!/usr/bin/env bash

# Install Arch Linux-specific dotfiles (designed to work with omarchy)

echo "Installing Arch Linux-specific dotfiles..."

# First install shared configurations
./install-shared.sh

# Create backup directory
mkdir -p ~/.dotfiles/backups

# Note: On Arch with omarchy, we don't replace the main shell config
# Instead, we provide complementary configurations

echo "Setting up Arch Linux complementary configurations..."

# Create a custom bashrc extension that can be sourced by omarchy
ln -sf ~/.dotfiles/arch/shell/.bashrc ~/.bashrc_dotfiles
ln -sf ~/.dotfiles/arch/shell/.bash_exports ~/.bash_exports_dotfiles
ln -sf ~/.dotfiles/arch/shell/.bash_functions ~/.bash_functions_dotfiles

# Shared shell configurations
ln -sf ~/.dotfiles/shared/shell/.aliases ~/.aliases
ln -sf ~/.dotfiles/shared/shell/.exports ~/.exports  
ln -sf ~/.dotfiles/shared/shell/.functions ~/.functions

echo "Arch Linux dotfiles installation complete!"
echo ""
echo "Next steps for Arch Linux with omarchy:"
echo "1. Add this line to your ~/.bashrc or omarchy config to source dotfiles:"
echo "   [ -f ~/.bashrc_dotfiles ] && source ~/.bashrc_dotfiles"
echo "2. Or manually source: source ~/.bashrc_dotfiles"
echo "3. The dotfiles work alongside omarchy's configuration"
echo "4. Restart your terminal or source the configuration"