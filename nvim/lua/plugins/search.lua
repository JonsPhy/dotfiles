return {
  -- snacks.picker keymaps (snacks.nvim itself lives in ui.lua)
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notifications" },
    },
  },

  -- Telescope kept solely as the Zotero citation picker backend
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        -- Reads the Zotero sqlite DB directly. Picking an entry inserts the
        -- citation and appends *only that entry* to the project .bib named by
        -- \addbibresource{} / \bibliography{} (tex) or `bibliography:` (quarto),
        -- skipping it if the key is already there.
        "jmbuhr/telescope-zotero.nvim",
        dependencies = { "kkharji/sqlite.lua" },
      },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        extensions = {
          zotero = {
            zotero_db_path = "~/Zotero/zotero.sqlite",
            zotero_storage_path = "~/Zotero/storage",
            -- No better_bibtex_db_path: BBT has migrated its keys into Zotero's
            -- native citationKey field, which the plugin reads from zotero.sqlite.
            -- The old better-bibtex.sqlite is gone (only a stale .migrated remains).
            ft = {
              -- \citep is the parenthetical form the old picker defaulted to.
              tex = { insert_key_formatter = function(key) return "\\citep{" .. key .. "}" end },
              quarto = { insert_key_formatter = function(key) return "[@" .. key .. "]" end },
              markdown = { insert_key_formatter = function(key) return "[@" .. key .. "]" end },
              rmd = { insert_key_formatter = function(key) return "[@" .. key .. "]" end },
            },
          },
        },
      })

      telescope.load_extension("zotero")
    end,
    keys = {
      {
        "<leader>vc",
        function() require("telescope").extensions.zotero.zotero() end,
        ft = { "tex" },
        desc = "Insert citation",
      },
      {
        "<leader>oc",
        function() require("telescope").extensions.zotero.zotero() end,
        ft = { "markdown", "quarto", "rmd" },
        desc = "Insert citation",
      },
    },
  },
}
