# dotfiles

macOS configuration for a scientific-writing workflow — Neovim for LaTeX,
Quarto and Python, a tiling window manager, and a Catppuccin Mocha palette
shared across every tool.

Managed with [GNU Stow](https://www.gnu.org/software/stow/): every directory in
this repo is symlinked into `~/.config`, so the files you edit here are the
files your tools read. There is no copy step and no sync step.

---

## Install

```sh
git clone https://github.com/<you>/dotfiles ~/dotfiles
cd ~/dotfiles
./bootstrap.sh --check   # dry run — prints every symlink, writes nothing
./bootstrap.sh           # apply
```

`bootstrap.sh` is idempotent. Re-run it after adding a package; it only creates
what is missing.

It also sets `core.hooksPath=.githooks`, which enables the gitleaks pre-commit
scan (see [Secret scanning](#secret-scanning)).

### Dependencies

```sh
brew install stow neovim ghostty starship eza bat fzf zoxide atuin \
             lazygit ripgrep fd gitleaks zsh-autosuggestions \
             imagemagick ghostscript node python3
brew install --cask aerospace karabiner-elements
```

For the writing stack: `quarto`, plus a TeX distribution providing `latexmk`
(MacTeX or TeX Live). `tectonic` is used by Neovim to render LaTeX snippets
inline.

Optional, and currently **not** installed on this machine:

- `R` — `r_language_server` is configured in `nvim/lua/plugins/lsp.lua` but
  will not start without it.
- `mmdc` (`npm i -g @mermaid-js/mermaid-cli`) — only needed to render Mermaid
  diagrams inline in Neovim.

---

## How the stow layout works

Each top-level directory is a package holding its config files **directly**:

```
dotfiles/
├── nvim/        init.lua, lua/, lazy-lock.json   →  ~/.config/nvim
├── ghostty/     config                           →  ~/.config/ghostty
├── starship/    starship.toml                    →  ~/.config/starship
├── aerospace/   aerospace.toml                   →  ~/.config/aerospace
├── karabiner/   karabiner.json, rules.ts         →  ~/.config/karabiner
├── corne/       layout.vil                       →  ~/.config/corne
├── zsh/         .zshrc, .zprofile                →  ~
├── zen/         zen-keyboard-shortcuts.json      →  the active Zen profile
├── raycast/     scripts and AI presets           (not stowed)
└── bootstrap.sh
```

The non-obvious part: **the repo root itself is the stow package**, not each
subdirectory. `bootstrap.sh` runs

```sh
stow --target="$HOME/.config" .
```

so every top-level directory becomes one directory symlink
(`~/.config/nvim → ../dotfiles/nvim`). Stowing the subdirectories individually
would *not* do this — `stow --target=~/.config nvim` copies nvim's *contents*
into `~/.config`, producing `~/.config/init.lua`. That is the trap this layout
exists to avoid.

Because everything in the root gets linked, anything that does **not** belong
in `~/.config` has to be excluded in [`.stow-local-ignore`](.stow-local-ignore)
— currently `zsh`, `zen`, `raycast`, `bootstrap.sh`, `README.md` and the git
metadata. Patterns beginning with `/` are anchored at the repo root; a bare
name would match at any depth and could hit a nested file by accident.

Two packages have a different target and are therefore ignored by the root
package:

- **`zsh`** — `.zshrc` and `.zprofile` belong in `$HOME`.
- **`zen`** — Zen keeps its keyboard shortcuts inside the browser profile. The
  profile directory carries a random per-install prefix
  (`Profiles/gtsr0yef.Default (release)`), so `bootstrap.sh` resolves the active
  one from `profiles.ini` rather than hard-coding it. Note it reads the
  `[Install…]` section, which is what the running browser actually uses — the
  `Default=1` flag under `[ProfileN]` is an older, separate mechanism and on
  this machine it points at a *different* profile.

  **Quit Zen before stowing this package.** Zen rewrites
  `zen-keyboard-shortcuts.json` whenever a shortcut changes, and Mozilla-family
  code writes JSON by renaming a temp file over the target — which replaces a
  symlink with a regular file. `bootstrap.sh` cannot prevent that, so it checks
  for it instead and warns when the target is a regular file, meaning either it
  was never stowed or Zen overwrote the link.

> **Note:** providing a `.stow-local-ignore` file *replaces* stow's built-in
> default ignore list rather than extending it, which is why the VCS entries
> are spelled out in it.

---

## Packages

### `nvim`

A standalone `lazy.nvim` configuration — **not** LazyVim. Built for LaTeX,
Quarto and Python.

**[→ Full documentation: `nvim/README.md`](nvim/README.md)**

Structure:

```
nvim/
├── init.lua              requires the four core modules, nothing else
├── lua/core/
│   ├── options.lua       vim.opt settings, leader keys
│   ├── keymaps.lua       global keymaps (loaded before plugins)
│   ├── autocmds.lua      transparency, writing-filetype overrides
│   └── lazy.lua          bootstraps lazy.nvim, imports lua/plugins/
└── lua/plugins/
    ├── ui.lua            colorschemes, snacks, which-key, lualine, noice
    ├── writing.lua       treesitter, vimtex, quarto, obsidian, markdown
    ├── python.lua        molten (Jupyter), image.nvim, venv-selector
    ├── lsp.lua           blink.cmp, mason, lspconfig, conform
    ├── coding.lua        autopairs, mini.ai, mini.surround, ufo folds
    ├── search.lua        snacks pickers, telescope (Zotero citations only)
    └── ai.lua            avante, driving Claude Code over ACP
```

Leader is `Space`; local leader is `\`. Press `Space` and wait — which-key
lists everything. Groups:

| Prefix | Group | Prefix | Group |
| --- | --- | --- | --- |
| `<leader>a` | ai | `<leader>p` | python |
| `<leader>b` | buffer | `<leader>q` | quit / session / quarto |
| `<leader>c` | code | `<leader>r` | run |
| `<leader>e` | explorer (toggle) | `<leader>s` | sidekick / claude |
| `<leader>f` | find | `<leader>u` | ui |
| `<leader>g` | git | `<leader>v` | latex / citations |
| `<leader>l` | lazy | `<leader>x` | diagnostics |
| `<leader>m` | markdown | `<leader>o` | obsidian |

Most-used:

| Key | Action |
| --- | --- |
| `<leader>e` / `<leader>E` | file explorer — toggle / rooted at current file's dir |
| `<leader>ff` `<leader>fg` | find files / live grep |
| `<leader>qq` | quit all (prompts if unsaved) |
| `<leader>qw` | save all and quit |
| `<leader>qQ` | quit all, discarding changes |
| `<leader>gg` | lazygit |
| `<leader>vb` `<leader>vv` | compile LaTeX / view PDF |
| `<leader>qp` `<leader>qr` | Quarto preview / render |
| `<leader>pi` `<leader>pe` | Jupyter kernel init / evaluate cell |
| `<leader>u1`–`u4` | switch colorscheme |

### `zsh`

`.zprofile` sets `PATH`/`FPATH` (Homebrew first, `~/.local/bin` for pipx);
`.zshrc` handles everything interactive.

Prompt, completions and history tools are loaded through a small `_lazy_init`
helper that caches each tool's `init` output to `~/.cache/zsh/<tool>.zsh` and
regenerates it only when the binary is newer — this keeps startup fast for
starship, zoxide, atuin and fzf.

Notable: `cd` is zoxide (`\cd` is still the builtin), `cat` is `bat`, `ls` is
`eza`, Up-arrow is prefix history search and `Ctrl-R` is atuin.

### `starship`

Catppuccin Mocha prompt. Minimal on the left (directory + character), with git,
Python, conda and command duration right-aligned.

Because the config lives in `~/.config/starship/` rather than the default
`~/.config/starship.toml`, `.zshrc` exports:

```sh
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
```

Remove that line and starship silently falls back to its stock prompt.

### `ghostty`

Catppuccin Mocha, MesloLGS Nerd Font Mono, 92% opacity with background blur
(Neovim's colorschemes are all transparent, so the terminal background is what
shows through). Native macOS tabs, `cmd+d`/`cmd+shift+d` for splits.

Reload after editing with `cmd+shift+r`.

`macos-option-as-alt = false` is deliberate and layout-specific. This machine
uses the **German** layout, where the programming symbols are Option-composed
(`{}` = option+8/9, `[]` = option+5/6, `\` = option+shift+7, `|` = option+7,
`@` = option+l, `~` = option+n). Setting it to `true` makes Ghostty send those
as Alt sequences instead of characters — option+8 arrives as `ESC 8`, so in
Neovim the ESC leaves insert mode and the digit becomes a count. Ghostty only
defaults this to `true` for U.S. Standard and U.S. International layouts.

`right` is not sufficient: it frees only the left Option, and which Option key
you reach for is a matter of habit. The cost of `false` is Alt bindings whose
Option sequence composes a printable character — in practice just fzf's
`Alt-C`, since option+c is `ç` here. Option is still treated as Alt whenever
the sequence produces no printable character.

**This setting is applied when a surface is created — changing it requires a
full `Cmd+Q` and relaunch. A config reload (`cmd+shift+r`) or a new tab will
not pick it up.**

### `aerospace`

Tiling window manager, 20px gaps. Modifiers: `shift-alt-cmd` focuses/switches,
`ctrl-alt-cmd` moves.

| Key | Action |
| --- | --- |
| `shift-alt-cmd` + `h/j/k/l` | focus window |
| `ctrl-alt-cmd` + `h/j/k/l` | move window |
| `shift-alt-cmd` + `u/i/o/p` | workspace 1 / i / o / LaTeX |
| `ctrl-alt-cmd` + `u/i/o/p` | move window to that workspace |
| `shift-alt-cmd-f` | fullscreen |
| `shift-alt-cmd-tab` | back and forth |
| `shift-alt-cmd-m` | enter `manage` mode (`esc` reloads config, `r` flattens tree) |

### `karabiner`

Caps Lock → Hyper (`⌃⌥⇧⌘`), plus sublayers. Karabiner Elements reads
`karabiner.json`, but **edit `rules.ts`, not the JSON** — the JSON is generated:

```sh
cd karabiner
yarn install     # first time only
yarn build       # rules.ts → karabiner.json
yarn watch       # rebuild on save
```

`rules.ts` writes `karabiner.json` relative to its own directory, so the output
lands in this repo and Karabiner picks it up through the symlink immediately.

### `corne`

The Vial layout export for the Corne keyboard. Stowed to `~/.config/corne` for
a stable path to point Vial's file picker at — nothing reads it automatically,
so the symlink is for convenience rather than function.

The keyboard's own EEPROM is currently the source of truth; `layout.vil` is a
snapshot of it. [`KEYBINDINGS.md`](KEYBINDINGS.md) §7 proposes replacing this
with a `vial-qmk` source build (`keymap.c` in this repo), at which point the
repo becomes authoritative and this file is only a fallback.

### `zen`

`zen-keyboard-shortcuts.json` — all 141 shortcuts, currently at their defaults
with none customised. Stowed into the active browser profile; see the stow
section above for why it needs its own target and why **Zen must be quit
first**.

### `raycast`

Not stowed — no `~/.config` destination. Holds scripts and AI presets; the
compiled extension bundles are gitignored (~166 MB of build artifacts, and the
only source of gitleaks findings).

---

## Customizing

### Add a new package

1. `mkdir toolname/` and put the config files in it, laid out as they should
   appear inside `~/.config/toolname/`.
2. `./bootstrap.sh` — no edit to the script needed; the root package picks up
   any new directory automatically.

If the tool reads from `$HOME` rather than `~/.config`, add it to
`.stow-local-ignore` and give it its own `stow --target="$HOME"` line in
`bootstrap.sh`, the way `zsh` is handled.

### Add a Neovim plugin

Drop a file in `nvim/lua/plugins/` returning a lazy.nvim spec, or add to an
existing file. `lua/core/lazy.lua` imports the whole directory, so no
registration step:

```lua
return {
  { "owner/plugin.nvim", event = "VeryLazy", opts = {} },
}
```

Then `<leader>ls` (Lazy sync). Pin versions with `lazy-lock.json`, which is
tracked — commit it after updating to keep machines identical.

### Add an LSP server or formatter

Both live in `nvim/lua/plugins/lsp.lua`. Add the server to the `servers` table
(it is installed via `ensure_installed` automatically), and formatters to
`conform.nvim`'s `formatters_by_ft` plus `mason-tool-installer`'s
`ensure_installed`.

Format-on-save is deliberately **off** for `quarto`, `markdown` and `tex` —
reflowing prose mid-sentence is worse than useless. `<leader>cf` formats
manually.

### Change the colorscheme

Four are installed: catppuccin (default), tokyonight, kanagawa, rose-pine.
`<leader>u1`–`u4` switch live; `<leader>us` opens a picker. To change the
default, edit the `vim.cmd.colorscheme(...)` call in `nvim/lua/plugins/ui.lua`.

All four are configured transparent, which is what makes Ghostty's blur visible.
If you set `background-opacity = 1` in `ghostty/config`, turn transparency off
too or the theme will look flat.

Note that lualine uses `theme = "auto"` on purpose — hardcoding a theme there
would leave the statusline on the old palette after `<leader>u1`–`u4`.

### Change the prompt

`starship/starship.toml`. Segments are shared between `format` (left) and
`right_format` (right) — move a `$variable` between the two strings to
reposition it. Colors come from the `[palettes.catppuccin_mocha]` table at the
bottom; add any Catppuccin hex you need there and reference it by name.

---

## Secret scanning

`bootstrap.sh` points git at `.githooks/`, where a pre-commit hook scans staged
changes with gitleaks and aborts the commit on a hit.

The hook uses `git diff --cached | gitleaks stdin` deliberately. On gitleaks
8.30 both `gitleaks protect --staged` and `gitleaks git --staged` exit 0 on a
staged AWS key — they scan commits, not the staged diff — so a hook built on
either passes everything silently. This was verified with a canary.

False positives go in the `[allowlist]` in `.gitleaks.toml`, or a
`# gitleaks:allow` comment on the offending line. `git commit --no-verify`
bypasses the hook. If gitleaks is not installed the hook warns and exits 0
rather than blocking.

---

## Troubleshooting

**A config change did nothing.** Confirm the symlink resolves:
`ls -l ~/.config/nvim`. If it is missing, re-run `./bootstrap.sh`.

**Stow reports a conflict.** Something real already exists at the destination.
Inspect it, move it aside, then re-run. `./bootstrap.sh --check` shows exactly
what would be written without touching anything.

**Neovim health.** `:checkhealth` inside nvim. If it reports a *stale* config
path, check for an inherited `$MYVIMRC` — launching a shell from inside Neovim
exports it, and a nested nvim will honor the old value.

**Karabiner changes not applying.** You probably edited `karabiner.json`
directly; it is regenerated from `rules.ts` by `yarn build`.

**Option-composed characters (`{}`, `[]`, `\`, `|`, `@`, `~`) not typing in the
terminal**, or Neovim dropping out of insert mode when you press them. That is
`macos-option-as-alt` in `ghostty/config` — see the [ghostty](#ghostty) section.
It must not be `true` on a non-U.S. layout.
