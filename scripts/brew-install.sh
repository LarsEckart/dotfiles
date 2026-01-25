#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Install GNU core utilities and `sed`, overwriting the built-in versions.
brew install coreutils
brew install gnu-sed

brew install heroku/brew/heroku

brew install wget

# Install more recent versions of some macOS tools.
brew install vim
brew install openssh
brew install openssl

# Install other useful binaries.
brew install make
brew install nano
brew install perl
brew install ripgrep
brew install git
brew install curl
brew install jq
brew install gradle
brew tap gdubw/gng
brew install gng
brew install maven
brew install htop

brew install telnet
brew install hugo
brew install bat # better cat
brew install eza # better ls
brew install nmap  # nmap -F 192.168.1.1
brew install yamllint
brew install vale
brew install tree
brew install gping
brew install scc
brew install gh  # github cli
brew install ast-grep
brew install fd
brew install fzf
brew install yq
brew install poppler  # PDF tools (pdftotext, pdfinfo, etc.)



brew install remotemobprogramming/brew/mob



brew install ffmpeg
brew install yt-dlp  # Video downloader (YouTube, Twitter, etc.)

brew tap anchore/grype
brew install grype

brew install rbenv

# https://github.com/chadgeary/cloudblock/blob/master/oci/README.md
brew install terraform git oci-cli



brew install tmux

brew tap "rhysd/actionlint" "https://github.com/rhysd/actionlint"
brew install actionlint

brew install uv
brew install n  # Node.js version manager (simpler alternative to nvm)

brew tap tobi/try https://github.com/tobi/try
brew install try

brew install go

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
