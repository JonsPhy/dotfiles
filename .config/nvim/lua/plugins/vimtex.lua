return {
  "lervag/vimtex",
  init = function()
    -- Choose ONE viewer that matches your OS:
    -- macOS: "skim"; Linux/Wayland: "zathura" or "okular" or "sioyek"
    vim.g.vimtex_view_method = "skim"

    -- Do NOT try to forward-search on start or on every compile
    vim.g.vimtex_view_forward_search_on_start = 0
    vim.g.vimtex_view_automatic = 0

    -- Compiler (manual unless you hit :VimtexCompile)
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      out_dir = "../out",
      options = {
        "-pdf",
        "-bibtex",
        "-interaction=nonstopmode",
        "-file-line-error",
        "-synctex=1",
        "-shell-escape",
        "-f",
      },
    }

    -- PERFORMANCE: kill heavy redraw features in insert mode
    vim.g.vimtex_syntax_conceal =
      { accents = 0, ligatures = 0, greek = 0, math_bounds = 0, math_delimiters = 0, styles = 0 }
    vim.g.tex_conceal = "" -- no pretty symbols
    vim.g.vimtex_matchparen_enabled = 0 -- cheaper editing
    vim.g.vimtex_fold_enabled = 0
    vim.g.vimtex_indent_enabled = 0 -- you already had this
    vim.g.vimtex_toc_enabled = 0 -- no background TOC processing
    vim.g.vimtex_complete_enabled = 0 -- let nvim-cmp/omni handle it (lighter)

    -- Keep quickfix quiet (you already had similar settings)
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_log_ignore = {
      "Underfull",
      "Overfull",
      "specifier changed to",
      "Token not allowed in a PDF string",
    }

    -- Optional: don’t let VimTeX fight with Treesitter; use ONE highlighter.
    -- If you kept Treesitter disabled for latex, enable VimTeX syntax:
    vim.g.vimtex_syntax_enabled = 1
  end,

  keys = {
    { "<leader>vb", "<cmd>VimtexCompile<CR>", desc = "Compile" },
    { "<leader>vs", "<cmd>VimtexStop<CR>", desc = "Stop" },
    { "<leader>vv", "<cmd>VimtexView<CR>", desc = "View" },
    { "<leader>vt", "<cmd>VimtexTocOpen<CR>", desc = "TOC" },
    { "<leader>vl", "<cmd>VimtexClean<CR>", desc = "Clean" },
    { "<leader>ve", "<cmd>VimtexErrors<CR>", desc = "Errors" },
    { "<leader>vi", "<cmd>VimtexInfo<CR>", desc = "Info" },
    { "<leader>v", false, desc = "LaTeX" },
  },
}
