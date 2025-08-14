#!/bin/bash

# Use the provided message or default to "Done!"
MESSAGE="${*:-Done!}"

osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\""
