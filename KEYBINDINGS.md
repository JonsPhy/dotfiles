# Keybindings

Single source of truth for every keyboard shortcut on this machine: firmware,
Karabiner, AeroSpace, Ghostty, Neovim, Yazi, Zen.

Status: **proposal**. Nothing in here is implemented yet. The "Today" columns
describe the current state; the "Target" columns describe where we are going.
See [Migration](#migration) for the order.

---

## 1. Why

Seven layers of bindings accreted independently, so the same intent has a
different chord in each one. Concretely, "move focus left" is currently four
different things:

| Where | Chord today |
| --- | --- |
| Neovim window | `Ctrl+h` |
| AeroSpace window | `Shift+Alt+Cmd+h` |
| Ghostty split | `Cmd+Alt+←` |
| Rectangle half | `Hyper` `w` `h` |

And two window managers are installed and bound at once (Rectangle **and**
AeroSpace). The goal is not "fewer shortcuts" — it is **one rule that predicts
the shortcut** so new bindings don't need to be memorised individually.

---

## 2. Invariants

These are properties of the stack, not choices. Everything else is built on
them, so they come first.

### 2.1 The firmware speaks US keycodes

The Corne sends **US keycodes**; the macOS layout translates them. Verified in
`layout.vil`: `KC_Z` occupies the bottom-left alpha slot, `KC_Y` the top-right,
and Ü/Ä/Ö are `KC_LBRACKET` / `KC_QUOTE` / `KC_SCOLON` — those are the US
keycodes that a **German** host renders as umlauts.

Consequences:

- AeroSpace's `[key-mapping] preset = 'qwerty'` is **correct as-is**. Do not change it.
- Karabiner rules are written in US keycodes. Already true.
- Anything below the macOS layout translation speaks US. Anything above it
  speaks the active layout.

### 2.2 Karabiner and applications disagree about Y and Z

This is the sharp edge, and it only affects these two keys.

Karabiner hooks at the HID level, **before** layout translation. Applications
receive characters **after** it. So on a German host:

| You press | Karabiner sees | Neovim sees |
| --- | --- | --- |
| the key legended `Z` | `y` | `z` |
| the key legended `Y` | `z` | `y` |

They are exactly inverted. `rules.ts` already carries the scar tissue:
`y: app("Zotero") // y=z because qwertz`.

**Rule: never use `y` or `z` as a mnemonic in any binding.** They are the only
two letters whose meaning depends on which side of the translation you are on.
Reserve them for bindings that are positional by nature or app-internal only
(Neovim's built-in `z` folds are fine — those never cross the boundary).

### 2.3 Punctuation is not portable

US and German disagree on `; ' [ ] / - =` and every bracket. On German,
`[ ] { }` are Option-composed (`Option+5/6/8/9`).

**Rule: bindings use letters and digits only.** No punctuation in any binding we
control.

This has a cost we accept: Neovim's built-in `[d` / `]d` diagnostic motions
require Option-composition on a German host. Those are upstream defaults, not
ours — we add `Space`-leader equivalents rather than fight them.

### 2.4 Option is unavailable as a modifier

Because German composes symbols with it. `ghostty/config` already documents this
and sets `macos-option-as-alt = false` for exactly this reason.

**Rule: no binding we control uses Alt/Option as a modifier.** This immediately
invalidates AeroSpace's current `shift-alt-cmd` and `ctrl-alt-cmd` chords.

### 2.5 The portability contract

**The macOS input layout is always set to match the physical keyboard in use.**
German keyboard → German layout. US keyboard → US layout. This is a rule about
how the machine is operated, not something the firmware tries to detect or work
around.

Typing correctness therefore takes care of itself, and needs no firmware
trickery. What has to survive the switch is **the shortcut convention** — every
binding in §4 must mean the same thing under either layout.

That is exactly what §2.2 (no `y`/`z`) and §2.3 (no punctuation) buy. They are
not stylistic preferences; they are the entire mechanism by which this document
is layout-portable. Letters other than `y`/`z`, and the digits, occupy the same
physical position and produce the same character under both layouts. Nothing
else does.

Separately, and not a portability matter: the system scope (`Hyper`) depends on
Karabiner and AeroSpace, so it is macOS-only and machine-local. We do not
attempt to make it work on a host without them.

---

## 3. The model: modifier selects scope, key selects verb

The whole convention is one sentence:

> **The modifier says *what you are acting on*. The key says *what you are
> doing*, and it is the same key at every scope.**

| Scope | Trigger | Acts on | Implemented by |
| --- | --- | --- | --- |
| **Text** | bare keys | the buffer | Neovim, Yazi |
| **Command** | `Space` leader | the document/project | Neovim, Yazi |
| **App-internal** | `Ctrl` | panes and splits inside the focused app | Neovim, Ghostty, Yazi |
| **App-chrome** | `Cmd` | tabs and windows of the focused app | Ghostty, Zen, all GUI apps |
| **System** | `Hyper` | apps, workspaces, displays | Karabiner, AeroSpace |

`Hyper` is Caps Lock, held. Tapped, it is Escape. This already works and is
worth keeping precisely as-is — on the Corne, Caps Lock is a **thumb** key, and
on the laptop it is the pinky, so the same binding is comfortable on both.

### 3.1 Verb alphabet

The same letter means the same thing in every scope. Chosen to avoid `y`/`z`
per §2.2.

| Key | Verb |
| --- | --- |
| `h` `j` `k` `l` | left / down / up / right — **always**, never arrows |
| `n` | new |
| `w` | close (Cmd scope only — macOS convention) |
| `d` | delete / close (all other scopes) |
| `f` | find, or fullscreen in window scopes |
| `t` | toggle |
| `s` | search / split |
| `g` | git |
| `a` | ai |
| `e` | explorer / files |
| `b` | buffer |
| `c` | code |
| `r` | run |
| `u` | ui |
| `q` | quit |
| `m` | move |
| `p` | project |

### 3.2 Direction collapses to two chords

This is the single highest-value change in the document.

| Intent | Chord |
| --- | --- |
| Move focus **inside** the app | `Ctrl` + `hjkl` |
| Move focus **between** OS windows | `Hyper` + `hjkl` |
| **Move** the window itself | `Hyper` `w` then bare `hjkl` |

Four chords become two. Arrow keys are never used for navigation anywhere.

`Ctrl+hjkl` is ergonomically sound on the Corne: the right hand has no Ctrl
home-row mod (it has `RSFT_T(J)` / `RGUI_T(K)` / `RALT_T(L)`), so `Ctrl+h` is
left-pinky `A` held plus a right-hand key — a clean cross-hand roll with no
same-hand conflict.

---

## 4. Bindings by scope

### 4.1 System — `Hyper`

Karabiner keeps its sublayer model (`Hyper` sets a variable; sublayers key off
it). Direct `Hyper+key` bindings are for things used many times an hour;
sublayers are for everything else.

| Binding | Action | Today |
| --- | --- | --- |
| `Hyper` + `hjkl` | focus window left/down/up/right | `Shift+Alt+Cmd+hjkl` |
| `Hyper` + `f` | fullscreen | `Shift+Alt+Cmd+f` |
| `Hyper` + `1234` | workspace 1–4 | `Shift+Alt+Cmd+uiop` |
| `Hyper` + `tab` | previous workspace | unchanged |
| `Hyper` `w` | → **window mode** (AeroSpace mode) | Rectangle sublayer |
| `Hyper` `o` | → **open app** sublayer | unchanged |
| `Hyper` `b` | → **browse** sublayer | unchanged |
| `Hyper` `r` | → **raycast** sublayer | unchanged |
| `Hyper` `s` | → **system** sublayer | unchanged |

**Window mode** (AeroSpace `mode.window`, entered with `Hyper` `w`, exited with
`Esc`) — bare keys, no modifiers held:

| Key | Action |
| --- | --- |
| `hjkl` | move window |
| `HJKL` | join with |
| `f` | toggle floating |
| `m` | move to next monitor |
| `r` | flatten tree |
| `1234` | move window to workspace |

Two things this replaces:

- **The `Hyper+a` / `Hyper+q` modifier-emission hack is deleted.** Those rules
  emit raw modifier keycodes so you can then hold an AeroSpace chord. They burn
  two sublayer letters and make window management a two-stage chord.
- **`Shift+Alt+Cmd+*` and `Ctrl+Alt+Cmd+*` are deleted.** On a keyboard with
  home-row mods these mean holding three adjacent left-hand tap-hold keys
  (`F`+`S`+`D`, or `A`+`S`+`D`) before the right hand moves — which is exactly
  where HRM misfires and latency live. They also violate §2.4.

**Rectangle is uninstalled.** AeroSpace already tiles; Rectangle's halves fight
the tiler. Its three genuinely useful verbs move into window mode: `center`,
`maximize` → `f`, `next-display` → `m`.

### 4.2 App-chrome — `Cmd`

Identical verbs in Ghostty, Zen, and every other GUI app. These mostly match
macOS defaults already; the point is to stop deviating.

| Binding | Action |
| --- | --- |
| `Cmd+n` | new window |
| `Cmd+t` | new tab |
| `Cmd+w` | close tab/split (`w`, not `d` — macOS convention wins here) |
| `Cmd+Shift+[` / `]` | previous / next tab |
| `Cmd+1`…`9` | go to tab *n* |
| `Cmd+f` | find in page/buffer |

Ghostty additionally, for splits (app-internal, so `Ctrl`):

| Binding | Action | Today |
| --- | --- | --- |
| `Ctrl+hjkl` | focus split | `Cmd+Alt+←↑↓→` |
| `Cmd+d` | split right | unchanged |
| `Cmd+Shift+d` | split down | unchanged |
| `Cmd+Enter` | zoom split | unchanged |

Zen holds **141 stock shortcuts, zero customised**. It only supports chords —
no leader, no sequences — so it aligns on `Cmd` verbs and nothing more. Its
`zen-keyboard-shortcuts.json` must be stowed into this repo (see §7).

### 4.3 Command — `Space` leader

Neovim (already) and Yazi (to be aligned). Groups are allocated from the verb
alphabet in §3.1, which resolves the current collisions:

| Group | Owns | Today |
| --- | --- | --- |
| `<leader>a` | ai | ai |
| `<leader>b` | buffer | buffer |
| `<leader>c` | code | code |
| `<leader>e` | explorer | explorer |
| `<leader>f` | find | find |
| `<leader>g` | git | git |
| `<leader>l` | lazy | lazy |
| `<leader>m` | markdown | markdown |
| `<leader>n` | notes (Obsidian) | — (was `o`) |
| `<leader>p` | python | python |
| `<leader>q` | **quit only** | quit **+ session + quarto** |
| `<leader>r` | run | run |
| `<leader>s` | **session** | sidekick/claude |
| `<leader>t` | terminal (incl. Claude Code) | — |
| `<leader>u` | ui | ui |
| `<leader>v` | latex | latex |
| `<leader>x` | diagnostics | diagnostics |

Three collisions resolved: `<leader>q` was triple-booked (quit + session +
quarto), `<leader>s` was an unmemorable "sidekick/claude", and Quarto moves
under `<leader>r` (run) where it belongs alongside the other execute verbs.

Yazi gets a thin `prepend_keymap` mirroring `f`/`g`/`n`/`e` rather than its
current vendored upstream defaults.

---

## 5. The rule for adding a new binding

1. Which scope? That picks the modifier (§3).
2. Which verb? That picks the key (§3.1).
3. Does it use `y`, `z`, or punctuation? Then pick a different key (§2.2, §2.3).
4. Does it use Alt/Option? Then it is wrong (§2.4).
5. Add it here **first**, then to the config.

---

## 6. Corne proposal

### 6.1 What is there today

From `layout.vil`:

- **Home-row mods**, all four per hand: `LCTL_T(A) LALT_T(S) LGUI_T(D) LSFT_T(F)`
  and `RSFT_T(J) RGUI_T(K) RALT_T(L)`. No right-hand Ctrl.
- **Thumbs**: `TD(1) Space CapsLock` / `Bksp Enter TD(2)`, where `TD(n)` is
  tap → `OSL(n)`, hold → `MO(n)` at 100 ms.
- **Layer 1** numpad, **layer 2** symbols, **layer 3** RGB/media/boot.
- **Layers 4–15 are entirely empty** — twelve unused layers.
- Combos: `Space+Enter`→RShift, `TD1+TD2`→`TD(3)`, `Caps+Bksp`→Tab,
  media prev+next→play.
- A key override: `AltGr`+`A` → `KC_QUOTE`, i.e. Ä.

### 6.2 Problems

**The firmware hard-codes a German host, and this is undocumented.** Layer 2
produces `[ ] { }` as `LALT(5/6/8/9)` — Option-composed German symbols — and the
umlaut keys and the `AltGr+A`→Ä override are the same assumption. Under the §2.5
contract this is *correct*: the Corne is a German keyboard, so it runs against a
German layout. But nothing states it, so the first time this board is plugged
into a US-configured host the symbol layer will look broken for no visible
reason.

Action: state the assumption in `keymap.c`, in the style of the existing
`macos-option-as-alt` comment in `ghostty/config` — which documents the *same*
root cause one layer up. Not a code change.

**Four home-row mods per hand is more than the shortcut scheme needs.** Once
§4.1 removes the three-modifier AeroSpace chords, the only multi-mod chords left
are `Cmd+Shift+*`. Ctrl, Gui and Shift earn their place; Alt on the home row is
now dead weight (§2.4).

### 6.3 Proposed changes

**a. Document the German-host assumption** in `keymap.c` (§6.2). No behaviour
change.

*Optional, only if the Corne ever needs to run against a US-configured host:* an
EEPROM-backed `HOST_DE`/`HOST_US` flag with the layout-sensitive keys routed
through `process_record_user`. Under §2.5 this is not needed — the layout is
matched to the keyboard, and the Corne is German. Listed here because it is the
one thing that would be *impossible* to add later without a source build, so it
is worth knowing the door stays open. Do not build it speculatively.

**b. Reclaim the outer-left column.** Three keys are `KC_NO` today. Suggested:
`Tab`, `Esc`, `Ctrl` — so the Ctrl in §3.2's `Ctrl+hjkl` has a dedicated home
that does not depend on the `A` tap-hold clearing its tapping term. This matters
for repeated split-switching, which is the one place HRM latency is felt.

**c. Drop Alt from the home row.** `LALT_T(S)` → plain `S`, `RALT_T(L)` → plain
`L`. Alt is unusable as a modifier per §2.4, and every removed tap-hold is one
less source of misfire. Keep Ctrl, Gui, Shift.

**d. Repurpose the media/RGB keys.** RGB brightness is not a daily-workflow key.
Suggested: the host-layout toggle from (a), and a `Hyper` key — giving Hyper a
home on the Corne independent of the Caps thumb.

**e. Add Caps Word.** Replaces the Caps Lock round-trip for `CONSTANT_NAMES`,
which is most of what Caps Lock is actually used for while coding.

**f. Fix the home-row mods properly.** A source build gives
`tapping_term_per_key` (pinkies want longer than index fingers) and Achordion,
which rejects a hold when the tapped key is on the *same* hand — killing the
dominant HRM misfire class. Not available in Vial.

**g. Leave layers 4–15 empty for now.** Do not fill them because they exist. The
system scope lives in Karabiner/AeroSpace per §2.5; duplicating it in firmware
would create exactly the second vocabulary this document exists to prevent.

> **Rule: firmware layers are alternative *input methods* for keycodes the spec
> already defines — never a second vocabulary.**

### 6.4 Settled: the host layout stays German

§2.4 and §6.2 both trace back to one thing: the German host layout composes
symbols with Option, which is why Option is unavailable as a modifier and why
layer 2 exists at all.

There was an exit — switch macOS permanently to **US** and generate Ü/Ä/Ö in
firmware (extending the `AltGr+A` trick to all six), freeing Option system-wide
and allowing `macos-option-as-alt = true`. **Decided against.** German typing on
the built-in laptop keyboard would break, since it has no firmware to help it,
and that failure mode is constant.

So Option stays unavailable, §2.4 stands as a permanent constraint rather than a
temporary one, and layer 2 keeps its Option-composed brackets. Recorded here so
the question does not get reopened every time §2.4 looks inconvenient.

---

## 7. Firmware tooling

**Recommendation: move to a `vial-qmk` source build, keymap in this repo.**

The Vial web editor writes keycodes into EEPROM. Each key is one keycode, with
no conditional logic and no access to QMK's callbacks — so §6.3f (Achordion,
per-key tapping term) and §6.3e (Caps Word) are not expressible in it at any
effort level.

The honest case is **home-row mod quality plus reviewable history**, not any
single killer feature. Seven home-row tap-holds are the highest-misfire part of
this setup, and Vial exposes exactly one global tapping term to tune them with.
That is the deciding factor.

`vial-qmk` is QMK with Vial's runtime protocol kept intact, so this is not a
trade:

| | Vial web | vial-qmk source |
| --- | --- | --- |
| Runtime editing without flashing | yes | **yes** |
| Achordion / per-key tapping term | no | yes |
| Conditional logic (`process_record_user`) | no | yes |
| Caps Word, layer lock | no | yes |
| Unlimited combos | slot-limited | yes |
| Reviewable diffs | opaque JSON arrays | commented C |
| Version controlled | manual `.vil` export | native |

Setup:

```
dotfiles/corne/
  keymap.c      # the layout, commented in the style of ghostty/config
  config.h      # tapping terms, Achordion tuning
  rules.mk      # feature flags
  vial.json     # keeps the Vial GUI working
```

Built out of a `vial-qmk` checkout with the keymap directory symlinked in, so
the firmware source lives with everything else it has to stay consistent with.

Workflow: prototype live in the Vial GUI as today, then port anything that
survives into `keymap.c` and flash. Vial stays the scratchpad; the source
becomes the record.

Two caveats worth stating plainly:

- Structural changes need a flash of **both halves**. Runtime tweaks still do not.
- The Corne revision must be confirmed before the first build — check the
  keyboard's Vial identification rather than assuming `rev1`.

**Done (phase 0):** both files are now in this repo — `corne/layout.vil` and
`zen/zen-keyboard-shortcuts.json`, stowed per the README. The keyboard's EEPROM
is still the source of truth for the layout; the repo copy is a snapshot until
the source build lands, at which point that relationship inverts.

---

## 8. Migration

Ordered by value per unit of disruption. One phase at a time — muscle memory is
the binding constraint, not effort.

| Phase | Change | Touches |
| --- | --- | --- |
| **0** | ~~Back up `layout.vil` + Zen JSON into this repo~~ **done**. Ratify this doc. | — |
| **1** | Direction keys: `Ctrl+hjkl` in-app, `Hyper+hjkl` cross-app | ghostty, aerospace, karabiner |
| **2** | One window manager: uninstall Rectangle, add AeroSpace window mode, delete the `Hyper+a`/`Hyper+q` hack | karabiner, aerospace |
| **3** | Neovim namespace cleanup (§4.3) | nvim |
| **4** | `Cmd` verbs aligned across Ghostty and Zen; stow Zen's JSON | ghostty, zen |
| **5** | `vial-qmk` source build, keymap into this repo, no behaviour change yet | corne |
| **6** | Corne changes §6.3a–f | corne |
| **7** | Yazi `prepend_keymap` | yazi |

Phases 1–4 are pure macOS config and independently reversible. Phase 5 is
infrastructure only — the layout must behave identically before and after, which
is what makes phase 6 safe.

### Guardrail

Add a check to `.githooks` that greps each config for bindings and diffs the set
against §4. Without it this document is accurate for about three months. The
check should fail on: any binding using Alt, any binding using `y`/`z`, any
binding using punctuation we control, and any binding absent from this file.
