---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git --no-pager diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, prepare to either create a single git commit, or multiple commits grouped by related changes.
If you're seeing any issues with what I'm committing, let me know. For example, if I clearly just added a typo, tell me and wait for me to fix it.
When you staged files, compare them to the documentation for the project (`README.md`, `CLAUDE.md` and in `docs` folder) to see if any of the documentation needs to be updated to reflect the changes.
Update the documentation and stage it, then commit.
