-- This machine has two Claude Code installs:
--   /usr/local/bin/claude    x86_64 cask  -- Bun-compiled, needs AVX. Rosetta
--                                            does not emulate AVX on Apple
--                                            Silicon, so it hangs on startup.
--   /opt/homebrew/bin/claude arm64 npm    -- native, works.
-- vim.fn.exepath() returns the broken one because /usr/local/bin precedes
-- /opt/homebrew/bin on PATH, so resolve explicitly and prefer the native build.
local function claude_exe()
  for _, path in ipairs({ "/opt/homebrew/bin/claude", vim.fn.exepath("claude") }) do
    if path ~= "" and vim.fn.executable(path) == 1 then return path end
  end
  return "claude"
end

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make", -- mac/linux; use `make BUILD_FROM_SOURCE=true` to build the Rust bits yourself
    version = false, -- never set this to "*"
    ---@module 'avante'
    ---@type avante.Config
    -- only the five keymaps below; avante's ~20 defaults are off (see behaviour.auto_set_keymaps)
    keys = {
      { "<leader>at", "<Plug>(AvanteToggle)", desc = "avante: toggle chat" },
      { "<leader>ah", "<cmd>AvanteHistory<cr>", desc = "avante: sessions" },
      { "<leader>aa", "<Plug>(AvanteAsk)", mode = { "n", "v" }, desc = "avante: ask about selection" },
      { "<leader>an", "<cmd>AvanteChatNew<cr>", desc = "avante: new chat" },
      -- ACPModels, not Models: the model_selector behind :AvanteModels only knows
      -- the built-in providers. With provider = "claude-code" the model list comes
      -- from the ACP agent itself, so it needs an open sidebar with a live session.
      { "<leader>am", "<cmd>AvanteACPModels<cr>", desc = "avante: switch model" },
    },
    opts = {
      behaviour = {
        auto_set_keymaps = false, -- keep <leader>a* free; only `keys` above are bound
      },
      instructions_file = "avante.md", -- per-project instructions, if present

      -- Drives the local `claude` binary over the Agent Client Protocol, so
      -- auth is Claude Code's own — your subscription, through Anthropic's
      -- client. The `claude` provider with auth_type="max" is NOT used: that
      -- path spoofs the Claude CLI to get around Anthropic's block on
      -- subscription use in third-party tools, and now fails with HTTP 429
      -- at the OAuth token exchange.
      provider = "claude-code",
      mode = "agentic",
      acp_providers = {
        ["claude-code"] = {
          command = "claude-agent-acp", -- npm i -g @agentclientprotocol/claude-agent-acp
          args = {},
          -- avante's ACP client does NOT inherit the environment: it spawns the
          -- agent with only PATH plus whatever is listed here (see
          -- libs/acp_client.lua, `local final_env = {}`). Claude Code reads its
          -- credentials from the macOS keychain, which needs more of the
          -- session environment than that, so a stripped env fails at prompt
          -- time with -32000 "Authentication required". Pass it all through.
          env = vim.tbl_extend("force", vim.fn.environ(), {
            NODE_NO_WARNINGS = "1",
            -- CLAUDE_CODE_EXECUTABLE, not ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE:
            -- avante's default uses the latter, which belongs to Zed's
            -- claude-code-acp. This adapter ignores it and falls back to PATH,
            -- landing on the broken x86_64 binary -- which is why session/new
            -- hung forever and the sidebar sat on "generating".
            CLAUDE_CODE_EXECUTABLE = claude_exe(),
            -- avante's default. Lets the agent edit files without prompting
            -- per tool call; you still review changes in the sidebar diff.
            ACP_PERMISSION_MODE = "bypassPermissions",
          }),
        },
      },
      -- match the pickers already in this config
      file_selector = { provider = "telescope" },
      selector = { provider = "snacks" },
      input = { provider = "snacks" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- file_selector provider
      "folke/snacks.nvim", -- selector/input provider
      "nvim-tree/nvim-web-devicons",
      {
        -- image paste: avante overrides vim.paste when this is installed, so a plain
        -- Cmd+V in the Avante input buffer attaches the clipboard image. No keymap.
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
          },
        },
      },
      -- Renders the Avante sidebar; full spec lives in writing.lua
      "MeanderingProgrammer/render-markdown.nvim",
    },
  },
}
