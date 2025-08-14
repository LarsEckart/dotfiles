#!/bin/bash

# Require argument in format "title:message"
if [ $# -eq 0 ]; then
    echo "Error: No argument provided. Usage: notify.sh 'title:message'" >&2
    exit 1
fi

INPUT="$*"

# Check if input contains colon
if [[ "$INPUT" != *":"* ]]; then
    echo "Error: Input must be in format 'title:message'" >&2
    exit 1
fi

# Split on colon - first part is title, second is message
TITLE="${INPUT%%:*}"
MESSAGE="${INPUT#*:}"

osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""
