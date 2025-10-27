#!/bin/bash

# update_cli_agents.sh
# Script to update CLI agents and check for new versions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

cleanup_partial_install() {
    local package_name=$1
    local display_name=$2
    local npm_root
    npm_root=$(npm root -g 2>/dev/null) || return 0

    local pkg_dir="$npm_root/$package_name"
    local parent_dir="$npm_root"
    if [[ "$package_name" == */* ]]; then
        parent_dir="$npm_root/${package_name%/*}"
    fi
    local base_name="${package_name##*/}"

    local to_remove=()
    if [ -d "$pkg_dir" ]; then
        to_remove+=("$pkg_dir")
    fi
    if [ -d "$parent_dir" ]; then
        shopt -s nullglob
        for leftover in "$parent_dir"/."${base_name}"-*; do
            to_remove+=("$leftover")
        done
        shopt -u nullglob
    fi

    if [ ${#to_remove[@]} -gt 0 ]; then
        print_status $YELLOW "  Cleaning partial install state for $display_name"
        rm -rf "${to_remove[@]}"
    fi
}

perform_install() {
    local package_name=$1
    local display_name=$2
    local spec=$3
    local output

    if output=$(npm install -g "$package_name$spec" 2>&1); then
        return 0
    fi

    if echo "$output" | grep -q "ENOTEMPTY: directory not empty, rename"; then
        cleanup_partial_install "$package_name" "$display_name"
        if output=$(npm install -g "$package_name$spec" 2>&1); then
            return 0
        fi
    fi

    echo "$output" | tail -n 40
    return 1
}

# Ensure we run with the user's preferred Node (via nvm) when available.
if [ -z "${NVM_DIR:-}" ] && [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
fi
if [ -n "${NVM_DIR:-}" ] && [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1090
    . "$NVM_DIR/nvm.sh"
    nvm use --lts >/dev/null 2>&1 || print_status $YELLOW "⚠️ nvm failed to switch Node version; continuing with system Node"
fi

# Function to get installed version of npm package
get_installed_version() {
    local package_name=$1
    npm list -g "$package_name" --depth=0 2>/dev/null | grep "$package_name" | sed 's/.*@//' || echo "not installed"
}

# Function to get latest version from npm
get_latest_version() {
    local package_name=$1
    npm view "$package_name" version 2>/dev/null || echo "unknown"
}

# Function to update package
update_package() {
    local package_name=$1
    local display_name=$2

    print_status $BLUE "Updating $display_name..."
    if perform_install "$package_name" "$display_name" "@latest"; then
        local new_version=$(get_installed_version "$package_name")
        print_status $GREEN "✅ $display_name updated to version $new_version"
    else
        print_status $RED "❌ Failed to update $display_name"
        return 1
    fi
}

# Function to check and update a CLI agent
check_and_update() {
    local package_name=$1
    local display_name=$2
    local binary_name=$3
    
    print_status $YELLOW "Checking $display_name..."
    
    # Check if binary exists
    if ! command -v "$binary_name" &> /dev/null; then
        print_status $YELLOW "📦 $display_name not found. Installing..."
        if perform_install "$package_name" "$display_name" ""; then
            local new_version=$(get_installed_version "$package_name")
            print_status $GREEN "✅ $display_name installed successfully (version $new_version)"
        else
            print_status $RED "❌ Failed to install $display_name"
            return 1
        fi
        echo
        return 0
    fi
    
    local installed_version=$(get_installed_version "$package_name")
    local latest_version=$(get_latest_version "$package_name")
    
    if [ "$installed_version" = "not installed" ]; then
        print_status $RED "❌ Package $package_name not found in global npm list"
        return 1
    fi
    
    if [ "$latest_version" = "unknown" ]; then
        print_status $RED "❌ Could not fetch latest version for $package_name"
        return 1
    fi
    
    print_status $BLUE "  Installed: $installed_version"
    print_status $BLUE "  Latest:    $latest_version"
    
    if [ "$installed_version" != "$latest_version" ]; then
        print_status $YELLOW "  Update available!"
        update_package "$package_name" "$display_name"
    else
        print_status $GREEN "  ✅ Already up to date"
    fi
    
    echo
}

# Main script
print_status $BLUE "🔄 CLI Agent Updater"
echo "===================="
echo



# List of CLI agents to check/update
# Format: package_name display_name binary_name
CLI_AGENTS=(
    "@google/gemini-cli|Gemini CLI|gemini"
    "@qwen-code/qwen-code|Qwen CLI|qwen"
    "@openai/codex|OpenAI Codex CLI|codex"
    "@sourcegraph/amp|Sourcegraph AMP|amp"
    "@charmland/crush|Crush CLI|crush"
    "@github/copilot|GitHub Copilot CLI|copilot"
)

# Check and update each CLI agent
for agent in "${CLI_AGENTS[@]}"; do
    IFS='|' read -r package_name display_name binary_name <<< "$agent"
    check_and_update "$package_name" "$display_name" "$binary_name"
done

print_status $GREEN "🎉 CLI agent update check complete!"
