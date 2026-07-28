return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-telescope/telescope-bibtex.nvim" },
  config = function()
    local bibtex_actions = require("telescope-bibtex.actions")

    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "%.aux$",
          "%.out$",
          "%.toc$",
          "%.fls$",
          "%.log$",
          "%.blg$",
          "%.bbl$",
          "%.gz$",
          "%.fdb_latexmk$",
        },
      },
      extensions = {
        bibtex = {
          depth = 1,
          custom_formats = {},
          format = "",
          global_files = { "/Users/jonasvonstein/Zotero/references.bib" },
          search_keys = { "author", "year", "title" },
          citation_format = "{{author}} ({{year}}), {{title}}.",
          citation_trim_firstname = true,
          citation_max_auth = 2,
          context = false,
          context_fallback = true,
          wrap = false,
          mappings = {
            i = {
              ["<CR>"] = bibtex_actions.key_append("%s"),
              ["<C-e>"] = bibtex_actions.entry_append,
              ["<C-c>"] = bibtex_actions.citation_append("{{author}} ({{year}}), {{title}}."),
            },
          },
        },
      },
    })

    require("telescope").load_extension("bibtex")
  end,

  keys = {
    { "<leader><space>", false },
    {
      "<leader>vc",
      function()
        require("telescope").extensions.bibtex.bibtex()
      end,
      desc = "Insert Citation",
      ft = { "tex", "markdown", "md" },
    },
  },
}
