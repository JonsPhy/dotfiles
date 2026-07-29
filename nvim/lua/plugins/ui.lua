return {
  -- Colorschemes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = { flavour = "mocha", transparent_background = true },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
      styles = { sidebars = "transparent", floats = "transparent" },
    },
  },
  { "rebelot/kanagawa.nvim", lazy = true, opts = { transparent = true, theme = "wave" } },
  { "rose-pine/neovim", name = "rose-pine", lazy = true, opts = { styles = { transparency = true } } },

  -- Central UI layer
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true },
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
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          -- snacks hides dotfiles by default, which is the wrong default for a
          -- machine whose main editing target is a dotfiles repo. `ignored`
          -- stays false so .gitignore is still respected — otherwise
          -- karabiner/node_modules floods the tree. `H` toggles hidden and `I`
          -- toggles ignored inside the picker if you need them per-session.
          explorer = { hidden = true, exclude = { ".git" } },
          files = { hidden = true, exclude = { ".git" } },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
 ____   ____ ___  __     __ ___  __  __
/ ___| / ___|_ _| \ \   / /|_ _||  \/  |
\___ \| |    | |   \ \ / /  | | | |\/| |
 ___) | |___ | |    \ V /   | | | |  | |
|____/ \____|___|    \_/   |___||_|  |_|

Scientific writing · LaTeX · Quarto · Python]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
            { icon = " ", key = "e", desc = "Explorer", action = ":lua Snacks.explorer()" },
            { icon = " ", key = "g", desc = "Search Text", action = ":lua Snacks.picker.grep()" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
            { icon = " ", key = "s", desc = "Sessions", action = ":lua require('persistence').select()" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "t", desc = "Themes", action = ":lua Snacks.picker.colorschemes()" },
            { icon = " ", key = "q", desc = "Quit", action = ":confirm qa" },
          },
        },
      },
    },
    keys = {
      -- Toggles a sidebar file tree. `reveal` does not exist on this snacks
      -- version, so the "here" variant just roots the tree at the file's dir.
      { "<leader>e", function() Snacks.explorer() end, desc = "Explorer (toggle)" },
      { "<leader>E", function() Snacks.explorer({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Explorer (file's dir)" },
    },
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>ss", function() require("persistence").select() end, desc = "Select session" },
      { "<leader>sl", function() require("persistence").load() end, desc = "Load session" },
      { "<leader>sd", function() require("persistence").stop() end, desc = "Stop session save" },
    },
  },

  -- Key hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      win = { border = "rounded", padding = { 1, 2 }, wo = { winblend = 8 } },
      layout = { spacing = 3, align = "center" },
      icons = { breadcrumb = ">", separator = "->", group = "+" },
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>e", desc = "Explorer (toggle)" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lazy" },
        { "<leader>m", group = "markdown" },
        { "<leader>n", group = "notes" },
        { "<leader>p", group = "python" },
        -- Quit and nothing else: sessions moved to <leader>s, Quarto to
        -- <leader>r, molten cells to <leader>p. See KEYBINDINGS.md §4.3.
        { "<leader>q", group = "quit" },
        { "<leader>r", group = "run" },
        { "<leader>s", group = "session" },
        { "<leader>t", group = "terminal" },
        { "<leader>u", group = "ui" },
        { "<leader>v", group = "latex" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        globalstatus = true,
        -- Stays "auto" on purpose: <leader>u1..u4 switch colorschemes, and a
        -- hardcoded theme here would leave the statusline on the old palette.
        theme = "auto",
        -- Flat separators instead of the default powerline arrows, to match
        -- the minimal prompt.
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = { { "mode", fmt = function(s) return s:sub(1, 1) end } },
        lualine_b = { "branch" },
        lualine_c = { { "filename", path = 1 }, "diagnostics" },
        lualine_x = { "diff", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Floating cmdline / messages / popupmenu.
  -- Notifications still go through snacks.notifier: noice forwards them to
  -- vim.notify, which snacks has already overridden.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        -- Let noice render LSP markdown, so hover/signature match the rest.
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        command_palette = true, -- cmdline and completions as one centered box
        long_message_to_split = true, -- long :messages open in a split, not a modal
        lsp_doc_border = true,
      },
    },
  },

  -- Sticky header showing the enclosing \section{} / function while scrolling
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      separator = "─",
    },
  },

  -- Git decorations
  { "lewis6991/gitsigns.nvim", event = "BufReadPre", opts = {} },

  -- TODO highlights
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Diagnostics panel
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix" },
    },
  },
}
