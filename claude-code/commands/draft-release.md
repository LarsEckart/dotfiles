---
allowed-tools: Bash(git describe:*)
description: Create a draft release on GitHub
---

## Context

- Latest release tag: !`git describe --tags --abbrev=0`

## Your task

Review the changes made since the last release and make notes of significant updates, new features, bug fixes, and breaking changes.

Next, draft a release description based on your review:

1. List all commits since the last release:
   <function_call>git log [LATEST_TAG]..HEAD --oneline</function_call>

2. For the description, organize the changes into sections:
   - 🚀 Features & Enhancements
   - 🐛 Bug Fixes
   - 📖 Documentation
   - 📦 Dependency updates

   Include brief, clear descriptions of each change, referencing relevant commit hashes or pull request numbers if available. Point out breaking changes (which cause major version increase).

To calculate the next release's version, run `next-version` script which is on PATH.

Once you have drafted the release description, present it to the user for confirmation:

<output>
Proposed Release Description:
[Your proposed description]

Do you want to create this release? (yes/no)
</output>

Wait for the user's response. If the user confirms (answers "yes"), they will also tell you what version to use as release title (e.g. "v2.3.1") proceed with creating the release using the GitHub CLI:

1. Create the release:
   <function_call>gh release create [NEW_TAG] -d -t "[RELEASE_TITLE]" -n "[RELEASE_DESCRIPTION]"</function_call>

2. Confirm the release was created successfully:
   <function_call>gh release view [NEW_TAG]</function_call>

If at any point you encounter an error or are unable to complete a step, explain the issue to the user and ask for guidance.

Present your final output in the following format:

<release_summary>
Release Title: [The final release title]
Release Tag: [The new release tag]
Release Description:
[The final release description]

Release Status: [Successfully created / Failed to create (with reason)]
</release_summary>
