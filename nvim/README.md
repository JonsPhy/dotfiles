# Scientific Neovim Configuration

A standalone Neovim configuration for scientific writing, data analysis, and
AI-assisted coding. Uses `lazy.nvim` as the plugin manager — not LazyVim.

The previous LazyVim-based setup was backed up at:

```text
backups/lazyvim_20260429_101214/
```

## Goals

- Write and compile LaTeX projects with VimTeX and Skim.
- Write Quarto documents with embedded Python/R/Julia support, including
  inline cell execution and plot output via molten.nvim.
- Run Python interactively with a live Jupyter kernel; see plots and output
  inline in the editor via molten.nvim.
- Render images, inline math, and document previews inside Neovim using
  snacks.nvim and the Kitty Graphics Protocol.
- Work comfortably in Python projects with LSP, completion, formatting, and
  virtual environment selection.
- Insert citations straight from the Zotero database through the
  telescope-zotero picker.
- Keep Obsidian note workflows available.
- Use Claude as the primary AI assistant — via avante.nvim for chat and
  diff-apply, and the Claude Code CLI in a snacks terminal for agentic tasks.
- Keep the config explicit, small, and easy to modify.

---

## Terminal: Kitty

This config is designed exclusively for the **Kitty** terminal emulator. Kitty
originated the Kitty Graphics Protocol (KGP), which is the foundation for all
inline image rendering in this setup.

**Required Kitty features used:**

- Kitty Graphics Protocol — for all inline image and plot rendering.
- Unicode placeholders — for true inline buffer image embedding.
- Native sessions — replaces tmux for window/tab management, avoiding image
  passthrough issues that occur with tmux.

**Install:**

```bash
brew install --cask kitty
```

> **Note:** If you use tmux alongside Kitty, add `set -gq allow-passthrough on`
> and `set -g visual-activity off` to your `tmux.conf`, or snacks.nvim will
> attempt to set this automatically. Using Kitty's native sessions is strongly
> preferred to avoid image rendering artifacts.

---

## Structure

```text
init.lua
lua/
├── core/
│   ├── autocmds.lua
│   ├── keymaps.lua
│   ├── lazy.lua
│   └── options.lua
└── plugins/
    ├── ai.lua          ← avante.nvim (Claude Code over ACP)
    ├── coding.lua
    ├── lsp.lua
    ├── python.lua      ← molten.nvim + venv-selector
    ├── search.lua      ← snacks.picker + Telescope (Zotero citations)
    ├── snacks.lua      ← placeholder; snacks.nvim is configured in ui.lua
    ├── ui.lua          ← snacks.nvim (dashboard, image, notifier, etc.)
    └── writing.lua     ← VimTeX, quarto-nvim, otter.nvim, obsidian.nvim
spell/
├── de.utf-8.spl
└── de.utf-8.sug
```

---

## Bootstrap

`init.lua` loads the config in this order:

1. `lua/core/options.lua`
2. `lua/core/keymaps.lua`
3. `lua/core/autocmds.lua`
4. `lua/core/lazy.lua`

`lua/core/lazy.lua` bootstraps `folke/lazy.nvim` into Neovim's data directory
if it is missing, then imports every plugin spec under `lua/plugins/`.

The lockfile is `lazy-lock.json`; commit it when plugin versions change
intentionally.

---

## Core Behavior

Leader keys:

- Leader: `<Space>`
- Local leader: `\`

Important editor defaults:

- Line numbers and relative line numbers are enabled.
- System clipboard integration uses `unnamedplus`.
- Spell checking is enabled for English and German.
- Wrapping and line breaking are enabled globally and reinforced for writing
  filetypes.
- Persistent undo is enabled.
- Quarto files, `*.qmd`, are assigned the `quarto` filetype.
- Folds are enabled, open by default, and delegated to `nvim-ufo` when
  possible.

---

## Keymaps

Leader groups (mirrors the which-key spec in `lua/plugins/ui.lua`):

| Prefix | Group | Prefix | Group |
| --- | --- | --- | --- |
| `<leader>a` | ai | `<leader>q` | quit (and nothing else) |
| `<leader>b` | buffer | `<leader>r` | run (incl. Quarto) |
| `<leader>c` | code | `<leader>s` | session |
| `<leader>e` | explorer | `<leader>t` | terminal |
| `<leader>f` | find | `<leader>u` | ui |
| `<leader>g` | git | `<leader>v` | latex |
| `<leader>l` | lazy | `<leader>x` | diagnostics |
| `<leader>m` | markdown | | |
| `<leader>n` | notes (Obsidian) | | |
| `<leader>p` | python | | |

General:

| Key | Action |
| --- | --- |
| `<leader><Space>` | Save the current file. |
| `<leader>rf` | Save and run the current file with `python3 %`. |
| `ga` | Jump backward in the jumplist. |
| `gA` | Jump forward in the jumplist. |
| `<leader>ut` | Reapply transparent background highlights. |
| `<leader>us` | Open the snacks colorscheme picker with preview. |
| `<leader>u1` | Switch to Tokyonight. |
| `<leader>u2` | Switch to Catppuccin. |
| `<leader>u3` | Switch to Kanagawa. |
| `<leader>u4` | Switch to Rose Pine. |
| `<leader>uh` | Clear search highlights. |
| `<C-h/j/k/l>` | Move between windows. |

Package management:

| Key | Action |
| --- | --- |
| `<leader>ll` | Open Lazy package manager. |
| `<leader>li` | Install missing plugins. |
| `<leader>ls` | Sync plugins and clean removed ones. |
| `<leader>lu` | Update plugins. |
| `<leader>lc` | Check for plugin updates. |
| `<leader>lx` | Clean unused plugins. |
| `<leader>lp` | Show Lazy startup/profile view. |

Sessions (persistence.nvim):

| Key | Action |
| --- | --- |
| `<leader>ss` | Select a saved session. |
| `<leader>sl` | Load the session for the current directory. |
| `<leader>sd` | Stop saving the current session. |

Search (snacks.picker):

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files. |
| `<leader>fg` | Live grep. |
| `<leader>fb` | Open buffers. |
| `<leader>fh` | Help tags. |
| `<leader>fr` | Recent files. |
| `<leader>fn` | Notification history. |

Citations are the one picker still on Telescope: `<leader>vc` in TeX buffers,
`<leader>nc` in Markdown, Quarto, and R Markdown.

LaTeX:

| Key | Action |
| --- | --- |
| `<leader>vc` | Insert Zotero citation (TeX buffers). |
| `<leader>vb` | Compile with VimTeX. |
| `<leader>vs` | Stop VimTeX compilation. |
| `<leader>vv` | View PDF in Skim. |
| `<leader>vt` | Open VimTeX table of contents. |
| `<leader>vl` | Clean generated LaTeX files. |
| `<leader>ve` | Show VimTeX errors. |
| `<leader>vi` | Show VimTeX info. |

Quarto and Markdown (the `run` group):

| Key | Action |
| --- | --- |
| `<leader>rp` | Preview Quarto document (browser). |
| `<leader>rr` | Render Quarto document (`quarto render` in a snacks terminal). |
| `<leader>rc` | Close Quarto preview. |
| `<leader>ra` | Activate Quarto LSP for the buffer. |
| `<leader>rh` | Quarto help. |
| `<leader>mp` | Toggle Markdown preview. |

Python (molten cell execution lives here too):

| Key | Action |
| --- | --- |
| `<leader>pv` | Select Python virtual environment. |
| `<leader>pi` | Initialize Jupyter kernel (molten). |
| `<leader>pe` | Evaluate motion or visual selection (molten). |
| `<leader>pc` | Execute current code cell (molten). |
| `<leader>pC` | Execute all cells (molten). |
| `<leader>ph` | Hide output window (molten). |
| `<leader>ps` | Show output window (molten). |

Notes (Obsidian):

| Key | Action |
| --- | --- |
| `<leader>nn` | Create note. |
| `<leader>nt` | Insert template. |
| `<leader>nd` | Open daily note. |
| `<leader>ns` | Search notes. |
| `<leader>nc` | Insert Zotero citation (Markdown, Quarto, R Markdown). |

AI:

| Key | Action |
| --- | --- |
| `<leader>at` | Toggle the avante.nvim chat panel. |
| `<leader>aa` | Ask avante about the buffer or selection. |
| `<leader>an` | Start a new avante chat. |
| `<leader>ah` | Browse avante chat history. |
| `<leader>am` | Switch the avante model (`:AvanteACPModels`). |
| `<leader>tc` | Toggle the Claude Code CLI in a snacks terminal. |

---

## Interface

The UI layer lives in `lua/plugins/ui.lua` and is built entirely on
`folke/snacks.nvim`.

### snacks.nvim

`snacks.nvim` is the central UI and utility layer, replacing alpha-nvim and
several standalone quality-of-life plugins.

Enabled snacks modules:

| Module | Purpose |
| --- | --- |
| `snacks.dashboard` | Start page, replaces alpha-nvim. |
| `snacks.image` | Inline image and math rendering via Kitty Graphics Protocol. |
| `snacks.picker` | Fuzzy finder for files, grep, buffers, etc. Replaces Telescope for everything but citations. |
| `snacks.explorer` | Sidebar file tree (`<leader>e`). |
| `snacks.notifier` | Prettier `vim.notify` notifications. |
| `snacks.indent` | Indent guides and scope highlighting. |
| `snacks.scope` | Scope detection for text objects. |
| `snacks.scroll` | Smooth scrolling. |
| `snacks.statuscolumn` | Configurable status column. |
| `snacks.words` | Highlight other uses of the word under cursor. |
| `snacks.input` | Better `vim.ui.input`. |
| `snacks.quickfile` | Fast initial file rendering before plugins load. |
| `snacks.bigfile` | Disables heavy features for very large files. |

**Diagnosis:** Run `:checkhealth snacks` to verify Kitty terminal detection,
unicode placeholder support, ImageMagick availability, and Treesitter parsers
for image-enabled document types.

### Dashboard

`snacks.dashboard` replaces alpha-nvim with a start page containing:

- SCI VIM logo header.
- File search, explorer, live grep, recent files, recent sessions.
- Lazy package management shortcut.
- Theme selection and help.
- Quit action.

### which-key.nvim

`which-key.nvim` is kept alongside snacks.nvim for the leader-key cheatsheet.
It uses rounded borders, compact spacing, and named groups for: AI, buffer,
code, explorer, find, git, Lazy, Markdown, notes, Python, quit, run, session,
terminal, UI, LaTeX, and diagnostics. See the leader-group table above.

### Colorschemes

Curated rather than exhaustive: Tokyonight, Catppuccin, Kanagawa, Rose Pine.
Use `<leader>us` for the snacks colorscheme picker.

---

## Image & Graphics Rendering

This is the most layered part of the setup. Two plugins share responsibility
depending on the context.

### snacks.image — document and buffer images

`snacks.image` handles all image rendering that is not Jupyter cell output:

- Inline images in Markdown buffers (referenced by path or URL).
- Inline math expressions in LaTeX and Markdown, rendered via pdflatex/tectonic
  → PNG pipeline and cached after the first render.
- Images and diagrams in HTML, Typst, and other supported document types.
- PDF previews (page-by-page bitmap rendering via ImageMagick + Ghostscript).
- Image preview in snacks.picker file browser.

Rendering modes (configured per environment):

- **Inline mode:** Images are embedded directly into the buffer text using
  Kitty unicode placeholders. Requires Kitty with unicode placeholder support
  (verify with `:checkhealth snacks`).
- **Float mode:** Fallback when inline is unavailable; image appears in an
  overlay floating window.

Supported input formats: `png`, `jpg`, `jpeg`, `gif`, `bmp`, `webp`, `tiff`,
`heic`, `avif`, `mp4`, `mov`, `avi`, `mkv`, `webm`, `pdf`, `icns`.

Supported document types for inline rendering: `markdown`, `html`, `latex`,
`typst`, `norg`, `tsx`, `javascript`, `css`, `vue`, `svelte`, `scss`.

Math rendering packages included by default: `amsmath`, `amssymb`, `amsfonts`,
`amscd`, `mathtools`.

**Minimal config (`lua/plugins/ui.lua`):**

```lua
image = {
  enabled = true,
  doc = {
    enabled = true,
    inline = true,
    float = true,
    max_width = 80,
    max_height = 40,
  },
},
```

### image.nvim — molten cell output

`3rd/image.nvim` is kept specifically as the image rendering backend for
`molten.nvim`. snacks.image does not yet support molten's image provider
interface.

It uses the `kitty` backend and must be configured with generous
`max_height_window_percentage` values so molten output windows render at the
correct size.

**Config (`lua/plugins/python.lua`):**

```lua
{
  "3rd/image.nvim",
  opts = {
    backend = "kitty",
    max_width = 100,
    max_height = 12,
    max_height_window_percentage = math.huge,
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  },
},
```

### Known hard limitation

Interactive 3D plot rotation (e.g., Plotly 3D scatter, surface plots) is not
possible inside the terminal. The Kitty Graphics Protocol renders bitmap images
— it cannot host a WebGL/HTML canvas. Plotly 3D figures are displayed as
static PNG previews inline via molten; the fully interactive version opens
automatically in the browser. This is a fundamental constraint of all terminal
emulators, not a configuration issue.

---

## Python & Data Science

### molten.nvim — interactive Jupyter execution

`benlubas/molten-nvim` provides Jupyter-style cell execution inside Neovim.
It connects to a running Jupyter kernel and displays output inline below each
cell as a floating window. It is used for both standalone Python scripts and
Quarto `.qmd` files.

**Supported output types:**

- Plain text and tracebacks.
- Matplotlib/Seaborn plots — rendered as inline PNG via image.nvim.
- Plotly figures — rendered to static PNG via Kaleido, shown inline.
- LaTeX formulas — rendered to PNG via pnglatex, shown inline.
- Rich HTML output.

**Config (`lua/plugins/python.lua`):**

```lua
{
  "benlubas/molten-nvim",
  version = "^1.0.0",
  dependencies = { "3rd/image.nvim" },
  build = ":UpdateRemotePlugins",
  init = function()
    vim.g.molten_image_provider = "image.nvim"
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = true
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
  end,
},
```

**Required Python packages:**

```bash
pip install pynvim jupyter-client ipykernel \
            plotly kaleido matplotlib pillow \
            cairosvg pnglatex pyperclip nbformat
```

### jupytext.nvim

`GCBallesteros/jupytext.nvim` allows editing `.ipynb` files as clean `.py` or
`.qmd` text files and converting back on save, so notebooks integrate cleanly
with Git and the Neovim editing model.

### venv-selector.nvim

`linux-cultist/venv-selector.nvim` provides virtual environment selection via
`<leader>pv`. Uses `fd` for discovery if available.

---

## Writing Stack

### LaTeX

VimTeX is configured for macOS and Skim:

```lua
vim.g.vimtex_view_method = "skim"
```

Compilation uses `latexmk` with output in `../out` and these options:

- `-pdf`
- `-bibtex`
- `-interaction=nonstopmode`
- `-file-line-error`
- `-synctex=1`
- `-shell-escape`
- `-f`

Conceal, matchparen, VimTeX folding, VimTeX indentation, TOC background work,
and VimTeX completion are disabled for a lighter editing experience.

Inline LaTeX math expressions in `.tex` and Markdown files render as PNG
bitmaps directly in the buffer via snacks.image + tectonic/pdflatex.

### Quarto

Quarto support is provided by `quarto-dev/quarto-nvim` and `jmbuhr/otter.nvim`.
It is used in two complementary modes:

- **Full render** (`<leader>rr`): runs `quarto render` in a snacks terminal so
  the render log stays readable. Used for reviewing the final document.
  `<leader>rp` opens the live preview in the browser.
- **Inline execution** (`<leader>pc`): runs the cell under the cursor via
  molten.nvim and displays output inline, without a full render. Used during
  active writing and analysis.

Embedded language support is enabled for: R, Python, Julia, Bash, HTML.

### Citations

`jmbuhr/telescope-zotero.nvim` backs the citation picker. Telescope is kept in
this config for that one purpose; everything else uses snacks.picker.

The picker reads the Zotero SQLite database directly — there is no BibTeX
export step and no "keep updated" auto-export to maintain:

```text
~/Zotero/zotero.sqlite     library and citation keys
~/Zotero/storage           attachments
```

Citation keys come from Zotero's native `citationKey` field, which Better
BibTeX now writes into `zotero.sqlite`; the old `better-bibtex.sqlite` is no
longer read.

Picking an entry inserts the citation and appends **only that entry** to the
project `.bib` named by `\addbibresource{}` / `\bibliography{}` in TeX or
`bibliography:` in Quarto, skipping it if the key is already present. So the
project bibliography stays small enough to read in a diff and hand-added
entries are never dropped.

Triggers, and the format inserted per filetype:

| Key | Filetypes | Inserts |
| --- | --- | --- |
| `<leader>vc` | `tex` | `\citep{key}` |
| `<leader>nc` | `markdown`, `quarto`, `rmd` | `[@key]` |

### Obsidian

`epwalsh/obsidian.nvim` manages note workflows. Configured workspaces:

```text
/Users/jonasvonstein/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault
/Users/jonasvonstein/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault/projects/BachelorThesis
```

Daily notes use `Daily Notes` with `%Y-%m-%d` filenames. Templates are loaded
from `Templates`.

---

## AI Stack

The AI layer is two things with distinct roles: avante.nvim, configured in
`lua/plugins/ai.lua`, and a plain terminal toggle for the Claude Code CLI,
defined in `lua/core/keymaps.lua`. Both drive the same local `claude` binary,
so there is one authentication and one MCP configuration between them.

### avante.nvim — chat, image/PDF input, diff-apply

`yetone/avante.nvim` is the primary interactive AI interface. It provides a
Cursor-like side panel within Neovim.

**Key capabilities:**

- Chat with Claude (or other providers) without leaving Neovim.
- **Paste images and PDFs directly into the chat** — drag-and-drop or paste
  from clipboard. Claude can reason about plots, figures, or paper excerpts
  you share.
- Agentic mode: proposes code changes and applies them to buffers as diffs;
  accept or reject changes line-by-line.
- Context control: add files, selections, or diagnostics to the conversation
  with a keypress.
- Drives the local `claude` binary over the Agent Client Protocol, so
  authentication is Claude Code's own — no API keys in the Neovim config.

Avante's ~20 default keymaps are disabled (`behaviour.auto_set_keymaps`); only
the five below are bound, which keeps the rest of `<leader>a` free.

**Config (`lua/plugins/ai.lua`):**

```lua
{
  "yetone/avante.nvim",
  event = "VeryLazy",
  opts = {
    provider = "claude-code",
    mode = "agentic",
    acp_providers = {
      ["claude-code"] = { command = "claude-agent-acp" },
    },
  },
  build = "make",
},
```

The full spec also pins `CLAUDE_CODE_EXECUTABLE` to the native arm64 `claude`
at `/opt/homebrew/bin/claude`. The x86_64 cask in `/usr/local/bin` is
Bun-compiled and needs AVX, which Rosetta does not emulate, so it hangs on
startup — and it comes first on `PATH`. See the comments in `ai.lua`.

**Keymaps:**

| Key | Action |
| --- | --- |
| `<leader>at` | Toggle avante chat panel. |
| `<leader>aa` | Ask about the buffer or selection. |
| `<leader>an` | New chat. |
| `<leader>ah` | Chat history. |
| `<leader>am` | Switch model (`:AvanteACPModels`). |

### Claude Code CLI in a snacks terminal

For larger, multi-file refactoring and autonomous agentic work — where Claude
Code needs file system access and shell execution — `<leader>tc` toggles the
**Claude Code CLI** in a `Snacks.terminal` split rooted at the current working
directory. There is no wrapper plugin: it is a single `Snacks.terminal.toggle`
in `lua/core/keymaps.lua`, and it resolves the same native arm64 binary avante
uses.

Claude Code runs with its own authentication (set up once with `claude /login`)
and its own MCP server configuration.

Use avante for conversation, targeted edits, and image/PDF input; use the
terminal toggle when you want the full CLI.

**Keymaps:**

| Key | Action |
| --- | --- |
| `<leader>tc` | Toggle the Claude Code CLI terminal. |

**Install Claude Code:**

```bash
npm install -g @anthropic-ai/claude-code
npm install -g @agentclientprotocol/claude-agent-acp
claude /login
```

---

## Language Tooling

LSP servers configured through Mason and `nvim-lspconfig`:

- `lua_ls`
- `pyright`
- `r_language_server`
- `texlab`
- `marksman`
- `jsonls`
- `taplo`

Formatters configured through `conform.nvim`:

- Lua: `stylua`
- Python: `isort`, then `black`
- Shell: `shfmt`
- TeX: `latexindent`

Format on save is enabled for most programming files. It is disabled for
Markdown, Quarto, and TeX so prose and manuscripts are not rewritten
unexpectedly. `<leader>cf` formats the buffer on demand.

---

## Full Plugin Reference

| Plugin | Purpose | Replaces |
| --- | --- | --- |
| `folke/snacks.nvim` | Dashboard, image rendering, picker, explorer, terminal, notifier, QoL | alpha-nvim, Telescope |
| `folke/persistence.nvim` | Per-project session save and restore | — |
| `folke/which-key.nvim` | Leader-key cheatsheet | — |
| `benlubas/molten-nvim` | Jupyter kernel execution, inline cell output | — |
| `3rd/image.nvim` | Image backend for molten cell output | — |
| `GCBallesteros/jupytext.nvim` | `.ipynb` ↔ `.qmd`/`.py` round-tripping | — |
| `quarto-dev/quarto-nvim` | Quarto document editing and preview | — |
| `jmbuhr/otter.nvim` | Embedded language LSP completion | — |
| `lervag/vimtex` | LaTeX editing, compilation, Skim sync | — |
| `epwalsh/obsidian.nvim` | Obsidian note workflows | — |
| `jmbuhr/telescope-zotero.nvim` | Zotero citation picker (with `telescope.nvim`) | telescope-bibtex |
| `yetone/avante.nvim` | AI chat, image/PDF input, diff-apply | Copilot Chat, ChatGPT.nvim |
| `linux-cultist/venv-selector.nvim` | Python virtual environment picker | — |
| `stevearc/conform.nvim` | Formatting | — |
| `nvim-ufo` | Fold management | — |

---

## System Dependencies

Install these outside Neovim before running `:Lazy sync`:

```bash
# Terminal
brew install --cask kitty

# Core
brew install git fd ripgrep

# Image rendering
brew install imagemagick     # required by snacks.image and image.nvim
brew install ghostscript     # required for PDF rendering in snacks.image

# LaTeX math rendering (snacks.image)
brew install tectonic
# alternatively: brew install --cask mactex  (full TeX distribution)

# Mermaid diagram rendering
brew install mermaid-js/formula/mmdc

# Python kernel (for molten.nvim)
pip install pynvim jupyter-client ipykernel \
            plotly kaleido matplotlib pillow \
            cairosvg pnglatex pyperclip nbformat

# Claude Code CLI (for the <leader>tc terminal toggle and avante's ACP provider)
npm install -g @anthropic-ai/claude-code
npm install -g @agentclientprotocol/claude-agent-acp
claude /login

# LaTeX compilation (VimTeX)
# brew install --cask mactex  (if not using tectonic above)
brew install latexmk

# PDF viewer
brew install --cask skim

# Optional
brew install node    # for markdown-preview.nvim
```

Inside Neovim, run in order:

```vim
:Lazy sync
:Mason
:checkhealth snacks
:checkhealth
```

---

## Capability Summary

| Feature | Status | Notes |
| --- | --- | --- |
| Inline images in Markdown/LaTeX buffers | ✅ | snacks.image + Kitty |
| Inline math expressions in LaTeX/Markdown | ✅ | snacks.image + tectonic/pdflatex |
| Python plot output inline (matplotlib, seaborn) | ✅ | molten.nvim + image.nvim |
| Plotly figure preview inline (static) | ✅ | molten.nvim + Kaleido → PNG 
| Interactive 3D plot rotation in terminal | ❌ | Not possible in any terminal; opens in browser |
| Quarto cell execution inline (no full render) | ✅ | molten.nvim integrated with quarto-nvim |
| Quarto full document preview | ✅ | Browser / Skim via quarto-nvim |
| LaTeX PDF preview | ✅ | Skim with SyncTeX |
| PDF page preview inside Neovim | ✅ | snacks.image + Ghostscript |
| AI chat with image/PDF paste | ✅ | avante.nvim |
| AI agentic coding (multi-file, shell) | ✅ | Claude Code CLI in a snacks terminal (`<leader>tc`) |
| Inline AI diff-apply | ✅ | avante.nvim agentic mode |
| snacks.image as molten image provider | ⚠️ | Not yet upstream; image.nvim still used for molten |

---

## Restoring The Old Setup

The old LazyVim-based setup is not permanently deleted. To inspect or restore:

```text
backups/lazyvim_20260429_101214/
```

That backup contains the previous `init.lua`, `lua/`, `lazyvim.json`,
`lazy-lock.json`, README, spell files, and local project metadata.
