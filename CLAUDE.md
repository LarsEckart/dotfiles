# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a personal dotfiles repository organized into logical folders:

- **shell/**: ZSH configuration files (.zshrc, .zsh_exports, .zsh_functions, .zsh_prompt, .aliases, .exports, .functions)
- **git/**: Git configuration files (.gitconfig, .gitconfig-personal, .gitconfig-work, .gitattributes, .gitignore_global)
- **scripts/**: Setup and utility scripts (mac-setup.sh, brew.sh, curltime.sh)
- **githooks/**: Global git hooks (prepare-commit-msg, pre-commit)
- **tuple-triggers/**: Tuple collaboration utilities
- **zed/**: Zed editor configuration (settings.json, theme.json)

## Installation and Setup

The repository uses symbolic links to connect dotfiles to their expected locations in the home directory. The installation process is documented in README.md and involves:

1. Cloning the repository to `~/.dotfiles`
2. Creating backups of existing dotfiles
3. Creating symbolic links from home directory to the organized structure

Key symlink commands:
```bash
ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/zed/settings.json ~/.config/zed/settings.json
ln -s ~/.dotfiles/zed/theme.json ~/.config/zed/themes/Casablanca.json
```

## Git Configuration

The git setup uses conditional includes for multiple identities:
- `.gitconfig-personal`: Personal GitHub identity with GPG signing via 1Password
- `.gitconfig-work`: Work identity with custom SSH configuration
- Global git hooks in `githooks/` directory are referenced via `core.hooksPath`

The prepare-commit-msg hook automatically extracts ticket numbers from branch names and prepends them to commit messages.

## Key Features

- **ZSH-only**: All bash configurations have been removed
- **Multi-identity Git**: Automatic switching between personal/work git configurations based on directory
- **GPG Signing**: Uses 1Password for SSH-based GPG signing
- **Global Git Hooks**: Shared across all repositories
- **macOS Optimization**: Extensive macOS defaults configuration in mac-setup.sh
- **Development Tools**: Comprehensive Homebrew package list for development

## Important Files

- `shell/.zsh_exports`: Environment variables and ZSH history configuration
- `shell/.functions`: Custom shell functions including Docker cleanup, Git utilities
- `git/.gitconfig`: Main git configuration with aliases and settings
- `scripts/mac-setup.sh`: Complete macOS system configuration
- `scripts/brew.sh`: Development tool installation via Homebrew
- `zed/settings.json`: Zed editor settings with JetBrains keymap and custom theme
- `zed/theme.json`: Custom Casablanca dark theme for Zed

When modifying symlinks or file paths, ensure the git configuration paths in `.gitconfig` are updated to match the new structure.