# Nothing to see here — Everything's in .bash_profile
# Only source .bash_profile if it hasn't been sourced already to prevent double-loading
if [[ -n "$PS1" && -z "$BASH_PROFILE_LOADED" ]]; then
	source ~/.bash_profile
fi

# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=/Users/lars/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;
. "$HOME/.cargo/env"



# case insensitive bash completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
