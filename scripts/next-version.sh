#!/bin/bash

# Script to determine next semantic version based on git tags
# Usage: ./next-version.sh <major|minor|patch>

set -e

# Check if argument is provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <major|minor|patch>" >&2
    echo "" >&2
    echo "Determines the next semantic version based on the latest git tag." >&2
    echo "" >&2
    echo "Arguments:" >&2
    echo "  major    Increment major version (X.0.0)" >&2
    echo "  minor    Increment minor version (X.Y.0)" >&2
    echo "  patch    Increment patch version (X.Y.Z)" >&2
    echo "" >&2
    echo "Example:" >&2
    echo "  $0 major    # 0.1.7 -> 1.0.0" >&2
    echo "  $0 minor    # 0.1.7 -> 0.2.0" >&2
    echo "  $0 patch    # 0.1.7 -> 0.1.8" >&2
    exit 1
fi

# Get the increment type
INCREMENT_TYPE="$1"

# Validate increment type
if [[ ! "$INCREMENT_TYPE" =~ ^(major|minor|patch)$ ]]; then
    echo "Error: Invalid increment type '$INCREMENT_TYPE'" >&2
    echo "Use: major, minor, or patch" >&2
    exit 1
fi

# Get the latest tag
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0")

# Extract version components (remove 'v' prefix if present)
VERSION=${LATEST_TAG#v}

# Split version into components
IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"

# Validate that we have numeric components
if ! [[ "$MAJOR" =~ ^[0-9]+$ ]] || ! [[ "$MINOR" =~ ^[0-9]+$ ]] || ! [[ "$PATCH" =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid version format in tag: $LATEST_TAG" >&2
    exit 1
fi

# Calculate next version based on increment type
case "$INCREMENT_TYPE" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
esac

# Output the new version
echo "${MAJOR}.${MINOR}.${PATCH}"