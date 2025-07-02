#!/usr/bin/env bash

# Update and maintain Homebrew installation.

# Make sure we're using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Remove outdated versions from the cellar including casks
brew cleanup