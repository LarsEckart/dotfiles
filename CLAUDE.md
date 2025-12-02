# CLAUDE.md

## Repository Structure

This is a personal dotfiles repository organized into logical folders:

- **shell/**: ZSH configuration files (.zshrc, .zsh_exports, .zsh_functions, .aliases, .exports, .functions)
- **git/**: Git configuration files (.gitconfig, .gitconfig-personal, .gitconfig-work, .gitattributes, .gitignore_global)
- **scripts/**: Setup and utility scripts (mac-setup.sh, brew.sh, curltime.sh)
- **githooks/**: Global git hooks (prepare-commit-msg, pre-commit)
- **tuple-triggers/**: Tuple collaboration utilities
- **zed/**: Zed editor configuration (settings.json, theme.json)
- **ghostty/**: Ghostty terminal emulator configuration (ghostty.conf)
- **agents/**: AI coding agent configurations
  - **claude-code/**: Claude Code configurations, commands, and agents
  - **codex/**: OpenAI Codex configurations and prompts
- **speech/**: Text-to-speech integration using ElevenLabs API

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

So when we create new files here, verify if we need to make an update to the `README.md` to symlink the file.


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
- `shell/.zsh_functions`: Custom shell functions including Docker cleanup, Git utilities, text-to-speech
- `git/.gitconfig`: Main git configuration with aliases and settings
- `scripts/mac-setup.sh`: Complete macOS system configuration
- `scripts/brew.sh`: Development tool installation via Homebrew
- `zed/settings.json`: Zed editor settings with JetBrains keymap and custom theme
- `zed/theme.json`: Custom Casablanca dark theme for Zed

When modifying symlinks or file paths, ensure the git configuration paths in `.gitconfig` are updated to match the new structure.

## Claude Code Integration

- **Custom Slash Commands**: The `agents/claude-code/commands/` directory contains custom slash commands
- **Custom Agents**: The `agents/claude-code/agents/` directory contains specialized Claude Code agents for specific workflows
- **Issue Function**: The `issue()` function in `shell/.zsh_functions` creates GitHub issues via Claude Code
- **Known Issues**: Claude Code has a bug with piping input to slash commands - use direct arguments instead of pipes for reliable execution
- **Settings**: Claude Code uses Opus model with specific permissions for Git operations and file system access
