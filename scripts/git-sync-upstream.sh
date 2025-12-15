#!/bin/bash
# Fetch upstream and fast-forward current branch, then push to origin
# Usage: git-sync-upstream.sh [upstream-remote-name]
#
# If 'upstream' remote doesn't exist, prints instructions to add it.

set -e

UPSTREAM="${1:-upstream}"
BRANCH=$(git branch --show-current)

if ! git remote get-url "$UPSTREAM" &>/dev/null; then
    echo "Remote '$UPSTREAM' not found."
    echo ""
    echo "Add it with:"
    echo "  git remote add $UPSTREAM git@github.com:OWNER/REPO.git"
    exit 1
fi

echo "Fetching $UPSTREAM..."
git fetch "$UPSTREAM"

echo "Merging $UPSTREAM/$BRANCH into $BRANCH..."
git merge "$UPSTREAM/$BRANCH"

echo "Pushing to origin..."
git push origin "$BRANCH"

echo "Done."
