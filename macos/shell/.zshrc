#!/usr/bin/env zsh

# Mark that .zshrc has been loaded to prevent double-loading
export ZSH_PROFILE_LOADED=1

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shared dotfiles first
for file in ~/.dotfiles/shared/shell/.{aliases,exports,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

# Load macOS-specific dotfiles
for file in ~/.dotfiles/macos/shell/.{zsh_exports,zsh_functions,secrets}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Zsh options (equivalent to bash shopt)
setopt HIST_APPEND            # Append to history file, rather than overwriting it
setopt CORRECT                # Autocorrect typos in path names when using cd
setopt AUTO_CD                # Auto cd when entering just a path
setopt EXTENDED_GLOB          # Extended globbing (equivalent to bash globstar)

# Enable zsh completion system
autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# from https://dev.to/cassidoo/customizing-my-zsh-prompt-3417
autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && _ssh_config=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p' | grep -v '[?*]')) && zstyle ':completion:*:*:ssh:*:hosts' hosts $_ssh_config