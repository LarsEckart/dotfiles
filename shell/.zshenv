#!/usr/bin/env zsh

# This file is sourced by all ZSH processes (interactive and non-interactive)
# and is also read by macOS for GUI applications.
# Use this for environment variables that need to be available everywhere.

# Source secrets for all processes (including GUI apps like Claude Code)
[ -r "$HOME/.dotfiles/shell/.secrets" ] && [ -f "$HOME/.dotfiles/shell/.secrets" ] && source "$HOME/.dotfiles/shell/.secrets"
