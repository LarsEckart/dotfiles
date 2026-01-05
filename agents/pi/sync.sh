#!/bin/bash
# Sync pi agent config to ~/.pi/agent/ using symlinks
# Run this after adding new files to the dotfiles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.pi/agent"

echo "Syncing pi agent config..."
echo "  Source: $SCRIPT_DIR"
echo "  Target: $TARGET_DIR"

mkdir -p "$TARGET_DIR"

# Symlink whole directories
for dir in extensions prompts; do
    if [ -d "$SCRIPT_DIR/$dir" ]; then
        target="$TARGET_DIR/$dir"
        
        # Remove existing dir/symlink if present
        if [ -e "$target" ] || [ -L "$target" ]; then
            rm -rf "$target"
        fi
        
        echo "  → $dir/"
        ln -s "$SCRIPT_DIR/$dir" "$target"
    fi
done

# Symlink AGENTS.md
if [ -f "$SCRIPT_DIR/AGENTS.md" ]; then
    target="$TARGET_DIR/AGENTS.md"
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm "$target"
    fi
    echo "  → AGENTS.md"
    ln -s "$SCRIPT_DIR/AGENTS.md" "$target"
fi

echo "Done!"
