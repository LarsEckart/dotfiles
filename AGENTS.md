# AGENTS.md

## Repository Structure

Personal dotfiles repository for macOS, organized into logical folders:

```
~/.dotfiles/
├── shell/                   # ZSH configuration
├── git/                     # Git configuration (multi-identity)
├── scripts/                 # Utility scripts
├── githooks/                # Global git hooks
├── zed/                     # Zed editor config + themes
├── ghostty/                 # Ghostty terminal config
├── speech/                  # ElevenLabs text-to-speech Python tool
├── tuple-triggers/          # Tuple collaboration utilities
├── templates/proc/          # Process management templates (shoreman)
├── Makefile                 # Installation automation
└── README.md                # Symlink installation guide
```

## Key Directories

### shell/
ZSH-only configuration (bash removed):
- `.zshrc` - Main config, sources other files, lazy-loads rbenv
- `.zshenv` - Environment setup for GUI apps
- `.zsh_exports` - Environment variables, history config, PATH setup
- `.zsh_functions` - Custom functions (git helpers, docker cleanup, text-to-speech)
- `.aliases` - Command aliases (Java versions, eza, git, AI tools)
- `.secrets` - Sensitive environment variables (gitignored)

### git/
Multi-identity git configuration:
- `.gitconfig` - Main config with aliases, uses conditional includes
- `.gitconfig-personal` - Personal GitHub identity (GPG signing via 1Password)
- `.gitconfig-work` - Work identity for `~/work/` directories
- `.gitignore_global` - Global ignore patterns
- `.gitattributes` - File attributes

### scripts/
Utility scripts (added to PATH via `.zsh_exports`):
- `mac-setup.sh` - macOS system defaults configuration
- `curltime.sh` - HTTP timing diagnostics
- `shoreman.sh` - Procfile process manager
- `bumbailiff` - TODO debt tracker
- `notify.sh` / `claude-done.sh` - Notification helpers
- `speak` - Text-to-speech wrapper
- `browser` / `browser.swift` - Default browser switcher
- `update_cli_agents.sh` - AI CLI tools updater
- `next-version.sh` - Semantic versioning helper
- `git-sync-upstream.sh` - Fork sync helper
- `bash-to-history.sh` - History migration

### githooks/
Global git hooks (set via `core.hooksPath`):
- `prepare-commit-msg` - Auto-prepends ticket number from branch name (e.g., `feature/ABC-123-foo` → `ABC-123 commit message`)
- `pre-commit` - Delegates to local repo hooks if present
- `prepare-commit-msg-james` - Alternative hook variant

### zed/
Zed editor configuration:
- `settings.json` - Editor settings
- `themes/` - Custom themes:
  - `Casablanca.json` (primary dark theme)
  - `NeoSolarized.json`
  - `Github Theme.json`
  - `macOS Classic.json`

### speech/
Python project for ElevenLabs text-to-speech:
- Uses `uv` for dependency management
- Called via `speak "text"` function in shell

### templates/proc/
Process management templates for local development:
- `Procfile.template` - Process definitions
- `Makefile.template` - Make targets
- `.env.template` - Environment variables
- Used by `proc()` function to scaffold new projects

## Installation

Use the Makefile for installation:

```bash
make install          # Install all configurations
make install-zsh      # Just shell config
make install-zed      # Just Zed config
make install-githooks # Just git hooks
make setup-macos      # Run macOS defaults setup
make brew-install     # Install Homebrew packages from Brewfile
make clean            # Remove symlinks
make uninstall        # Clean and restore backups
```

Or see `README.md` for manual symlink commands.

## Key Features

### Multi-Identity Git
Automatic identity switching based on directory:
- Default: Personal identity (GPG signing enabled)
- `~/work/*`: Work identity

### Lazy Loading
Shell startup optimized with lazy loading for:
- rbenv (Ruby)
- Angular CLI completions

### Alias Policy (Script-First)
This repository follows a script-first command approach inspired by:
https://evanhahn.com/why-alias-is-my-last-resort-for-aliases/

Guideline:
- Prefer executable commands in `scripts/` (on `PATH`) over shell `alias`
- Use aliases/functions only when shell-specific behavior is required (e.g. `cd`, shell state mutation, completion quirks)

### AI Tool Commands
```bash
ccd   # Claude Code (dangerous mode)
cdx   # Codex (bypass mode)
gemi  # Gemini (auto-approve)
copi  # Copilot (all tools)
```

### Useful Functions
- `pk <port>` - Kill process on port
- `wtf [port]` - Show what's using a port (default: 8080)
- `todo` - Show and track TODO debt
- `churn` - Git file change frequency analysis
- `extract <file>` - Extract any archive format
- `speak "text"` - Text-to-speech via ElevenLabs
- `proc` - Scaffold process management files
- `gcl` - Clean merged branches

## Telemetry

Claude Code telemetry configured to export to Honeycomb (see `.zsh_exports`).

## When Modifying

1. After adding new dotfiles, update `README.md` symlink instructions
2. After adding new scripts, ensure they're executable (`chmod +x`)
3. The `Makefile` may also need updates for new symlinks
4. Git config paths use absolute paths - update if moving directories
