#!/usr/bin/env bash

# Mark that .bashrc has been loaded to prevent double-loading
export BASH_PROFILE_LOADED=1

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shared dotfiles first
for file in ~/.dotfiles/shared/shell/.{aliases,exports,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

# Load Arch Linux-specific dotfiles
for file in ~/.dotfiles/arch/shell/.{bash_exports,bash_functions,secrets}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Bash history configuration
export HISTFILE=~/.bash_history
export HISTCONTROL=ignoreboth  # Ignore lines starting with space and duplicates
export HISTAPPEND=true         # Append to history file, don't overwrite
shopt -s histappend            # Append to history file rather than overwriting it

# Bash options
shopt -s checkwinsize          # Check window size after each command
shopt -s globstar              # Enable ** for recursive globbing
shopt -s cdspell               # Correct minor spelling errors in cd commands
shopt -s dirspell              # Correct minor spelling errors in directory names

# Git branch in prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Custom prompt with git branch
export PS1='\[\033[32m\]\t\[\033[m\] \[\033[34m\]\w\[\033[31m\]$(parse_git_branch)\[\033[m\] \$ '

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh