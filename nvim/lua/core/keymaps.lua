local map = vim.keymap.set

map("n", "<leader><Space>", "<cmd>w<CR>", { desc = "Write file" })
map("n", "<leader>rr", "<cmd>write<CR><cmd>!python3 %<CR>", { desc = "Run current Python file" })
map("n", "ga", "<C-o>", { desc = "Jump back" })
map("n", "gA", "<C-i>", { desc = "Jump forward" })

-- UI
map("n", "<leader>ut", "<cmd>TransparentBackground<CR>", { desc = "Transparent background" })
map("n", "<leader>us", function() Snacks.picker.colorschemes() end, { desc = "Color schemes" })
map("n", "<leader>u1", "<cmd>colorscheme tokyonight<CR>", { desc = "Tokyonight" })
map("n", "<leader>u2", "<cmd>colorscheme catppuccin<CR>", { desc = "Catppuccin" })
map("n", "<leader>u3", "<cmd>colorscheme kanagawa<CR>", { desc = "Kanagawa" })
map("n", "<leader>u4", "<cmd>colorscheme rose-pine<CR>", { desc = "Rose Pine" })

map("n", "<leader>uz", function() Snacks.zen() end, { desc = "Zen mode" })
map("n", "<leader>uZ", function() Snacks.zen.zoom() end, { desc = "Zoom (keep statusline)" })

map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Quit. `confirm` is on, so a plain :qa on a modified buffer drops into a
-- blocking Y/N/C prompt that is easy to miss with cmdheight=0 — hence one
-- explicit map per intent instead of relying on that dialog.
map("n", "<leader>qq", "<cmd>confirm qa<CR>", { desc = "Quit all" })
map("n", "<leader>qw", "<cmd>wqa<CR>", { desc = "Save all and quit" })
map("n", "<leader>qQ", "<cmd>qa!<CR>", { desc = "Quit all, discard changes" })
map("n", "<leader>qo", "<cmd>close<CR>", { desc = "Close this window" })

-- Buffers
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete other buffers" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>cl", vim.diagnostic.setloclist, { desc = "Diagnostics list" })

-- Lazy
map("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Lazy home" })
map("n", "<leader>li", "<cmd>Lazy install<CR>", { desc = "Lazy install" })
map("n", "<leader>ls", "<cmd>Lazy sync<CR>", { desc = "Lazy sync" })
map("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "Lazy update" })
map("n", "<leader>lc", "<cmd>Lazy check<CR>", { desc = "Lazy check" })
map("n", "<leader>lx", "<cmd>Lazy clean<CR>", { desc = "Lazy clean" })
map("n", "<leader>lp", "<cmd>Lazy profile<CR>", { desc = "Lazy profile" })

-- Git (all via snacks, which is loaded eagerly — no extra plugins)
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Status" })
map("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Branches" })
map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Log" })
map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Log (this file)" })
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Diff hunks" })
map("n", "<leader>gt", function() Snacks.picker.git_stash() end, { desc = "Stashes" })
map("n", "<leader>gB", function() Snacks.git.blame_line() end, { desc = "Blame line" })
map({ "n", "v" }, "<leader>go", function() Snacks.gitbrowse() end, { desc = "Open in GitHub" })

-- Claude Code CLI in snacks terminal (<leader>sc)
-- Deferred in function so Snacks is available at key-press time (not load time)
-- /opt/homebrew is the native arm64 build; the /usr/local cask is x86_64 and
-- hangs under Rosetta (Bun requires AVX). See lua/plugins/ai.lua.
map("n", "<leader>sc", function()
  local claude = vim.fn.executable("/opt/homebrew/bin/claude") == 1 and "/opt/homebrew/bin/claude"
    or vim.fn.exepath("claude")
  Snacks.terminal.toggle(claude, { cwd = vim.fn.getcwd() })
end, { desc = "Claude Code" })
