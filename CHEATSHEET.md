# Cheatsheet

**Generated — do not edit.** Run `python3 scripts/gen-cheatsheet.py` after
changing any config. Every row below is read out of the config file that
actually implements it, so this file cannot drift the way a hand-written
one does. The rules behind the layout are in [KEYBINDINGS.md](KEYBINDINGS.md).

Scope is chosen by the modifier (§3): `Hyper` = system, `Cmd` = app chrome,
`Ctrl` = inside the focused program, `Space` = command, bare = text.

---

## System — `Hyper` (Caps Lock held)

| Key | Action |
| --- | --- |
| `Hyper` + `1` | Workspace 1 |
| `Hyper` + `2` | Workspace 2 |
| `Hyper` + `3` | Workspace 3 |
| `Hyper` + `4` | Workspace 4 |
| `Hyper` + `f` | Toggle fullscreen |
| `Hyper` + `h` | Focus window left |
| `Hyper` + `j` | Focus window down |
| `Hyper` + `k` | Focus window up |
| `Hyper` + `l` | Focus window right |
| `Hyper` + `spacebar` | Raycast: create reminder |
| `Hyper` + `tab` | Previous workspace |
| `Hyper` + `w` | Window mode (AeroSpace) |

### `Hyper` `b` sublayer

| Key | Action |
| --- | --- |
| `b` then `l` | Browse: bookmarked link |
| `b` then `m` | Browse: Moodle |
| `b` then `n` | Browse: new tab in Zen |
| `b` then `z` | Browse: YouTube |

### `Hyper` `o` sublayer

| Key | Action |
| --- | --- |
| `o` then `b` | Open Zen |
| `o` then `c` | Open ChatGPT |
| `o` then `d` | Open Discord |
| `o` then `f` | Open Finder |
| `o` then `g` | Open Goodnotes |
| `o` then `i` | Open Texts |
| `o` then `m` | Open Tidal |
| `o` then `n` | Open Notion |
| `o` then `p` | Open Skim |
| `o` then `s` | Open Spark |
| `o` then `t` | Open Ghostty |
| `o` then `w` | Open WhatsApp |
| `o` then `y` | Open Zotero |

### `Hyper` `r` sublayer

| Key | Action |
| --- | --- |
| `r` then `b` | Raycast: screenshot ('b'ildschirmfoto) |
| `r` then `c` | Raycast: color picker |
| `r` then `e` | Raycast: emoji and symbols |
| `r` then `h` | Raycast: clipboard history |
| `r` then `l` | Raycast: LaTeX OCR |
| `r` then `n` | Raycast: new LaTeX document |
| `r` then `p` | Raycast: confetti ('p'arty) |
| `r` then `t` | Raycast: pomodoro timer |

### `Hyper` `s` sublayer

| Key | Action |
| --- | --- |
| `s` then `c` | System: open camera |
| `s` then `l` | System: lock screen |
| `s` then `t` | System: toggle light/dark appearance |
| `s` then `v` | System: ChatGPT voice mode |

## Windows — AeroSpace

Karabiner translates `Hyper`+key into a private `ctrl-shift-cmd` chord that
AeroSpace listens for. You never type that chord directly.

| Press | Action |
| --- | --- |
| `Hyper + 1` | workspace 1 |
| `Hyper + 2` | workspace 2 |
| `Hyper + 3` | workspace 3 |
| `Hyper + 4` | workspace 4 |
| `Hyper + f` | fullscreen |
| `Hyper + h` | focus left |
| `Hyper + j` | focus down |
| `Hyper + k` | focus up |
| `Hyper + l` | focus right |
| `Hyper + tab` | workspace-back-and-forth |
| `Hyper + w` | mode window |

### Window mode (`Hyper` `w`, leave with `Esc`)

| Key | Action | Mode |
| --- | --- | --- |
| `1` | move-node-to-workspace 1 | exits |
| `2` | move-node-to-workspace 2 | exits |
| `3` | move-node-to-workspace 3 | exits |
| `4` | move-node-to-workspace 4 | exits |
| `ctrl-h` | resize width -50 | stays |
| `ctrl-j` | resize height +50 | stays |
| `ctrl-k` | resize height -50 | stays |
| `ctrl-l` | resize width +50 | stays |
| `esc` | reload-config | exits |
| `f` | layout floating tiling | exits |
| `h` | move left | stays |
| `j` | move down | stays |
| `k` | move up | stays |
| `l` | move right | stays |
| `m` | move-node-to-monitor --wrap-around next | exits |
| `r` | flatten-workspace-tree | exits |
| `shift-h` | join-with left | stays |
| `shift-j` | join-with down | stays |
| `shift-k` | join-with up | stays |
| `shift-l` | join-with right | stays |
| `t` | layout tiles accordion | exits |

## Terminal — Ghostty

Ghostty binds no `Ctrl`+letter chord, so `Ctrl+hjkl` reaches Neovim.

| Chord | Action |
| --- | --- |
| `cmd+1` | go to tab 1 |
| `cmd+2` | go to tab 2 |
| `cmd+3` | go to tab 3 |
| `cmd+4` | go to tab 4 |
| `cmd+5` | go to tab 5 |
| `cmd+6` | go to tab 6 |
| `cmd+7` | go to tab 7 |
| `cmd+8` | go to tab 8 |
| `cmd+9` | go to the last tab |
| `cmd+ctrl+0` | reset all splits to equal size (stock is cmd+ctrl+=, which is punctuation) |
| `cmd+ctrl+h` | widen the split to the left |
| `cmd+ctrl+j` | grow the split downwards |
| `cmd+ctrl+k` | grow the split upwards |
| `cmd+ctrl+l` | widen the split to the right |
| `cmd+d` | split the focused surface to the right |
| `cmd+enter` | zoom the focused split to fill the window, or restore it |
| `cmd+f` | search the scrollback buffer |
| `cmd+minus` | decrease font size by one point |
| `cmd+n` | new window |
| `cmd+plus` | increase font size by one point |
| `cmd+shift+d` | split the focused surface downwards |
| `cmd+shift+h` | focus the split to the left |
| `cmd+shift+j` | focus the split below |
| `cmd+shift+k` | focus the split above |
| `cmd+shift+l` | focus the split to the right |
| `cmd+shift+r` | reload this config file in place |
| `cmd+t` | new tab |
| `cmd+w` | close the focused split — or the tab, when it is the only split |
| `cmd+zero` | reset font size to the configured default |
| `ctrl+shift+tab` | previous tab |
| `ctrl+tab` | next tab |

## Browser — Zen

Split shortcuts deliberately match Ghostty's: shortcuts are per-app, so the
same chord meaning the same verb in both is the goal, not a conflict.

| Chord | Action |
| --- | --- |
| `Cmd+Alt+G` | Split into a grid |
| `Cmd+Alt+H` | Split horizontal — stacked (matches Ghostty `cmd+shift+d`) |
| `Cmd+Alt+J` | Unsplit |
| `Cmd+Alt+V` | Split vertical — side by side (matches Ghostty `cmd+d`) |
| `Cmd+D` | Add bookmark |
| `Cmd+F` | Find in page |
| `Cmd+K` | Focus search bar |
| `Cmd+L` | Focus URL bar |
| `Cmd+N` | New window |
| `Cmd+Shift+D` | Pin / unpin tab |
| `Cmd+Shift+P` | New private window |
| `Cmd+T` | New tab |
| `Cmd+W` | Close tab |

## Editor — Neovim

Leader is `Space`. Press it and wait — which-key lists everything live;
this table is the same data read out of the Lua source.

Groups: `<leader>a` ai · `<leader>b` buffer · `<leader>c` code · `<leader>f` find · `<leader>g` git · `<leader>l` lazy · `<leader>m` markdown · `<leader>n` notes · `<leader>p` python · `<leader>q` quit · `<leader>r` run · `<leader>s` session · `<leader>t` terminal · `<leader>u` ui · `<leader>v` latex · `<leader>x` diagnostics

| Key | Action |
| --- | --- |
| `<C-h>` | Window left |
| `<C-j>` | Window down |
| `<C-k>` | Window up |
| `<C-l>` | Window right |
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader><Space>` | Write file |
| `<leader>E` | Explorer (file's dir) |
| `<leader>aa` | avante: ask about selection |
| `<leader>ah` | avante: sessions |
| `<leader>am` | avante: switch model |
| `<leader>an` | avante: new chat |
| `<leader>at` | avante: toggle chat |
| `<leader>bd` | Delete buffer |
| `<leader>bo` | Delete other buffers |
| `<leader>cd` | Line diagnostics |
| `<leader>cf` | Format |
| `<leader>cl` | Diagnostics list |
| `<leader>e` | Explorer (toggle) |
| `<leader>fb` | Buffers |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fh` | Help tags |
| `<leader>fn` | Notifications |
| `<leader>fr` | Recent files |
| `<leader>gB` | Blame line |
| `<leader>gb` | Branches |
| `<leader>gd` | Diff hunks |
| `<leader>gf` | Log (this file) |
| `<leader>gg` | Lazygit |
| `<leader>gl` | Log |
| `<leader>go` | Open in GitHub |
| `<leader>gs` | Status |
| `<leader>gt` | Stashes |
| `<leader>lc` | Lazy check |
| `<leader>li` | Lazy install |
| `<leader>ll` | Lazy home |
| `<leader>lp` | Lazy profile |
| `<leader>ls` | Lazy sync |
| `<leader>lu` | Lazy update |
| `<leader>lx` | Lazy clean |
| `<leader>mp` | Markdown preview |
| `<leader>nc` | Insert citation |
| `<leader>nd` | Daily note |
| `<leader>nn` | New note |
| `<leader>ns` | Search notes |
| `<leader>nt` | Note template |
| `<leader>pC` | Execute all cells |
| `<leader>pc` | Execute cell |
| `<leader>pe` | Evaluate (operator) |
| `<leader>pe` | Evaluate selection |
| `<leader>ph` | Hide output |
| `<leader>pi` | Init Jupyter kernel |
| `<leader>ps` | Show output |
| `<leader>pv` | Select Python environment |
| `<leader>qQ` | Quit all, discard changes |
| `<leader>qo` | Close this window |
| `<leader>qq` | Quit all |
| `<leader>qw` | Save all and quit |
| `<leader>ra` | Activate Quarto LSP |
| `<leader>rc` | Close Quarto preview |
| `<leader>rf` | Run current Python file |
| `<leader>rh` | Quarto help |
| `<leader>rp` | Preview Quarto |
| `<leader>rr` | Render Quarto |
| `<leader>sd` | Stop session save |
| `<leader>sl` | Load session |
| `<leader>ss` | Select session |
| `<leader>tc` | Claude Code |
| `<leader>u1` | Tokyonight |
| `<leader>u2` | Catppuccin |
| `<leader>u3` | Kanagawa |
| `<leader>u4` | Rose Pine |
| `<leader>uZ` | Zoom (keep statusline) |
| `<leader>uh` | Clear search highlight |
| `<leader>us` | Color schemes |
| `<leader>ut` | Transparent background |
| `<leader>uz` | Zen mode |
| `<leader>vb` | Compile LaTeX |
| `<leader>vc` | Insert citation |
| `<leader>ve` | LaTeX errors |
| `<leader>vi` | LaTeX info |
| `<leader>vl` | Clean LaTeX |
| `<leader>vs` | Stop LaTeX |
| `<leader>vt` | LaTeX TOC |
| `<leader>vv` | View PDF |
| `<leader>xq` | Quickfix |
| `<leader>xx` | Diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `gA` | Jump forward |
| `ga` | Jump back |

## Keyboard — Corne

Reclaimed outer-left column (layer 0):

| Position | Key |
| --- | --- |
| outer column, top | `Tab` |
| outer column, home | `Ctrl` |
| outer column, bottom | `hold for nav layer` |

Nav layer (layer 4), held with the outer-left bottom key:

| Row | Keys |
| --- | --- |
| `Y U I O` | Home · PgDn · PgUp · End |
| `H J K L` | ← · ↓ · ↑ · → |
| `N M , .` | Esc · Del · Ins · — |
| `A S D F` | Ctrl · Alt · Cmd · Shift |

## Files — Yazi

Yazi ships its own filterable help panel with every binding and its
description: press `~` or `F1`. That reads the live keymap, which beats
anything reproduced here, so it is not duplicated (KEYBINDINGS.md §9.6).

