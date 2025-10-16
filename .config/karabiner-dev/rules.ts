import fs from "fs";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, rectangle, shell } from "./utils";

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
    spacebar: open(
      "raycast://extensions/raycast/apple-reminders/create-reminder"
    ),
    //symbol access
    5: {
      description: "Hyper+5 -> [",
      to: [
        {
          key_code: "5",
          modifiers: ["right_option"],
        },
      ],
      type: "basic",
    },
    6: {
      description: "Hyper+6 -> ]",
      to: [
        {
          key_code: "6",
          modifiers: ["right_option"],
        },
      ],
      type: "basic",
    },
    7: {
      description: "Hyper+7 -> backslash",
      to: [
        {
          key_code: "7",
          modifiers: ["left_option", "left_shift"],
        },
      ],
      type: "basic",
    },
    8: {
      description: "Hyper+8 -> {",
      to: [
        {
          key_code: "8",
          modifiers: ["right_option"],
        },
      ],
      type: "basic",
    },
    9: {
      description: "Hyper+9 -> }",
      to: [
        {
          key_code: "9",
          modifiers: ["right_option"],
        },
      ],
      type: "basic",
    },

    //aerospace modifiers
    a: {
        description: "Hyper+a -> aerospace modifiers",
        to: [
            {
                key_code: "left_shift",
                modifiers: ["left_option", "left_command"],
            },
        ],
        type: "basic",
     },
    q: {
        description: "Hyper+q -> aerospace move modifiers",
        to: [
            {
                key_code: "left_control",
                modifiers: ["left_option", "left_command"],
            },
        ],
        type: "basic",
     },

    // b = "B"rowse
    b: {
      m: open("https://moodle.lmu.de/"),
      z: open("https://www.youtube.com/"),
      l: open("https://tinyurl.com/35kkup2"),
      n: open("raycast://extensions/ron-myers/brave/new-tab"),
    },
    // o = "Open" applications
    o: {
      b: app("Brave Browser"),
      c: app("ChatGPT"),
      d: app("Discord"),
      f: app("Finder"),
      g: app("Goodnotes"),
      i: app("Texts"),
      m: app("Tidal"),
      n: app("Notion"),
      p: app("Skim"), // "P"DF
      s: app("Spark"),
      t: app("Warp"),
      w: app("WhatsApp"),
      y: app("Zotero") // y=z because qwertz keyboard
    },
    // w = "Window" via rectangle.app
    w: {
        semicolon: {
        description: "Window: Hide",
        to: [
          {
            key_code: "h",
            modifiers: ["right_command"],
          },
        ],
      },
      y: rectangle("previous-display"),
      o: rectangle("next-display"),
      k: rectangle("top-half"),
      j: rectangle("bottom-half"),
      h: rectangle("left-half"),
      l: rectangle("right-half"),
      f: rectangle("maximize"),
      c: rectangle("center"),
      u: {
        description: "Window: Previous Tab",
        to: [
          {
            key_code: "tab",
            modifiers: ["right_control", "right_shift"],
          },
        ],
      },
      i: {
        description: "Window: Next Tab",
        to: [
          {
            key_code: "tab",
            modifiers: ["right_control"],
          },
        ],
      },
      n: {
        description: "Window: Next Window",
        to: [
          {
            key_code: "grave_accent_and_tilde",
            modifiers: ["right_command"],
          },
        ],
      },
      b: {
        description: "Window: Back",
        to: [
          {
            key_code: "open_bracket",
            modifiers: ["right_command"],
          },
        ],
      },
    },



    // s = "System"
    s: {

      l: {
        to: [
          {
            key_code: "q",
            modifiers: ["right_control", "right_command"],
          },
        ],
      },
      // "T"heme
      t: open(`raycast://extensions/raycast/system/toggle-system-appearance`),
      c: open("raycast://extensions/raycast/system/open-camera"),
      // 'v'oice for charGPT
      v: {
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
      b: open("com.apple.screenshot.launcher"), //'b'ildschirm foto
      c: open("raycast://extensions/thomas/color-picker/pick-color"), //'c'olor
      e: open("raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"), //'e'moji
      p: open("raycast://extensions/raycast/raycast/confetti"), //'p'arty
      h: open("raycast://extensions/raycast/clipboard-history/clipboard-history"), // 'h'istory
      l: open("raycast://extensions/Arthals/simpletexocr/index"), //'l'atexx
      n: open("raycast://script-commands/latex?arguments=&arguments=&arguments="), // 'n'ew latex script
      t: open("raycast://extensions/asubbotin/pomodoro/pomodoro-control-timer"), //'t'imer
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
