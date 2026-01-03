#!/bin/bash
# Sync pi agent config to ~/.pi/agent/ using symlinks
# Run this after adding new files to the dotfiles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.pi/agent"

echo "Syncing pi agent config..."
echo "  Source: $SCRIPT_DIR"
echo "  Target: $TARGET_DIR"

# Create target directories if needed
mkdir -p "$TARGET_DIR/hooks"
mkdir -p "$TARGET_DIR/commands"

# Sync hooks (symlink)
if [ -d "$SCRIPT_DIR/hooks" ]; then
    for file in "$SCRIPT_DIR/hooks"/*.ts; do
        [ -e "$file" ] || continue
        filename=$(basename "$file")
        target="$TARGET_DIR/hooks/$filename"
        
        # Remove existing file/symlink if present
        if [ -e "$target" ] || [ -L "$target" ]; then
            rm "$target"
        fi
        
        echo "  → hooks/$filename"
        ln -s "$file" "$target"
    done
fi

# Sync commands (symlink)
if [ -d "$SCRIPT_DIR/commands" ]; then
    for file in "$SCRIPT_DIR/commands"/*.md; do
        [ -e "$file" ] || continue
        filename=$(basename "$file")
        target="$TARGET_DIR/commands/$filename"
        
        # Remove existing file/symlink if present
        if [ -e "$target" ] || [ -L "$target" ]; then
            rm "$target"
        fi
        
        echo "  → commands/$filename"
        ln -s "$file" "$target"
    done
fi

# Sync AGENTS.md (symlink)
if [ -f "$SCRIPT_DIR/AGENTS.md" ]; then
    target="$TARGET_DIR/AGENTS.md"
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm "$target"
    fi
    echo "  → AGENTS.md"
    ln -s "$SCRIPT_DIR/AGENTS.md" "$target"
fi

echo "Done!"
