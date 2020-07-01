#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

brew install heroku/brew/heroku

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh

# Install other useful binaries.
brew install ack
brew install git
brew install jq
brew install tree
brew install zopfli
brew install gradle
brew install gdub
brew install maven
brew install ant
brew install unrar
brew install p7zip
brew install terraform
brew install cfssl
brew install tmux
brew install htop
brew install ngrep
brew install hostess
brew install hadolint
brew install telnet
brew install rbenv
brew install ruby-build
brew install node
brew install n
brew install hugo
brew install fswatch
brew install bat
brew install exa
brew install nmap  # nmap -F 192.168.1.1
brew install golang
brew install python
brew install yamllint

brew tap wagoodman/dive
brew install dive

brew tap jesseduffield/lazydocker
brew install lazydocker

# Remove outdated versions from the cellar.
brew cleanup
