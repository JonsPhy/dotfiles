# Neovim Configuration

This directory is a LazyVim-based Neovim setup with a small custom layer for
writing, LaTeX, citations, Obsidian notes, folding, transparent UI, Python
helpers, spell checking, Copilot, and ChatGPT tooling.

The entry point is `init.lua`, which loads `lua/config/lazy.lua`. Lazy.nvim then
loads LazyVim's default plugin distribution, the LazyVim extras listed in
`lazyvim.json`, and every plugin spec under `lua/plugins/`.

## Quick Recreate

To recreate this setup on a new machine:

1. Install Neovim, Git, and a terminal with a Nerd Font.
2. Put this directory at `~/.config/nvim`.
3. Start Neovim once:

   ```sh
   nvim
   ```

4. Lazy.nvim bootstraps itself into Neovim's data directory if it is missing.
5. Run `:Lazy restore` to install plugin versions pinned in `lazy-lock.json`.
6. Run `:Mason` and install any missing external tools requested by the LazyVim
   extras you use.
7. For the writing workflow, install the external tools listed below:
   `latexmk`, a TeX distribution, Skim, Python 3, Zotero bibliography export,
   and an Obsidian vault at the configured paths.

The setup is macOS-oriented. The LaTeX viewer is set to Skim, and several paths
point to `/Users/jonasvonstein/...`.

## Directory Map

```text
.
|-- init.lua
|-- lazy-lock.json
|-- lazyvim.json
|-- stylua.toml
|-- spell/
|   |-- de.utf-8.spl
|   `-- de.utf-8.sug
`-- lua/
    |-- config/
    |   |-- autocmds.lua
    |   |-- keymaps.lua
    |   |-- lazy.lua
    |   `-- options.lua
    `-- plugins/
        |-- autopairs.lua
        |-- colorscheme.lua
        |-- obsidian.lua
        |-- telescope.lua
        |-- chatgpt.lua
        |-- ufo.lua
        `-- vimtex.lua
```

## Bootstrap And Plugin Loading

`init.lua` only does this:

```lua
require("config.lazy")
```

`lua/config/lazy.lua` bootstraps `folke/lazy.nvim` from GitHub when it is not
already installed at:

```text
vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
```

Lazy.nvim is configured with:

- `LazyVim/LazyVim`, imported through `lazyvim.plugins`.
- Local plugin specs from `lua/plugins`.
- `defaults.lazy = false`, so custom plugins are not lazy-loaded unless their
  own spec says otherwise.
- `defaults.version = false`, so plugins track Git commits rather than release
  tags.
- Install fallback colorschemes: `tokyonight`, then `habamax`.
- Update checker enabled, notifications disabled.
- Runtime plugins disabled: `gzip`, `tarPlugin`, `tohtml`, `tutor`,
  `zipPlugin`.

The exact plugin commits are pinned in `lazy-lock.json`.

## LazyVim Extras

`lazyvim.json` enables these LazyVim extras:

| Extra | Purpose |
| --- | --- |
| `lazyvim.plugins.extras.ai.copilot` | GitHub Copilot integration |
| `lazyvim.plugins.extras.ai.copilot-chat` | Copilot Chat integration |
| `lazyvim.plugins.extras.coding.mini-surround` | Surround text objects/actions |
| `lazyvim.plugins.extras.editor.telescope` | Telescope as the picker UI |
| `lazyvim.plugins.extras.lang.json` | JSON language support |
| `lazyvim.plugins.extras.lang.markdown` | Markdown language support |
| `lazyvim.plugins.extras.lang.python` | Python language support |
| `lazyvim.plugins.extras.lang.tex` | TeX/LaTeX language support |
| `lazyvim.plugins.extras.lang.toml` | TOML language support |
| `lazyvim.plugins.extras.vscode` | VS Code compatibility support |

This means many mappings, LSP servers, Treesitter parsers, formatters, and UI
features come from LazyVim itself. This README documents the local layer and the
enabled extras; for the inherited defaults, use LazyVim's documentation together
with the pinned LazyVim commit in `lazy-lock.json`.

## Options

`lua/config/options.lua` adds only three global editor options on top of
LazyVim's defaults:

| Option | Value | Effect |
| --- | --- | --- |
| `vim.opt.spell` | `true` | Spell checking is enabled globally. |
| `vim.opt.spelllang` | `{ "en_us", "de_de" }` | English and German spell checking. |
| `vim.opt.wrap` | `true` | Long lines wrap visually. |

German spell files are committed in `spell/de.utf-8.spl` and
`spell/de.utf-8.sug`.

## Autocommands

`lua/config/autocmds.lua` creates the `TransparentBG` augroup.

On every `ColorScheme` event it clears the background for:

- `Normal`
- `NonText`
- `EndOfBuffer`

This keeps the main editing background transparent even after switching or
reloading colorschemes.

## Keybindings

LazyVim uses `<Space>` as the leader key. The custom mappings are listed below.

### General

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `<leader><Space>` | Write the current file with `:w`. |
| Normal | `<leader>rr` | Run the current file with `python3 %`. |
| Normal | `ga` | Jump back in the jumplist with `<C-o>`. |
| Normal | `gA` | Jump forward in the jumplist with `<C-i>`. |
| Normal | `<leader>ut` | Clear `Normal` background with `:hi Normal guibg=NONE`. |

The Telescope config disables LazyVim's default `<leader><space>` mapping before
`lua/config/keymaps.lua` reuses the same key for saving.

### Folding

Defined by `lua/plugins/ufo.lua`:

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `zR` | Open all folds through nvim-ufo. |
| Normal | `zM` | Close all folds through nvim-ufo. |
| Normal | `zK` | Peek folded lines under the cursor, falling back to LSP hover. |

### Citations

Defined by `lua/plugins/telescope.lua`:

| Mode | Key | Filetypes | Action |
| --- | --- | --- | --- |
| Normal | `<leader>vc` | `tex`, `markdown`, `md` | Open Telescope BibTeX picker. |

Inside the BibTeX picker, insert-mode mappings are:

| Mode | Key | Action |
| --- | --- | --- |
| Insert | `<CR>` | Append citation key according to filetype/default format. |
| Insert | `<C-e>` | Append the full BibTeX entry. |
| Insert | `<C-c>` | Append formatted citation text: `{{author}} ({{year}}), {{title}}.` |

### LaTeX

Defined by `lua/plugins/vimtex.lua`:

| Mode | Key | Command | Action |
| --- | --- | --- | --- |
| Normal | `<leader>vb` | `:VimtexCompile` | Compile the current LaTeX project. |
| Normal | `<leader>vs` | `:VimtexStop` | Stop compilation. |
| Normal | `<leader>vv` | `:VimtexView` | Open or focus the PDF viewer. |
| Normal | `<leader>vt` | `:VimtexTocOpen` | Open VimTeX table of contents. |
| Normal | `<leader>vl` | `:VimtexClean` | Clean generated LaTeX files. |
| Normal | `<leader>ve` | `:VimtexErrors` | Show VimTeX errors. |
| Normal | `<leader>vi` | `:VimtexInfo` | Show VimTeX status/config info. |

`<leader>v` is registered as the LaTeX key group.

### Obsidian

Defined by `lua/plugins/obsidian.lua` and active for Markdown buffers:

| Mode | Key | Command | Action |
| --- | --- | --- | --- |
| Normal | `<leader>on` | `:ObsidianNew` | Create a new note. |
| Normal | `<leader>ot` | `:ObsidianTemplate` | Insert/use a template. |
| Normal | `<leader>od` | `:ObsidianToday` | Open today's daily note. |
| Normal | `<leader>os` | `:ObsidianSearch` | Search notes. |

`<leader>o` is registered as the Obsidian group with a Nerd Font icon.

### ChatGPT

`lua/plugins/chatgpt.lua` adds `jackMort/ChatGPT.nvim` and declares a
ChatGPT key group. The file uses a nested `keys` table shaped like an older
which-key mapping declaration:

| Key suffix | Command |
| --- | --- |
| `c` | `:ChatGPT` |
| `e` | `:ChatGPTEditWithInstruction` |
| `g` | `:ChatGPTRun grammar_correction` |
| `t` | `:ChatGPTRun translate` |
| `k` | `:ChatGPTRun keywords` |
| `d` | `:ChatGPTRun docstring` |
| `a` | `:ChatGPTRun add_tests` |
| `o` | `:ChatGPTRun optimize_code` |
| `s` | `:ChatGPTRun summarize` |
| `f` | `:ChatGPTRun fix_bugs` |
| `x` | `:ChatGPTRun explain_code` |
| `r` | `:ChatGPTRun roxygen_edit` |
| `l` | `:ChatGPTRun code_readability_analysis` |

The intended prefix is the `c` group as declared in that file. If these mappings
do not appear in which-key, convert the table to Lazy.nvim's current flat `keys`
format.

## Custom Plugins

### Tokyonight

File: `lua/plugins/colorscheme.lua`

The setup customizes `tokyonight.nvim`:

- Transparent main background.
- Transparent sidebars.
- Transparent floating windows.

LazyVim's install fallback also includes `tokyonight`, so this is the primary
intended colorscheme.

### Nvim UFO Folding

File: `lua/plugins/ufo.lua`

Plugin: `kevinhwang91/nvim-ufo`

Dependency:

- `kevinhwang91/promise-async`

Load event:

- `BufReadPost`

Runtime fold settings:

| Setting | Value | Effect |
| --- | --- | --- |
| `foldcolumn` | `"1"` | Show one fold column. |
| `foldlevel` | `99` | Keep folds open by default. |
| `foldlevelstart` | `99` | Start buffers unfolded. |
| `foldenable` | `true` | Enable folding. |

Provider priority is LSP first, then indent:

```lua
return { "lsp", "indent" }
```

### Telescope And BibTeX

File: `lua/plugins/telescope.lua`

Plugin: `nvim-telescope/telescope.nvim`

Dependency:

- `nvim-telescope/telescope-bibtex.nvim`

Ignored file patterns in Telescope:

- `*.aux`
- `*.out`
- `*.toc`
- `*.fls`
- `*.log`
- `*.blg`
- `*.bbl`
- `*.gz`
- `*.fdb_latexmk`

BibTeX extension settings:

| Setting | Value |
| --- | --- |
| `depth` | `1` |
| `global_files` | `/Users/jonasvonstein/Zotero/references.bib` |
| `search_keys` | `author`, `year`, `title` |
| `citation_format` | `{{author}} ({{year}}), {{title}}.` |
| `citation_trim_firstname` | `true` |
| `citation_max_auth` | `2` |
| `context` | `false` |
| `context_fallback` | `true` |
| `wrap` | `false` |

The extension is loaded with:

```lua
require("telescope").load_extension("bibtex")
```

### Autopairs

File: `lua/plugins/autopairs.lua`

Plugin: `windwp/nvim-autopairs`

Options:

- `fast_wrap = {}`
- Disabled in `TelescopePrompt` and `vim` filetypes.

Additional custom rule:

- In `tex` and `markdown`, `$` pairs with `$`.
- The rule allows moving through an existing closing `$` when the previous
  character matches the configured condition.

### Obsidian

File: `lua/plugins/obsidian.lua`

Plugin: `epwalsh/obsidian.nvim`

Version:

- `"*"`

Load behavior:

- Lazy-loaded.
- Loaded for Markdown filetypes.

Dependency:

- `nvim-lua/plenary.nvim`

Workspaces:

| Name | Path |
| --- | --- |
| `thesis` | `/Users/jonasvonstein/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault/projects/BachelorThesis` |
| `vault` | `/Users/jonasvonstein/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault` |

Options:

| Setting | Value |
| --- | --- |
| `disable_frontmatter` | `true` |
| `note_id_func` | Returns the title unchanged. |
| `completion.nvim_cmp` | `false` |
| `daily_notes.folder` | `Daily Notes` |
| `daily_notes.date_format` | `%Y-%m-%d` |
| `daily_notes.alias_format` | `%B %-d, %Y` |
| `templates.subdir` | `Templates` |
| `templates.date_format` | `%Y-%m-%d` |
| `templates.time_format` | `%H:%M` |

### VimTeX

File: `lua/plugins/vimtex.lua`

Plugin: `lervag/vimtex`

Viewer:

```lua
vim.g.vimtex_view_method = "skim"
```

Forward search and automatic viewing are disabled:

```lua
vim.g.vimtex_view_forward_search_on_start = 0
vim.g.vimtex_view_automatic = 0
```

Compiler:

```lua
vim.g.vimtex_compiler_method = "latexmk"
```

Latexmk output directory:

```text
../out
```

Latexmk options:

- `-pdf`
- `-bibtex`
- `-interaction=nonstopmode`
- `-file-line-error`
- `-synctex=1`
- `-shell-escape`
- `-f`

Performance-oriented VimTeX settings:

| Setting | Value |
| --- | --- |
| `vimtex_syntax_conceal` | accents, ligatures, greek, math bounds, delimiters, and styles disabled |
| `tex_conceal` | empty string |
| `vimtex_matchparen_enabled` | `0` |
| `vimtex_fold_enabled` | `0` |
| `vimtex_indent_enabled` | `0` |
| `vimtex_toc_enabled` | `0` |
| `vimtex_complete_enabled` | `0` |
| `vimtex_syntax_enabled` | `1` |

Quickfix/log behavior:

- `vimtex_quickfix_mode = 0`
- Ignored log messages:
  - `Underfull`
  - `Overfull`
  - `specifier changed to`
  - `Token not allowed in a PDF string`

### ChatGPT.nvim

File: `lua/plugins/chatgpt.lua`

Plugin: `jackMort/ChatGPT.nvim`

Load event:

- `VeryLazy`

Dependencies:

- `MunifTanjim/nui.nvim`
- `nvim-lua/plenary.nvim`
- `folke/trouble.nvim`
- `nvim-telescope/telescope.nvim`

Setup:

```lua
require("chatgpt").setup()
```

The plugin requires whatever API key/environment configuration
`jackMort/ChatGPT.nvim` expects. This repository does not store secrets.

## Locked Plugin Set

The lockfile currently pins these plugins:

| Plugin | Branch | Commit |
| --- | --- | --- |
| `CopilotChat.nvim` | `main` | `137d3bc527518f5ea982c43c43084496732365c3` |
| `LazyVim` | `main` | `83d90f339defdb109a6ede333865a66ffc7ef6aa` |
| `SchemaStore.nvim` | `main` | `20d4e9970798123e6197acb1c85c4b1e897efd29` |
| `blink-copilot` | `main` | `7ad8209b2f880a2840c94cdcd80ab4dc511d4f39` |
| `blink.cmp` | `main` | `78336bc89ee5365633bcf754d93df01678b5c08f` |
| `bufferline.nvim` | `main` | `655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3` |
| `catppuccin` | `main` | `426dbebe06b5c69fd846ceb17b42e12f890aedf1` |
| `conform.nvim` | `master` | `dca1a190aa85f9065979ef35802fb77131911106` |
| `copilot.lua` | `master` | `94b22035e31e82821d015f6481ea3c17800e55b7` |
| `dressing.nvim` | `master` | `2d7c2db2507fa3c4956142ee607431ddb2828639` |
| `flash.nvim` | `main` | `fcea7ff883235d9024dc41e638f164a450c14ca2` |
| `friendly-snippets` | `main` | `6cd7280adead7f586db6fccbd15d2cac7e2188b9` |
| `gitsigns.nvim` | `main` | `6d808f99bd63303646794406e270bd553ad7792e` |
| `grug-far.nvim` | `main` | `21790e59dd0109a92a70cb874dd002af186314f5` |
| `lazy.nvim` | `main` | `85c7ff3711b730b4030d03144f6db6375044ae82` |
| `lazydev.nvim` | `main` | `ff2cbcba459b637ec3fd165a2be59b7bbaeedf0d` |
| `lualine.nvim` | `master` | `131a558e13f9f28b15cd235557150ccb23f89286` |
| `markdown-preview.nvim` | `master` | `a923f5fc5ba36a3b17e289dc35dc17f66d0548ee` |
| `mason-lspconfig.nvim` | `main` | `0c2823e0418f3d9230ff8b201c976e84de1cb401` |
| `mason.nvim` | `main` | `cb8445f8ce85d957416c106b780efd51c6298f89` |
| `mini.ai` | `main` | `43eb2074843950a3a25aae56a5f41362ec043bfa` |
| `mini.icons` | `main` | `bac6317300e205335df425296570d84322730067` |
| `mini.pairs` | `main` | `42387c7fe68fc0b6e95eaf37f1bb76e7bffaa0d9` |
| `mini.surround` | `main` | `2715e04bea3ec9244f15b421dc5b18c0fe326210` |
| `neo-tree.nvim` | `main` | `19d20a99bf0061a5ecc4343d2f09fa713306c965` |
| `noice.nvim` | `main` | `7bfd942445fb63089b59f97ca487d605e715f155` |
| `nui.nvim` | `main` | `de740991c12411b663994b2860f1a4fd0937c130` |
| `nvim-autopairs` | `master` | `59bce2eef357189c3305e25bc6dd2d138c1683f5` |
| `nvim-lint` | `master` | `eab58b48eb11d7745c11c505e0f3057165902461` |
| `nvim-lspconfig` | `master` | `bf5abe69c1874531f359a822d0cff4d73e26113f` |
| `nvim-treesitter` | `main` | `4916d6592ede8c07973490d9322f187e07dfefac` |
| `nvim-treesitter-textobjects` | `main` | `851e865342e5a4cb1ae23d31caf6e991e1c99f1e` |
| `nvim-ts-autotag` | `main` | `88c1453db4ba7dd24131086fe51fdf74e587d275` |
| `nvim-ufo` | `main` | `ab3eb124062422d276fae49e0dd63b3ad1062cfc` |
| `obsidian.nvim` | `main` | `ae1f76a75c7ce36866e1d9342a8f6f5b9c2caf9b` |
| `persistence.nvim` | `main` | `b20b2a7887bd39c1a356980b45e03250f3dce49c` |
| `plenary.nvim` | `master` | `74b06c6c75e4eeb3108ec01852001636d85a932b` |
| `promise-async` | `main` | `119e8961014c9bfaf1487bf3c2a393d254f337e2` |
| `render-markdown.nvim` | `main` | `3f3eea97b80839f629c951ca660ffd125bfa5b34` |
| `snacks.nvim` | `main` | `ad9ede6a9cddf16cedbd31b8932d6dcdee9b716e` |
| `telescope-bibtex.nvim` | `master` | `289a6f86ebec06e8ae1590533b732b9981d84900` |
| `telescope-fzf-native.nvim` | `main` | `6fea601bd2b694c6f2ae08a6c6fab14930c60e2c` |
| `telescope.nvim` | `master` | `506338434fec5ad19cb1f8d45bf92d66c4917393` |
| `todo-comments.nvim` | `main` | `31e3c38ce9b29781e4422fc0322eb0a21f4e8668` |
| `tokyonight.nvim` | `main` | `cdc07ac78467a233fd62c493de29a17e0cf2b2b6` |
| `trouble.nvim` | `main` | `bd67efe408d4816e25e8491cc5ad4088e708a69a` |
| `ts-comments.nvim` | `main` | `123a9fb12e7229342f807ec9e6de478b1102b041` |
| `venv-selector.nvim` | `main` | `bcb2f58533c59b01565285eba49693f00bc460f5` |
| `vimtex` | `master` | `0f42a5130432d4af2e6fd21fb93a76915ff1f090` |
| `which-key.nvim` | `main` | `3aab2147e74890957785941f0c1ad87d0a44c15a` |

## External Dependencies

This config expects several tools outside Neovim:

| Tool | Used by |
| --- | --- |
| `git` | lazy.nvim bootstrap and plugin installation |
| `python3` | `<leader>rr` current-file runner and Python LazyVim extra |
| A TeX distribution | VimTeX/LaTeX workflow |
| `latexmk` | VimTeX compiler |
| Skim | macOS PDF viewer for VimTeX |
| Zotero exported BibTeX file | Telescope BibTeX global bibliography |
| Obsidian vault | Obsidian.nvim workspaces |
| GitHub Copilot authentication | Copilot and Copilot Chat extras |
| ChatGPT.nvim API configuration | ChatGPT.nvim plugin |
| Nerd Font | Which-key icons and UI symbols |

The Telescope BibTeX bibliography path is hardcoded:

```text
/Users/jonasvonstein/Zotero/references.bib
```

The Obsidian vault paths are hardcoded:

```text
/Users/jonasvonstein/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault
/Users/jonasvonstein/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault/projects/BachelorThesis
```

## Formatting And Local Project Config

`stylua.toml`:

```toml
indent_type = "Spaces"
indent_width = 2
column_width = 120
```

`.neoconf.json` enables local Lua development support for Neovim plugins:

- Neodev library support is enabled.
- Plugin libraries are enabled.
- `lua_ls` is enabled through neoconf plugin settings.

`.gitignore` ignores local scratch/test output:

- `tt.*`
- `.tests`
- `doc/tags`
- `debug`
- `.repro`
- `foo.*`
- `*.log`
- `data`

## Maintenance Notes

Use these commands inside Neovim:

| Command | Purpose |
| --- | --- |
| `:Lazy` | Open plugin manager UI. |
| `:Lazy restore` | Restore exact versions from `lazy-lock.json`. |
| `:Lazy sync` | Install/update/clean plugins according to the config. |
| `:Lazy check` | Check for plugin updates. |
| `:Mason` | Manage external LSP servers, formatters, linters, and tools. |
| `:checkhealth` | Diagnose Neovim, providers, plugins, and external tools. |

When adding a plugin, create a new file under `lua/plugins/` or edit the closest
existing plugin spec. Lazy.nvim automatically imports all specs from that
directory.

When changing plugin versions intentionally, run `:Lazy sync` and commit the
updated `lazy-lock.json`.
