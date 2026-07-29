local map = vim.keymap.set

map("n", "<leader><Space>", "<cmd>w<CR>", { desc = "Write File" })
map("n", "<leader>rr", ":!python3 %<CR>", { desc = "Run current Python file" })
map("n", "ga", "<C-o>", { desc = "Jump back to previous file" })
map("n", "gA", "<C-i>", { desc = "Jump forward to next file" })
map("n", "<leader>ut", ":hi Normal guibg=NONE<CR>", { desc = "Toggle transparent background" })
