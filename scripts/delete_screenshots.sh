#!/bin/bash

# Screenshot folder
FOLDER="$HOME/Pictures/Screenshots"

# Delete files older than 7 days
find "$FOLDER" -type f -name "*.png" -mtime +7 -delete
