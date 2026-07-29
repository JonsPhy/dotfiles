#!/usr/bin/env python3
"""Generate CHEATSHEET.md from the actual config files.

Nothing in the output is written by hand. That is the whole point: a
hand-maintained cheatsheet is a third copy after the config and KEYBINDINGS.md
§4, and it rots faster than either — nvim/README.md documented a plugin that was
never installed, plus three keymaps that never existed, and nobody noticed.

This is also the first working piece of KEYBINDINGS.md §9.5, which proposes
generating the Hyper+i help panel from these same parsers.

Usage:  python3 scripts/gen-cheatsheet.py          # write CHEATSHEET.md
        python3 scripts/gen-cheatsheet.py --check  # exit 1 if out of date
"""

from __future__ import annotations

import json
import pathlib
import re
import sys
import tomllib

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "CHEATSHEET.md"


# ---------------------------------------------------------------- karabiner --
def karabiner() -> tuple[list, dict]:
    """Hyper bindings. Returns (direct, {sublayer_key: [(key, desc)]})."""
    data = json.loads((ROOT / "karabiner" / "karabiner.json").read_text())
    rules = data["profiles"][0]["complex_modifications"]["rules"]

    direct, sub = [], {}
    for rule in rules:
        for man in rule.get("manipulators", []):
            key = man.get("from", {}).get("key_code")
            desc = man.get("description") or rule.get("description", "")
            if not key:
                continue
            active = [
                c["name"][len("hyper_sublayer_"):]
                for c in man.get("conditions", [])
                if c.get("name", "").startswith("hyper_sublayer_")
                and c.get("value") == 1
            ]
            # entering a sublayer sets its variable; skip those pseudo-entries
            sets_var = any(
                "set_variable" in t
                and t["set_variable"]["name"].startswith("hyper_sublayer_")
                for t in man.get("to", [])
            )
            if active:
                sub.setdefault(active[0], []).append((key, desc))
            elif sets_var:
                continue
            elif any(c.get("name") == "hyper" for c in man.get("conditions", [])):
                direct.append((key, desc))
    return sorted(direct), {k: sorted(v) for k, v in sorted(sub.items())}


# ---------------------------------------------------------------- aerospace --
def aerospace() -> tuple[list, list]:
    cfg = tomllib.loads((ROOT / "aerospace" / "aerospace.toml").read_text())
    main, window = [], []
    for chord, action in cfg["mode"]["main"]["binding"].items():
        # ctrl-shift-cmd-X is the private transport chord; show it as Hyper+X
        shown = chord.replace("ctrl-shift-cmd-", "Hyper + ")
        main.append((shown, fmt_action(action)))
    for chord, action in cfg["mode"]["window"]["binding"].items():
        sticky = isinstance(action, str)
        window.append((chord, fmt_action(action), "stays" if sticky else "exits"))
    return sorted(main), sorted(window)


def fmt_action(a) -> str:
    if isinstance(a, list):
        a = [x for x in a if x != "mode main"]
        return ", ".join(a)
    return a


# ------------------------------------------------------------------ ghostty --
def ghostty() -> list:
    """keybind lines, described by the comment line immediately above."""
    lines = (ROOT / "ghostty" / "config").read_text().splitlines()
    out = []
    for i, line in enumerate(lines):
        m = re.match(r"^keybind = ([^=]+)=(.+)$", line.strip())
        if not m:
            continue
        chord, action = m.group(1), m.group(2)
        if action == "unbind":
            continue
        desc = ""
        if i and lines[i - 1].startswith("# ") and not lines[i - 1].startswith("# ─"):
            desc = lines[i - 1][2:].strip()
        out.append((chord, desc or action, action))
    return sorted(out)


# -------------------------------------------------------------------- nvim --
def nvim() -> list:
    out = []
    for path in (ROOT / "nvim" / "lua").rglob("*.lua"):
        text = path.read_text()
        # core keymaps.lua style:  map("n", "<lhs>", rhs, { desc = "..." })
        for m in re.finditer(
            r'map\(\s*("[^"]+"|\{[^}]*\})\s*,\s*"([^"]+)"\s*,.*?desc\s*=\s*"([^"]+)"',
            text,
            re.S,
        ):
            out.append((m.group(2), m.group(3)))
        # lazy.nvim keys spec:  { "<lhs>", cmd, desc = "..." }
        for m in re.finditer(
            r'\{\s*"(<leader>[^"]+|<[A-Za-z-]+>)"\s*,(?:[^{}]|\{[^{}]*\})*?desc\s*=\s*"([^"]+)"',
            text,
        ):
            out.append((m.group(1), m.group(2)))
    seen, uniq = set(), []
    for lhs, desc in sorted(set(out)):
        if (lhs, desc) in seen:
            continue
        seen.add((lhs, desc))
        uniq.append((lhs, desc))
    return uniq


def nvim_groups() -> list:
    """which-key group prefixes: { "<leader>x", group = "name" }."""
    text = (ROOT / "nvim" / "lua" / "plugins" / "ui.lua").read_text()
    out = re.findall(r'\{\s*"(<leader>[a-zA-Z])"\s*,\s*group\s*=\s*"([^"]+)"', text)
    return sorted(set(out))


# --------------------------------------------------------------------- zen --
def zen() -> list:
    data = json.loads((ROOT / "zen" / "zen-keyboard-shortcuts.json").read_text())
    interesting = {
        "zen-split-view-vertical", "zen-split-view-horizontal", "zen-split-view-grid",
        "zen-split-view-unsplit", "addBookmarkAsKb", "zen-toggle-pin-tab",
        "key_privatebrowsing", "key_newNavigator", "key_newNavigatorTab",
        "key_close", "key_find", "focusURLBar", "key_search",
    }
    labels = {
        "zen-split-view-vertical": "Split vertical — side by side (matches Ghostty `cmd+d`)",
        "zen-split-view-horizontal": "Split horizontal — stacked (matches Ghostty `cmd+shift+d`)",
        "zen-split-view-grid": "Split into a grid",
        "zen-split-view-unsplit": "Unsplit",
        "addBookmarkAsKb": "Add bookmark",
        "zen-toggle-pin-tab": "Pin / unpin tab",
        "key_privatebrowsing": "New private window",
        "key_newNavigator": "New window",
        "key_newNavigatorTab": "New tab",
        "key_close": "Close tab",
        "key_find": "Find in page",
        "focusURLBar": "Focus URL bar",
        "key_search": "Focus search bar",
    }
    out = []
    for s in data["shortcuts"]:
        if s.get("id") not in interesting:
            continue
        out.append((chord_of(s), labels.get(s["id"], s["id"])))
    return sorted(out)


def chord_of(s) -> str:
    m = s["modifiers"]
    parts = []
    if m.get("accel") or m.get("meta"):
        parts.append("Cmd")
    if m.get("control"):
        parts.append("Ctrl")
    if m.get("alt"):
        parts.append("Alt")
    if m.get("shift"):
        parts.append("Shift")
    key = s.get("key") or s.get("keycode")
    if not key:
        return "(unbound)"
    return "+".join(parts + [key.upper() if len(key) == 1 else key])


# ------------------------------------------------------------------- corne --
def corne() -> tuple[list, list]:
    lay = json.loads((ROOT / "corne" / "layout.vil").read_text())["layout"]
    # left half rows 0-2 are matrix rows 0-2; right half rows 4-6
    outer = [lay[0][r][0] for r in range(3)]
    nav_home = [lay[4][5][i] for i in (5, 4, 3, 2)]
    nav_top = [lay[4][4][i] for i in (5, 4, 3, 2)]
    nav_bot = [lay[4][6][i] for i in (5, 4, 3, 2)]
    nav_mods = [lay[4][1][i] for i in (1, 2, 3, 4)]
    left = [
        ("outer column, top", pretty(outer[0])),
        ("outer column, home", pretty(outer[1])),
        ("outer column, bottom", pretty(outer[2])),
    ]
    nav = [
        ("Y U I O", " · ".join(pretty(k) for k in nav_top)),
        ("H J K L", " · ".join(pretty(k) for k in nav_home)),
        ("N M , .", " · ".join(pretty(k) for k in nav_bot)),
        ("A S D F", " · ".join(pretty(k) for k in nav_mods)),
    ]
    return left, nav


NICE = {
    "KC_LEFT": "←", "KC_RIGHT": "→", "KC_UP": "↑", "KC_DOWN": "↓",
    "KC_HOME": "Home", "KC_END": "End", "KC_PGUP": "PgUp", "KC_PGDOWN": "PgDn",
    "KC_ESCAPE": "Esc", "KC_DELETE": "Del", "KC_INSERT": "Ins", "KC_TAB": "Tab",
    "KC_LCTRL": "Ctrl", "KC_LALT": "Alt", "KC_LGUI": "Cmd", "KC_LSHIFT": "Shift",
    "KC_TRNS": "—", "KC_NO": "—", "MO(4)": "hold for nav layer",
}


def pretty(kc: str) -> str:
    if kc in NICE:
        return NICE[kc]
    return kc.replace("KC_", "").title() if kc.startswith("KC_") else kc


# ------------------------------------------------------------------- render --
def render() -> str:
    hyper_direct, hyper_sub = karabiner()
    aero_main, aero_win = aerospace()
    L = []
    w = L.append

    w("# Cheatsheet")
    w("")
    w("**Generated — do not edit.** Run `python3 scripts/gen-cheatsheet.py` after")
    w("changing any config. Every row below is read out of the config file that")
    w("actually implements it, so this file cannot drift the way a hand-written")
    w("one does. The rules behind the layout are in [KEYBINDINGS.md](KEYBINDINGS.md).")
    w("")
    w("Scope is chosen by the modifier (§3): `Hyper` = system, `Cmd` = app chrome,")
    w("`Ctrl` = inside the focused program, `Space` = command, bare = text.")
    w("")
    w("---")
    w("")

    w("## System — `Hyper` (Caps Lock held)")
    w("")
    w("| Key | Action |")
    w("| --- | --- |")
    for k, d in hyper_direct:
        w(f"| `Hyper` + `{k}` | {d} |")
    w("")
    for subkey, items in hyper_sub.items():
        w(f"### `Hyper` `{subkey}` sublayer")
        w("")
        w("| Key | Action |")
        w("| --- | --- |")
        for k, d in items:
            w(f"| `{subkey}` then `{k}` | {d} |")
        w("")

    w("## Windows — AeroSpace")
    w("")
    w("Karabiner translates `Hyper`+key into a private `ctrl-shift-cmd` chord that")
    w("AeroSpace listens for. You never type that chord directly.")
    w("")
    w("| Press | Action |")
    w("| --- | --- |")
    for chord, action in aero_main:
        w(f"| `{chord}` | {action} |")
    w("")
    w("### Window mode (`Hyper` `w`, leave with `Esc`)")
    w("")
    w("| Key | Action | Mode |")
    w("| --- | --- | --- |")
    for chord, action, sticky in aero_win:
        w(f"| `{chord}` | {action} | {sticky} |")
    w("")

    w("## Terminal — Ghostty")
    w("")
    w("Ghostty binds no `Ctrl`+letter chord, so `Ctrl+hjkl` reaches Neovim.")
    w("")
    w("| Chord | Action |")
    w("| --- | --- |")
    for chord, desc, action in ghostty():
        w(f"| `{chord}` | {desc} |")
    w("")

    w("## Browser — Zen")
    w("")
    w("Split shortcuts deliberately match Ghostty's: shortcuts are per-app, so the")
    w("same chord meaning the same verb in both is the goal, not a conflict.")
    w("")
    w("| Chord | Action |")
    w("| --- | --- |")
    for chord, action in zen():
        w(f"| `{chord}` | {action} |")
    w("")

    w("## Editor — Neovim")
    w("")
    w("Leader is `Space`. Press it and wait — which-key lists everything live;")
    w("this table is the same data read out of the Lua source.")
    w("")
    groups = nvim_groups()
    if groups:
        w("Groups: " + " · ".join(f"`{k}` {g}" for k, g in groups))
        w("")
    w("| Key | Action |")
    w("| --- | --- |")
    for lhs, desc in nvim():
        w(f"| `{lhs}` | {desc} |")
    w("")

    left, nav = corne()
    w("## Keyboard — Corne")
    w("")
    w("Reclaimed outer-left column (layer 0):")
    w("")
    w("| Position | Key |")
    w("| --- | --- |")
    for pos, key in left:
        w(f"| {pos} | `{key}` |")
    w("")
    w("Nav layer (layer 4), held with the outer-left bottom key:")
    w("")
    w("| Row | Keys |")
    w("| --- | --- |")
    for row, keys in nav:
        w(f"| `{row}` | {keys} |")
    w("")

    w("## Files — Yazi")
    w("")
    w("Yazi ships its own filterable help panel with every binding and its")
    w("description: press `~` or `F1`. That reads the live keymap, which beats")
    w("anything reproduced here, so it is not duplicated (KEYBINDINGS.md §9.6).")
    w("")
    return "\n".join(L) + "\n"


if __name__ == "__main__":
    text = render()
    if "--check" in sys.argv:
        current = OUT.read_text() if OUT.exists() else ""
        if current != text:
            print("CHEATSHEET.md is out of date — run scripts/gen-cheatsheet.py")
            sys.exit(1)
        print("CHEATSHEET.md up to date")
    else:
        OUT.write_text(text)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(text.splitlines())} lines)")
