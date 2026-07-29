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

# Zen keeps its keyboard shortcuts inside the browser profile rather than in
# ~/.config, so it needs its own target. The profile directory name carries a
# random prefix that differs per install ("gtsr0yef.Default (release)"), so read
# the active one out of profiles.ini instead of hard-coding it. The [Install...]
# section is authoritative for the profile the running browser actually uses --
# the Default=1 flag under [ProfileN] is a separate, older mechanism and here it
# points at a different profile.
zen_root="$HOME/Library/Application Support/zen"
zen_profile=""
if [[ -f "$zen_root/profiles.ini" ]]; then
  rel=$(awk -F= '
    /^\[Install/       { in_install = 1; next }
    /^\[/              { in_install = 0 }
    in_install && $1 == "Default" { sub(/^Default=/, "", $0); print; exit }
  ' "$zen_root/profiles.ini")
  [[ -n "$rel" && -d "$zen_root/$rel" ]] && zen_profile="$zen_root/$rel"
fi

if [[ -z "$zen_profile" ]]; then
  echo "  skipping zen: no active profile found in $zen_root/profiles.ini" >&2
else
  target="$zen_profile/zen-keyboard-shortcuts.json"
  # Zen rewrites this file itself whenever a shortcut changes, and Mozilla-family
  # code writes JSON by creating a temp file and renaming it over the target --
  # which replaces a symlink with a regular file. When that happens the link is
  # silently gone and the repo copy goes stale, so flag it rather than let it
  # drift unnoticed.
  if [[ -f "$target" && ! -L "$target" ]]; then
    echo "  NOTE: $target is a regular file, not a symlink." >&2
    echo "        Either it was never stowed, or Zen overwrote the link." >&2
    echo "        Diff it against zen/ and copy across before re-stowing." >&2
  fi
  echo "Stowing zen into $zen_profile"
  stow "${STOW_FLAGS[@]}" --target="$zen_profile" zen
fi

# Yazi's flavors and plugins are fetched, not tracked (see .gitignore). Without
# this, yazi starts with "Failed to read flavor ... No such file or directory"
# because theme.toml names a flavor that was never downloaded.
if [[ "${1:-}" != "--check" ]]; then
  if command -v ya >/dev/null 2>&1; then
    echo "Installing yazi packages from yazi/package.toml"
    ya pkg install
  else
    echo "  skipping yazi packages: ya not installed (brew install yazi)" >&2
  fi
fi

# Route git at the tracked hooks directory so the gitleaks pre-commit scan runs.
if [[ "${1:-}" != "--check" ]]; then
  git config core.hooksPath .githooks
  echo "Secret-scan hook enabled (core.hooksPath=.githooks)."
  command -v gitleaks >/dev/null 2>&1 \
    || echo "  WARNING: gitleaks not installed - the hook will no-op. brew install gitleaks" >&2
fi

echo "Done."
