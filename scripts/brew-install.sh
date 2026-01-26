#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Install GNU core utilities and `sed`, overwriting the built-in versions.
brew install coreutils
brew install gnu-sed

brew install heroku/brew/heroku  # Heroku CLI for deploying and managing apps

brew install wget  # Download files from the web

# Install more recent versions of some macOS tools.
brew install vim  # Text editor
brew install openssh  # SSH client/server suite
brew install openssl  # Cryptography and SSL/TLS toolkit

# Install other useful binaries.
brew install make  # Build automation tool
brew install nano  # Simple terminal text editor
brew install perl  # Scripting language
brew install ripgrep  # Fast grep alternative (rg)
brew install git  # Version control system
brew install curl  # HTTP client for transferring data
brew install jq  # JSON processor and query tool
brew install gradle  # Build tool for Java/Kotlin projects
brew tap gdubw/gng
brew install gng  # Gradle wrapper helper (auto-uses gradlew)
brew install maven  # Java build and dependency management
brew install htop  # Interactive process viewer

brew install telnet  # Network protocol client for testing connections
brew install hugo  # Static site generator
brew install bat  # Better cat with syntax highlighting
brew install eza  # Better ls with colors and git integration
brew install nmap  # Network scanner (nmap -F 192.168.1.1)
brew install yamllint  # YAML linter
brew install vale  # Prose linter for docs and markdown
brew install tree  # Display directory structure as tree
brew install gping  # Ping with live graph visualization
brew install scc  # Fast source code line counter (sloc)
brew install gh  # GitHub CLI
brew install ast-grep  # Structural code search using AST patterns
brew install fd  # Fast find alternative
brew install fzf  # Fuzzy finder for files, history, etc.
brew install yq  # YAML processor (like jq for YAML)
brew install poppler  # PDF tools (pdftotext, pdfinfo, etc.)

brew install remotemobprogramming/brew/mob  # Mob programming git handover tool

brew install ffmpeg  # Video/audio converter and processor
brew install yt-dlp  # Video downloader (YouTube, Twitter, etc.)

brew tap anchore/grype
brew install grype  # Container vulnerability scanner

brew install rbenv  # Ruby version manager

# https://github.com/chadgeary/cloudblock/blob/master/oci/README.md
brew install terraform  # Infrastructure as code
brew install oci-cli  # Oracle Cloud Infrastructure CLI

brew install tmux  # Terminal multiplexer for sessions/splits

brew tap "rhysd/actionlint" "https://github.com/rhysd/actionlint"
brew install actionlint  # GitHub Actions workflow linter

brew install uv  # Fast Python package installer and resolver
brew install n  # Node.js version manager (simpler alternative to nvm)

brew tap tobi/try https://github.com/tobi/try
brew install try  # Run commands in sandbox, inspect changes before applying

brew install go  # Go programming language
brew install golangci-lint  # Go linter aggregator

brew install xcodegen  # Generate Xcode projects from YAML spec
brew install swift-format  # Swift code formatter (Apple official)

brew install xcbeautify  # Prettify xcodebuild output

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
