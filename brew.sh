#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew install bash-completion2


# Switch to using brew-installed bash as default shell
# if ! fgrep -q '/opt/homebrew/bin/bash' /etc/shells; then
#   echo '/opt/homebrew/bin/bash' | sudo tee -a /etc/shells;
#   chsh -s /opt/homebrew/bin/bash;
# fi;

brew install heroku/brew/heroku

brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gnupg
brew install pinentry-mac

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh
brew install openssl

# Install other useful binaries.
brew install less
brew install make
brew install nano
brew install perl
brew install rsync
brew install unzip
brew install ripgrep
brew install git
brew install curl
brew install jq
brew install gradle
brew tap gdubw/gng
brew install gng
brew install maven
brew install htop
brew install hadolint   # Haskell Dockerfile Linter
brew install telnet
brew install hugo
brew install bat # better cat
brew install exa # better ls
brew install nmap  # nmap -F 192.168.1.1
brew install yamllint
brew install vale
brew install tree
brew install gping
brew install scc

brew tap wagoodman/dive
brew install dive

brew tap jesseduffield/lazydocker
brew install lazydocker

brew install remotemobprogramming/brew/mob

#brew install ffmpeg --with-libvpx


# Apps

# brew install --cask rectangle
# brew install --cask maccy
# brew install --cask iterm2
# brew install --cask fork
# brew install --cask jetbrains-toolbox
# brew install --cask visual-studio-code
# brew install --cask the-unarchiver
# brew install --cask firefox
# brew install --cask anydesk
# brew install --cask cakebrew
# brew install --cask gpg-suite
#brew install --cask jdiskreport
# brew install --cask obs
# brew install --cask techsmith-capture
# brew install --cask boop


# Remove outdated versions from the cellar including casks
brew cleanup
