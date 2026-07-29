import fs from "fs";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, aerospace, app, open } from "./utils";

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
        description: "Caps Lock -> Hyper Key",
        from: {
          key_code: "caps_lock",
          modifiers: {
            optional: ["any"],
          },
        },
        to: [
          {
            set_variable: {
              name: "hyper",
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "hyper",
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            key_code: "escape",
          },
        ],
        type: "basic",
      },
    ],
  },
  ...createHyperSubLayers({
    spacebar: {
      ...open("raycast://extensions/raycast/apple-reminders/create-reminder"),
      description: "Raycast: create reminder",
    },

    // AeroSpace transport chords (Ctrl+Shift+Cmd+key). Never typed directly —
    // Karabiner emits them, AeroSpace binds them. Every entry here has a
    // matching ctrl-shift-cmd-<key> in aerospace/aerospace.toml.
    h: aerospace("h", "Focus window left"),
    j: aerospace("j", "Focus window down"),
    k: aerospace("k", "Focus window up"),
    l: aerospace("l", "Focus window right"),
    f: aerospace("f", "Toggle fullscreen"),
    1: aerospace("1", "Workspace 1"),
    2: aerospace("2", "Workspace 2"),
    3: aerospace("3", "Workspace 3"),
    4: aerospace("4", "Workspace 4"),
    tab: aerospace("tab", "Previous workspace"),
    w: aerospace("w", "Window mode (AeroSpace)"),

    // b = "B"rowse
    b: {
      m: { ...open("https://moodle.lmu.de/"), description: "Browse: Moodle" },
      // z=y because qwertz keyboard
      z: {
        ...open("https://www.youtube.com/"),
        description: "Browse: YouTube",
      },
      l: {
        ...open("https://tinyurl.com/35kkup2"),
        description: "Browse: bookmarked link",
      },
      n: {
        ...open("raycast://extensions/Keyruu/zen-browser/new-tab"),
        description: "Browse: new tab in Zen",
      },
    },
    // o = "Open" applications
    o: {
      b: app("Zen"),
      c: app("ChatGPT"),
      d: app("Discord"),
      f: app("Finder"),
      g: app("Goodnotes"),
      i: app("Texts"),
      m: app("Tidal"),
      n: app("Notion"),
      p: app("Skim"), // "P"DF
      s: app("Spark"),
      t: app("Ghostty"),
      w: app("WhatsApp"),
      y: app("Zotero") // y=z because qwertz keyboard
    },

    // s = "System"
    s: {
      l: {
        description: "System: lock screen",
        to: [
          {
            key_code: "q",
            modifiers: ["right_control", "right_command"],
          },
        ],
      },
      // "T"heme
      t: {
        ...open(
          `raycast://extensions/raycast/system/toggle-system-appearance`
        ),
        description: "System: toggle light/dark appearance",
      },
      c: {
        ...open("raycast://extensions/raycast/system/open-camera"),
        description: "System: open camera",
      },
      // 'v'oice for ChatGPT
      v: {
        description: "System: ChatGPT voice mode",
        to: [
          {
            key_code: "spacebar",
            modifiers: ["left_option"],
          },
        ],
      },
    },

    // r = "Raycast"
    r: {
      b: {
        ...open("com.apple.screenshot.launcher"),
        description: "Raycast: screenshot ('b'ildschirmfoto)",
      },
      c: {
        ...open("raycast://extensions/thomas/color-picker/pick-color"),
        description: "Raycast: color picker",
      },
      e: {
        ...open(
          "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"
        ),
        description: "Raycast: emoji and symbols",
      },
      p: {
        ...open("raycast://extensions/raycast/raycast/confetti"),
        description: "Raycast: confetti ('p'arty)",
      },
      h: {
        ...open(
          "raycast://extensions/raycast/clipboard-history/clipboard-history"
        ),
        description: "Raycast: clipboard history",
      },
      l: {
        ...open("raycast://extensions/Arthals/simpletexocr/index"),
        description: "Raycast: LaTeX OCR",
      },
      n: {
        ...open(
          "raycast://script-commands/latex?arguments=&arguments=&arguments="
        ),
        description: "Raycast: new LaTeX document",
      },
      t: {
        ...open("raycast://extensions/asubbotin/pomodoro/pomodoro-control-timer"),
        description: "Raycast: pomodoro timer",
      },
    },
  }),

];

fs.writeFileSync(
  "karabiner.json",
  JSON.stringify(
    {
      global: {
        show_in_menu_bar: false,
      },
      profiles: [
        {
          name: "Default",
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2
  )
);
