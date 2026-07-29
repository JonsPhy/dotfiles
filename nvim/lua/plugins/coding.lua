return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)

      local Rule = require("nvim-autopairs.rule")
      npairs.add_rules({
        Rule("$", "$", { "tex", "markdown", "quarto" }):with_move(function(opts)
          return opts.prev_char:match(".%$") ~= nil
        end),
      })
    end,
  },

  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {},
  },

  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {},
  },

  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      provider_selector = function()
        return { "lsp", "indent" }
      end,
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      {
        "zK",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek fold",
      },
    },
  },
}
