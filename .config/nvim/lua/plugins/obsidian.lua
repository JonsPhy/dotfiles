return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    -- Real keymaps
    { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "New Note" },
    { "<leader>ot", "<cmd>ObsidianTemplate<CR>", desc = "Templates" },
    { "<leader>od", "<cmd>ObsidianToday<CR>", desc = "Daily Note" },
    { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Search Notes" },

    -- Group with icon
    {
      "<leader>o",
      desc = "Obsidian",
      icon = {
        icon = "\u{f01c8}", -- Nerd Font icon
        hl = "Title", -- Highlight group
        color = "purple", -- Color category (from preset list)
      },
    },
  },
  opts = {
    workspaces = {
      {
        name = "thesis",
        path = "/Users/jonasvonstein/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault/projects/BachelorThesis",
      },
      {
        name = "vault",
        path = "/Users/jonasvonstein/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault",
      },
    },
    disable_frontmatter = true,
    note_id_func = function(title)
      return title
    end,
    completion = {
      nvim_cmp = false, -- set to true only if you have nvim-cmp installed
    },
    daily_notes = {
      folder = "Daily Notes",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
    },
    templates = {
      subdir = "Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
  },
}
