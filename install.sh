#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${ROOT_DIR}/Brewfile"
MAKEFILE="${ROOT_DIR}/Makefile"

step() {
  echo ""
  echo "==> $1"
}

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This installer is intended for macOS only."
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "git is required but not installed. Install Xcode Command Line Tools first."
  exit 1
fi

if ! command -v make >/dev/null 2>&1; then
  echo "make is required but not installed. Install Xcode Command Line Tools first."
  exit 1
fi

if [[ ! -f "${BREWFILE}" ]]; then
  echo "Missing Brewfile at ${BREWFILE}"
  exit 1
fi

if [[ ! -f "${MAKEFILE}" ]]; then
  echo "Missing Makefile at ${MAKEFILE}"
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  step "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

step "Installing/updating Homebrew packages from Brewfile"
brew bundle --file "${BREWFILE}"

step "Installing dotfiles symlinks"
make -C "${ROOT_DIR}" install

step "Done"
echo "Bootstrap complete."
echo "Next: run 'make setup-macos' if you want macOS defaults applied."
