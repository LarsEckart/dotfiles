---
description: git commit the changes
---

## Context

- Current git status: `git status`
- Current git diff (staged and unstaged changes): `git --no-pager diff HEAD`
- Current branch: `git branch --show-current`
- Recent commits: `git log --oneline -10`

## Your task

Follow these steps to prepare git commit(s):

1. Review the changes carefully:
   - Look for any obvious typos or errors. If you find any, mention them and wait for confirmation before proceeding.
   - Verify that none of the changes contain any secrets or sensitive information.

2. Check if the .gitignore file needs to be updated:
   - Review the changes and determine if any new file types or directories should be excluded from version control.
   - If updates are needed, mention this and include the necessary changes in your commit.

3. Compare the changes to the project documentation:
   - Review the README.md, AGENTS.md, and any files in the `docs` folder.
   - Determine if any documentation needs to be updated to reflect the recent changes.
   - If updates are required, make the necessary changes and include them in your commit.

4. Prepare the commit(s):
   - Group related changes together.
   - If the changes are small and related, create a single commit.
   - If there are multiple unrelated changes, prepare separate commits for each group of related changes.

5. Create commit messages:
   - Write clear, concise commit messages that accurately describe the changes.
   - If working on a GitHub issue, include the issue number in the commit message using one of the following keywords: "closes #X" or "fixes #X", where X is the issue number.

If at any point you encounter a problem or need clarification, stop and ask for guidance before proceeding.
