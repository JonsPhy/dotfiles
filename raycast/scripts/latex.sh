#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New LaTEX
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🧌
# @raycast.argument1 { "type": "text", "placeholder": "Project Name" }
# @raycast.argument2 { "type": "text", "placeholder": "Push?: y/n", "optional": true }
# @raycast.argument3 { "type": "text", "placeholder": "Target Dir (optional)", "optional": true }

# Documentation:
# @raycast.author Your Name

# Festes Template-Repository
TEMPLATE_REPO_URL="git@github.com:JonsPhy/Template"

# Überprüfen, ob mindestens ein Argument übergeben wurde
if [ "$#" -lt 1 ]; then
  echo "Usage: ./clone_project.sh <New-Project-Name> [Push? y/n] [Target-Directory]"
  exit 1
fi

# Projektname
NEW_PROJECT_NAME=$1

# Push-Option
PUSH_OPTION=${2:-"n"} # Standard: "n" (nicht pushen)

# Zielverzeichnis (Optional, Standard: aktuelles Verzeichnis)
TARGET_DIR=${3:-"/Users/jonasvonstein/latex_scripts"}

# Zielverzeichnis erstellen, falls es nicht existiert
if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory $TARGET_DIR does not exist. Creating it..."
  mkdir -p "$TARGET_DIR"
fi

# Klonen des Templates ins Zielverzeichnis
echo "Cloning template repository into $TARGET_DIR/$NEW_PROJECT_NAME..."
git clone "$TEMPLATE_REPO_URL" "$TARGET_DIR/$NEW_PROJECT_NAME"

if [ $? -ne 0 ]; then
  echo "Error: Failed to clone template repository."
  exit 1
fi

# Wechsel in das neue Projektverzeichnis
cd "$TARGET_DIR/$NEW_PROJECT_NAME" || {
  echo "Error: Failed to navigate to project directory."
  exit 1
}

# Git-Historie entfernen
echo "Removing Git history from template..."
rm -rf .git

# Neues Git-Repository initialisieren
echo "Initializing new Git repository..."
git init
git add .
git commit -m "Initial commit based on template"

echo "Project $NEW_PROJECT_NAME has been created in $TARGET_DIR!"

# Optional: Push to remote
if [ "$PUSH_OPTION" = "y" ]; then
  echo "Creating GitHub repository..."
  gh repo create "$NEW_PROJECT_NAME" --private --source=. --remote=origin

  if [ $? -ne 0 ]; then
    echo "Error: Failed to create GitHub repository."
    exit 1
  fi

  echo "Pushing to remote repository..."
  git branch -M main
  git push -u origin main

  if [ $? -ne 0 ]; then
    echo "Error: Failed to push to GitHub repository."
    exit 1
  fi

  echo "Project has been pushed to GitHub."
else
  echo "Skipping push to remote."
fi
cd "$TARGET_DIR/$NEW_PROJECT_NAME"

# Wechsel in das `src`-Verzeichnis und Datei öffnen
if [ -d "src" ]; then
  cd "src" || exit
  if [ -f "refs.bib" ]; then
    ln -s ~/Zotero/references.bib refs.bib
    echo "linking references.bib"
  else
    echo "Error: refs.bib not found in src directory."
  fi
  cd ..
else
  echo "Error: src directory not found in $TARGET_DIR/$NEW_PROJECT_NAME."
fi
cd "$TARGET_DIR/$NEW_PROJECT_NAME"
