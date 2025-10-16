#!/bin/bash

# Screenshot folder
SCREENSHOT_DIR=~/Pictures/Screenshots

# Find the newest screenshot
LAST_SHOT=$(ls -t "$SCREENSHOT_DIR"/*.png | head -n1)

# Copy to clipboard
if [ -f "$LAST_SHOT" ]; then
  echo "Copying $LAST_SHOT to clipboard..."
  /usr/bin/osascript -e "set the clipboard to (read (POSIX file \"$LAST_SHOT\") as JPEG picture)"
else
  echo "No screenshot found."
fi
