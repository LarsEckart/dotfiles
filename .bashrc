# Nothing to see here — Everything's in .bash_profile
[ -n "$PS1" ] && source ~/.bash_profile

# added by travis gem
[ -f /Users/larse/.travis/travis.sh ] && source /Users/larse/.travis/travis.sh

# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=/Users/lars/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;