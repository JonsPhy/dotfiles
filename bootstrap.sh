#!/bin/bash

echo "🛠 Starte Dotfiles-Bootstrap..."

cd "$(dirname "$0")" || exit 1

# Liste der stow-Pakete
PACKAGES=(nvim zsh git karabiner)

for package in "${PACKAGES[@]}"; do
  echo "🔗 Stowing $package..."
  stow -v "$package"
done

echo "✅ Dotfiles erfolgreich installiert!"
