#!/usr/bin/env zsh

# Mark that .zshrc has been loaded to prevent double-loading
export ZSH_PROFILE_LOADED=1

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
# for file in ~/.dotfiles/.{aliases,zsh_exports,zsh_functions,work,secrets}; do
for file in ~/.dotfiles/shell/.{aliases,zsh_exports,zsh_functions,secrets}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Zsh options (equivalent to bash shopt)
setopt HIST_APPEND            # Append to history file, rather than overwriting it
setopt CORRECT                # Autocorrect typos in path names when using cd
setopt AUTO_CD                # Auto cd when entering just a path
setopt EXTENDED_GLOB          # Extended globbing (equivalent to bash globstar)

# Enable zsh completion system with caching
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

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

# source nvm (immediate loading)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Add rbenv to PATH (lazy loaded)
export PATH="$HOME/.rbenv/bin:$PATH"
rbenv() {
    unset -f rbenv
    eval "$(rbenv init - zsh)"
    rbenv "$@"
}
ruby() {
    unset -f ruby
    eval "$(rbenv init - zsh)"
    ruby "$@"
}
gem() {
    unset -f gem
    eval "$(rbenv init - zsh)"
    gem "$@"
}
bundle() {
    unset -f bundle
    eval "$(rbenv init - zsh)"
    bundle "$@"
}

# so that I use brew installed curl and not the system one
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

# Setting PATH for Python 3.13
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
export PATH

# Added by Windsurf
export PATH="/Users/lars/.codeium/windsurf/bin:$PATH"

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/lars/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

# Cargo environment
. "$HOME/.cargo/env"


# Load Angular CLI autocompletion (lazy loaded)
ng() {
    unset -f ng
    source <(ng completion script)
    ng "$@"
}
