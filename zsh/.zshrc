# ~/.zshrc — interactive shells.
# Login-shell PATH setup lives in .zprofile; keep it out of here.

# ── Environment ──────────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export LANG="en_US.UTF-8"

# bat as the colouriser for man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export BAT_THEME="Catppuccin Mocha"

# ── History ──────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY        # record timestamp
setopt INC_APPEND_HISTORY      # write as you go, not just on exit
setopt SHARE_HISTORY           # share between running shells
setopt HIST_IGNORE_ALL_DUPS    # keep only the most recent copy of a command
setopt HIST_IGNORE_SPACE       # leading space keeps it out of history
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY             # expand !! and let me confirm before running

# ── Shell behaviour ──────────────────────────────────────────────────────────
setopt AUTO_CD                 # `nvim/` instead of `cd nvim/`
setopt AUTO_PUSHD              # every cd pushes onto the dir stack
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS    # allow # comments when typing commands
setopt NO_BEEP

# ── Completion ───────────────────────────────────────────────────────────────
# Hardcoded rather than $(brew --prefix): that spawns a Homebrew process and
# costs ~65ms on every single shell.
BREW_PREFIX="/opt/homebrew"
FPATH="$BREW_PREFIX/share/zsh/site-functions:$FPATH"

autoload -Uz compinit
# Rebuild the dump at most once a day; a full check on every shell is the
# single biggest startup cost in a framework-less setup.
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}%B%d%b%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"

# ── Keybindings ──────────────────────────────────────────────────────────────
bindkey -e                                    # emacs-style
bindkey '^[[A' history-search-backward        # Up: search on what's typed
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word                # Ctrl-Right
bindkey '^[[1;5D' backward-word               # Ctrl-Left



# ── Plugins ──────────────────────────────────────────────────────────────────
# Order matters: syntax-highlighting must be sourced last.
source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ── Aliases ──────────────────────────────────────────────────────────────────
alias ls="eza --group-directories-first --icons"
alias ll="eza -l --group-directories-first --icons --git"
alias la="eza -la --group-directories-first --icons --git"
alias lt="eza --tree --level=2 --icons"
alias cat="bat --paging=never"

alias vim="nvim"
alias v="nvim"

alias g="git"
alias gs="git status -sb"
alias lg="lazygit"

alias ..="cd .."
alias ...="cd ../.."

# Reload after editing this file
alias reload="exec zsh"

# ── Tool integrations ────────────────────────────────────────────────────────
# Each `<tool> init zsh` spawns a process and costs 45-70ms; four of them was
# most of a 420ms startup. Cache the generated code and re-run only when the
# binary is newer than its cache.
ZSH_CACHE="$HOME/.cache/zsh"
_lazy_init() {
  local name=$1; shift
  local cache="$ZSH_CACHE/$name.zsh"
  local bin; bin=$(command -v "$1") || return
  if [[ ! -f $cache || $bin -nt $cache ]]; then
    mkdir -p "$ZSH_CACHE"
    "$@" >| "$cache"
  fi
  source "$cache"
}

# The config lives in its own stow package (~/.config/starship/), not at the
# default ~/.config/starship.toml, so starship has to be pointed at it.
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"

_lazy_init starship starship init zsh
_lazy_init zoxide   zoxide init zsh --cmd cd          # cd is zoxide; \cd is still builtin
_lazy_init atuin    atuin init zsh --disable-up-arrow # Up stays prefix search, Ctrl-R is atuin
_lazy_init fzf      fzf --zsh                         # Ctrl-T files, Alt-C dirs

export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat -n --color=always {}'"


# ── Yazi Setup ────────────────────────────────────────────────────────────
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# Must be last.
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
