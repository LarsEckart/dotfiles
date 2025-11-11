# Dotfiles

### Installation

Quick installation guide, backs up original dot files and stores them out of the way in a git ignored directory.

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
mkdir -p ~/.dotfiles/backups

# Backup existing files
mv ~/.gitconfig ~/.dotfiles/backups/ 2>/dev/null || true

# Shell configuration (ZSH)
ln -s ~/.dotfiles/shell/.zshrc ~/.zshrc
ln -s ~/.dotfiles/shell/.zsh_exports ~/.zsh_exports
ln -s ~/.dotfiles/shell/.zsh_functions ~/.zsh_functions
ln -s ~/.dotfiles/shell/.aliases ~/.aliases
ln -s ~/.dotfiles/shell/.exports ~/.exports
ln -s ~/.dotfiles/shell/.functions ~/.functions

# Git configuration
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/git/.gitattributes ~/.gitattributes
ln -s ~/.dotfiles/git/.gitignore_global ~/.gitignore_global

# Zed configuration
ln -s ~/.dotfiles/zed/settings.json ~/.config/zed/settings.json
ln -s ~/.dotfiles/zed/theme.json ~/.config/zed/themes/Casablanca.json

# Claude Code configuration
mkdir -p ~/.claude
mkdir -p ~/.claude/commands
ln -s ~/.dotfiles/claude-code/settings.json ~/.claude/settings.json
ln -s ~/.dotfiles/claude-code/settings.local.json ~/.claude/settings.local.json
ln -s ~/.dotfiles/claude-code/mcp_servers.json ~/.claude/mcp_servers.json
ln -s ~/.dotfiles/claude-code/CLAUDE.md ~/.claude/CLAUDE.md
ln -s ~/.dotfiles/claude-code/commands/commit.md ~/.claude/commands/commit.md
ln -s ~/.dotfiles/claude-code/commands/done-differently.md ~/.claude/commands/done-differently.md
ln -s ~/.dotfiles/claude-code/commands/draft-release.md ~/.claude/commands/draft-release.md
ln -s ~/.dotfiles/claude-code/commands/handoff.md ~/.claude/commands/handoff.md
ln -s ~/.dotfiles/claude-code/commands/issue.md ~/.claude/commands/issue.md
ln -s ~/.dotfiles/claude-code/commands/pickup.md ~/.claude/commands/pickup.md
ln -s ~/.dotfiles/claude-code/commands/todo.md ~/.claude/commands/todo.md
ln -s ~/.dotfiles/claude-code/commands/work.md ~/.claude/commands/work.md

# Codex configuration
mkdir -p ~/.codex
mkdir -p ~/.codex/prompts
ln -s ~/.dotfiles/codex/AGENTS.md ~/.codex/AGENTS.md
ln -s ~/.dotfiles/codex/prompts/commit.md ~/.codex/prompts/commit.md
ln -s ~/.dotfiles/codex/prompts/done-differently.md ~/.codex/prompts/done-differently.md

# Other dotfiles
ln -s ~/.dotfiles/.hushlogin ~/.hushlogin
ln -s ~/.dotfiles/.vimrc ~/.vimrc
```

Setup for multiple git identities is also described [here](https://garrit.xyz/posts/2023-10-13-organizing-multiple-git-identities).

### Fonts

* Jetbrains Mono

### Others

* [Generate a ssh key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
* Generate gpg key (update gpg and install pinentry-mac through brew, [do after install](https://www.reddit.com/r/emacs/comments/fe165f/pinentry_problems_in_osx/fjlpkqv/?utm_source=reddit&utm_medium=web2x&context=3) do `gpgconf --kill gpg-agent` at the very end
* Paste and match style: https://twitter.com/_overment/status/1627917465295507456
