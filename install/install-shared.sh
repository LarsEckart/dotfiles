#!/usr/bin/env bash

# Install shared dotfiles (cross-platform)

echo "Installing shared dotfiles..."

# Create backup directory
mkdir -p ~/.dotfiles/backups

# Backup existing files
for file in ~/.gitconfig ~/.gitattributes ~/.gitignore_global ~/.vimrc ~/.hushlogin; do
    if [ -f "$file" ]; then
        echo "Backing up $file"
        mv "$file" ~/.dotfiles/backups/ 2>/dev/null || true
    fi
done

# Create symlinks for shared configurations
echo "Creating symlinks for shared configurations..."

# Git configuration
ln -sf ~/.dotfiles/shared/git/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/shared/git/.gitattributes ~/.gitattributes
ln -sf ~/.dotfiles/shared/git/.gitignore_global ~/.gitignore_global

# Vim configuration
ln -sf ~/.dotfiles/shared/shell/.vimrc ~/.vimrc

# Other shared files
ln -sf ~/.dotfiles/shared/.hushlogin ~/.hushlogin

# Claude Code configuration
mkdir -p ~/.claude
ln -sf ~/.dotfiles/shared/claude-code/settings.json ~/.claude/settings.json
ln -sf ~/.dotfiles/shared/claude-code/settings.local.json ~/.claude/settings.local.json
ln -sf ~/.dotfiles/shared/claude-code/mcp_servers.json ~/.claude/mcp_servers.json
ln -sf ~/.dotfiles/shared/claude-code/CLAUDE.md ~/.claude/CLAUDE.md

echo "Shared dotfiles installation complete!"