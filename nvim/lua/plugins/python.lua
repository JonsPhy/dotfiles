return {
  {
    "3rd/image.nvim",
    lazy = true,
    opts = {
      backend = "kitty",
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
    end,
    keys = {
      { "<leader>pi", "<cmd>MoltenInit<CR>", desc = "Init Jupyter kernel" },
      { "<leader>pe", "<cmd>MoltenEvaluateOperator<CR>", desc = "Evaluate (operator)" },
      { "<leader>pe", "<cmd>MoltenEvaluateVisual<CR>", mode = "v", desc = "Evaluate selection" },
      { "<leader>ph", "<cmd>MoltenHideOutput<CR>", desc = "Hide output" },
      { "<leader>ps", "<cmd>MoltenShowOutput<CR>", desc = "Show output" },
      { "<leader>qe", "<cmd>MoltenRunCell<CR>", ft = { "python", "quarto" }, desc = "Execute cell" },
      { "<leader>qE", "<cmd>MoltenReevaluateAll<CR>", ft = { "python", "quarto" }, desc = "Execute all cells" },
    },
  },

  {
    "GCBallesteros/jupytext.nvim",
    lazy = true,
    opts = {
      custom_language_formatting = {
        python = {
          extension = "qmd",
          style = "quarto",
          force_ft = "quarto",
        },
      },
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    cmd = "VenvSelect",
    opts = {},
    keys = {
      { "<leader>pv", "<cmd>VenvSelect<CR>", desc = "Select Python environment" },
    },
  },
}
