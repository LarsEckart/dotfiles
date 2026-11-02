#!/usr/bin/env zsh

# This file is sourced by all ZSH processes (interactive and non-interactive)
# and is also read by macOS for GUI applications.
# Use this for environment variables that need to be available everywhere.

# Export every assignment in .secrets without changing the caller’s shell options.
if [[ -r "$HOME/.dotfiles/shell/.secrets" && -f "$HOME/.dotfiles/shell/.secrets" ]]; then
  () {
    setopt localoptions allexport
    source "$HOME/.dotfiles/shell/.secrets"
  }
fi
