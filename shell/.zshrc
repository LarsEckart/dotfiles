#!/usr/bin/env zsh

# Mark that .zshrc has been loaded to prevent double-loading
export ZSH_PROFILE_LOADED=1

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
# Note: .secrets is sourced in .zshenv for GUI app access
for file in ~/.dotfiles/shell/.{aliases,zsh_exports,zsh_functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Zsh options (equivalent to bash shopt)
# Note: INC_APPEND_HISTORY in .zsh_exports handles appending (writes each command immediately)
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


# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && _ssh_config=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p' | grep -v '[?*]')) && zstyle ':completion:*:*:ssh:*:hosts' hosts $_ssh_config

# source nvm (lazy loaded for faster shell startup)
export NVM_DIR="$HOME/.nvm"
# Add default Node's bin to PATH so global packages work before nvm loads
if [[ -f "$NVM_DIR/alias/default" ]]; then
    _nvm_default=$(command cat "$NVM_DIR/alias/default")
    _nvm_node_path=$(command ls -d "$NVM_DIR/versions/node/v${_nvm_default}"* 2>/dev/null | command tail -1)
    [[ -d "$_nvm_node_path" ]] && export PATH="$_nvm_node_path/bin:$PATH"
    unset _nvm_default _nvm_node_path
fi
nvm() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}
node() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    node "$@"
}
npm() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm "$@"
}
npx() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npx "$@"
}

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

# Setting PATH for Python 3.13
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
export PATH


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

# opencode
export PATH=/Users/lars/.opencode/bin:$PATH

# try - experiment manager (location set via TRY_PATH in .zsh_exports)
eval "$(try init)"

eval "$(starship init zsh)"

# bun completions
[ -s "/Users/lars/.bun/_bun" ] && source "/Users/lars/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
