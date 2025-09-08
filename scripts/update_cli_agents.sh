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
    if npm install -g "$package_name@latest" >/dev/null 2>&1; then
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
        print_status $RED "❌ $display_name not found. Install with: npm install -g $package_name"
        return 1
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
        if [ "$1" = "--dry-run" ] || [ "$2" = "--dry-run" ] || [ "$3" = "--dry-run" ]; then
            print_status $YELLOW "  [DRY RUN] Would update $display_name from $installed_version to $latest_version"
        else
            update_package "$package_name" "$display_name"
        fi
    else
        print_status $GREEN "  ✅ Already up to date"
    fi
    
    echo
}

# Main script
print_status $BLUE "🔄 CLI Agent Updater"
echo "===================="
echo

# Check for dry run flag
DRY_RUN=false
if [[ "$*" == *"--dry-run"* ]]; then
    DRY_RUN=true
    print_status $YELLOW "🔍 Running in dry-run mode (no actual updates will be performed)"
    echo
fi

# List of CLI agents to check/update
# Format: package_name display_name binary_name
CLI_AGENTS=(
    "@google/gemini-cli|Gemini CLI|gemini"
    "@qwen-code/qwen-code|Qwen CLI|qwen"
    "@openai/codex|OpenAI Codex CLI|codex"
    "@sourcegraph/amp|Sourcegraph AMP|amp"
    "@charmland/crush|Crush CLI|crush"
)

# Check and update each CLI agent
for agent in "${CLI_AGENTS[@]}"; do
    IFS='|' read -r package_name display_name binary_name <<< "$agent"
    if $DRY_RUN; then
        check_and_update "$package_name" "$display_name" "$binary_name" --dry-run
    else
        check_and_update "$package_name" "$display_name" "$binary_name"
    fi
done

print_status $GREEN "🎉 CLI agent update check complete!"

# Show usage information
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo
    print_status $BLUE "Usage:"
    echo "  $0           - Check and update all CLI agents"
    echo "  $0 --dry-run - Check versions without updating"
    echo "  $0 --help    - Show this help message"
fi