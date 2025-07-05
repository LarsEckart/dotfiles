# Dotfiles

Cross-platform dotfiles supporting both macOS and Arch Linux with maximum code sharing.

## Structure

```
~/.dotfiles/
├── shared/          # Cross-platform configurations
│   ├── shell/       # Common shell configs (aliases, functions, exports)
│   ├── git/         # Git configuration
│   └── claude-code/ # Claude Code settings
├── macos/           # macOS-specific configurations
│   ├── shell/       # ZSH configuration for macOS
│   ├── scripts/     # macOS setup and Homebrew scripts
│   ├── zed/         # Zed editor configuration
│   ├── githooks/    # Git hooks
│   └── tuple-triggers/ # Tuple collaboration tools
├── arch/            # Arch Linux-specific configurations
│   └── shell/       # Bash configuration (works with omarchy)
└── install/         # Platform-specific installation scripts
```

## Installation

### macOS

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install/install-macos.sh
```

### Arch Linux (with omarchy)

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install/install-arch.sh
```

The Arch installation is designed to work alongside [omarchy](https://github.com/your-omarchy-repo) and provides complementary configurations rather than replacing the base system setup.

### Shared Only

To install just the cross-platform configurations:

```bash
git clone git@github.com:LarsEckart/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install/install-shared.sh
```

## Key Features

### Shared Configurations
- **Git**: Multi-identity setup with personal/work configurations
- **Vim**: Basic vim configuration
- **Claude Code**: CLI settings and configurations
- **Shell**: Common aliases, functions, and exports

### macOS-Specific
- **ZSH**: Comprehensive ZSH configuration with plugins
- **Homebrew**: Package management and installation scripts
- **macOS Defaults**: System preferences automation
- **Zed Editor**: Custom settings and Casablanca theme
- **Development Tools**: Java version switching, Android SDK, etc.

### Arch Linux-Specific
- **Bash**: Configuration that complements omarchy
- **Package Management**: Pacman and AUR helper aliases
- **System Management**: Service management shortcuts
- **Wayland/Hyprland**: Environment-specific configurations

## Git Configuration

The git setup uses conditional includes for multiple identities:
- `.gitconfig-personal`: Personal GitHub identity with GPG signing
- `.gitconfig-work`: Work identity with custom SSH configuration
- Global git hooks for commit message automation

## Development Setup

### macOS
After installation, run:
```bash
~/.dotfiles/macos/scripts/mac-setup.sh    # System preferences
~/.dotfiles/macos/scripts/brew-install.sh # Development tools
```

### Arch Linux
The Arch setup assumes you're using omarchy for system configuration. The dotfiles provide additional development-focused configurations that work alongside omarchy's base setup.

## Shell Unification

Both platforms can optionally use bash for consistency. The macOS setup currently uses ZSH but can be adapted to use the shared bash configurations.

## Fonts

Install JetBrains Mono font for optimal terminal experience.

## Additional Setup

- [Generate SSH keys](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- Configure GPG keys for commit signing
- Set up development environment specific to your needs

## Migration from Original Structure

The repository has been reorganized from a macOS-only structure to support multiple platforms. Original configurations have been split into shared and platform-specific components while maintaining full functionality.