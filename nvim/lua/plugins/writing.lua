return {
  {
    -- `main`, not `master`: master's README states Neovim 0.12 is not supported,
    -- and it is frozen. On 0.12 its query predicates crash ("attempt to call
    -- method 'range'") because match[capture_id] became a list of nodes in 0.11.
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main explicitly does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "bash",
        "bibtex",
        "html",
        "json",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "r",
        "regex", -- snacks.picker highlights its match patterns with this
        "toml",
        "vim",
        "yaml",
      })

      -- On main there is no `highlight`/`indent` option table. Neovim owns both;
      -- you opt in per buffer. get_lang() honours filetype->parser registrations,
      -- so quarto and avante's "Avante" filetype resolve to markdown for free.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang or not pcall(vim.treesitter.language.add, lang) then return end
          if pcall(vim.treesitter.start, ev.buf) then
            -- Was `indent = { enable = true }` before; still experimental.
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- In-buffer markdown rendering: headings, tables, callouts, checkboxes.
  -- Covers obsidian/quarto notes as well as the Avante sidebar.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "quarto", "rmd", "Avante" },
    opts = {
      file_types = { "markdown", "quarto", "rmd", "Avante" },
      -- Show the raw markdown on the line the cursor is on, so editing
      -- syntax stays possible while everything else stays rendered.
      anti_conceal = { enabled = true },
    },
  },

  {
    "lervag/vimtex",
    ft = "tex",
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_forward_search_on_start = 0
      vim.g.vimtex_view_automatic = 0
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

      vim.g.vimtex_syntax_conceal =
        { accents = 0, ligatures = 0, greek = 0, math_bounds = 0, math_delimiters = 0, styles = 0 }
      vim.g.tex_conceal = ""
      vim.g.vimtex_matchparen_enabled = 0
      vim.g.vimtex_fold_enabled = 0
      vim.g.vimtex_indent_enabled = 0
      vim.g.vimtex_complete_enabled = 0
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_log_ignore = {
        "Underfull",
        "Overfull",
        "specifier changed to",
        "Token not allowed in a PDF string",
      }
      vim.g.vimtex_syntax_enabled = 1
    end,
    keys = {
      { "<leader>vb", "<cmd>VimtexCompile<CR>", desc = "Compile LaTeX" },
      { "<leader>vs", "<cmd>VimtexStop<CR>", desc = "Stop LaTeX" },
      { "<leader>vv", "<cmd>VimtexView<CR>", desc = "View PDF" },
      { "<leader>vt", "<cmd>VimtexTocOpen<CR>", desc = "LaTeX TOC" },
      { "<leader>vl", "<cmd>VimtexClean<CR>", desc = "Clean LaTeX" },
      { "<leader>ve", "<cmd>VimtexErrors<CR>", desc = "LaTeX errors" },
      { "<leader>vi", "<cmd>VimtexInfo<CR>", desc = "LaTeX info" },
    },
  },

  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lspFeatures = {
        enabled = true,
        languages = { "r", "python", "julia", "bash", "html" },
      },
    },
    keys = {
      { "<leader>qp", "<cmd>QuartoPreview<CR>", ft = "quarto", desc = "Preview Quarto" },
      -- quarto-nvim has no :QuartoRender — rendering is only a CLI call, so it
      -- runs in a snacks terminal where the render log stays readable.
      {
        "<leader>qr",
        function()
          Snacks.terminal.open({ "quarto", "render", vim.fn.expand("%:p") }, { interactive = false })
        end,
        ft = "quarto",
        desc = "Render Quarto",
      },
      { "<leader>qc", "<cmd>QuartoClosePreview<CR>", ft = "quarto", desc = "Close Quarto preview" },
      { "<leader>qa", "<cmd>QuartoActivate<CR>", ft = "quarto", desc = "Activate Quarto LSP" },
      { "<leader>qh", "<cmd>QuartoHelp<CR>", ft = "quarto", desc = "Quarto help" },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "quarto" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown", "quarto" }
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", ft = { "markdown", "quarto" }, desc = "Markdown preview" },
    },
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cmd = {
      "ObsidianNew",
      "ObsidianTemplate",
      "ObsidianToday",
      "ObsidianSearch",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
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
        nvim_cmp = false,
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
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "New note" },
      { "<leader>ot", "<cmd>ObsidianTemplate<CR>", desc = "Note template" },
      { "<leader>od", "<cmd>ObsidianToday<CR>", desc = "Daily note" },
      { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Search notes" },
    },
  },
}
