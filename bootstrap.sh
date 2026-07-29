#!/usr/bin/env bash
# Set up this machine from the dotfiles repo.
#   ./bootstrap.sh           symlink everything + install the secret-scan hook
#   ./bootstrap.sh --check   dry run, change nothing
set -euo pipefail

cd "$(dirname "$0")"

# Each package directory holds its config files directly — dotfiles/nvim/init.lua,
# not dotfiles/nvim/.config/nvim/init.lua — so the repo root itself is the stow
# package and each top-level directory becomes ~/.config/<name>. What must stay
# out of ~/.config is listed in .stow-local-ignore.
#
# zsh is the exception: .zshrc/.zprofile belong in $HOME, so it is stowed
# separately (and ignored by the root package).
STOW_FLAGS=(--verbose)
if [[ "${1:-}" == "--check" ]]; then
  STOW_FLAGS+=(--no)
  echo "-- dry run, nothing will be written --"
fi

mkdir -p "$HOME/.config"

echo "Stowing repo root into ~/.config"
stow "${STOW_FLAGS[@]}" --target="$HOME/.config" .

echo "Stowing zsh into ~"
stow "${STOW_FLAGS[@]}" --target="$HOME" zsh

# Route git at the tracked hooks directory so the gitleaks pre-commit scan runs.
if [[ "${1:-}" != "--check" ]]; then
  git config core.hooksPath .githooks
  echo "Secret-scan hook enabled (core.hooksPath=.githooks)."
  command -v gitleaks >/dev/null 2>&1 \
    || echo "  WARNING: gitleaks not installed - the hook will no-op. brew install gitleaks" >&2
fi

echo "Done."
