# ~/.zprofile — login shells. Environment and PATH only.
#
# This is the static equivalent of:
#     eval "$(/usr/local/bin/brew shellenv)"
#     eval "$(/opt/homebrew/bin/brew shellenv)"
# Each of those spawns a Homebrew process (~65ms), so the pair cost ~200ms on
# every login shell. The output is deterministic, so it is inlined here.
# If Homebrew ever changes its shellenv output, regenerate by diffing against
# `brew shellenv`.
#
# ORDER MATTERS: /opt/homebrew must precede /usr/local. This machine is an M2
# with both an ARM and an Intel Homebrew, and 38 packages exist in both. Putting
# the ARM prefix first makes those resolve to the native build; Intel-only
# packages still work, they just come later. Getting this backwards silently
# hands you x86_64 binaries running under Rosetta.

export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"

# $path is already populated from /etc/paths by path_helper (run by /etc/zprofile).
path=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
  /usr/local/sbin
  $path
  $HOME/.local/bin          # pipx
)
typeset -U path             # dedupe, keeping the first occurrence

fpath=(
  /opt/homebrew/share/zsh/site-functions
  /usr/local/share/zsh/site-functions
  $fpath
)
typeset -U fpath

export MANPATH="/opt/homebrew/share/man:/usr/local/share/man:${MANPATH-}"
export INFOPATH="/opt/homebrew/share/info:/usr/local/share/info:${INFOPATH:-}"
