#!/bin/bash
#
# Adds bash commands from AI coding agents to shell history.
# Used as a PostToolUse hook for Claude Code.
#
# Receives JSON on stdin with tool_name and tool_input fields.
# Only processes "Bash" tool calls.

# Read JSON from stdin
input=$(cat)

# Extract tool name
tool_name=$(echo "$input" | jq -r '.tool_name // .toolName // empty' 2>/dev/null)

# Only process Bash tool
if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

# Extract the command from tool_input
command=$(echo "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)

if [[ -z "$command" ]]; then
  exit 0
fi

# Determine history file
HIST_FILE="${HISTFILE:-$HOME/.zsh_history}"

# Check if it's zsh format
if [[ "$HIST_FILE" == *"zsh"* ]]; then
  # ZSH extended history format: `: timestamp:0;command`
  timestamp=$(date +%s)
  echo ": ${timestamp}:0;# ccd: ${command}" >> "$HIST_FILE"
else
  # Bash format
  echo "# ccd: ${command}" >> "$HIST_FILE"
fi

exit 0
