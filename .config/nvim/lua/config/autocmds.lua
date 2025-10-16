vim.api.nvim_create_augroup("TransparentBG", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = "TransparentBG",
  pattern = "*",
  callback = function()
    vim.cmd("highlight Normal ctermbg=none guibg=none")
    vim.cmd("highlight NonText ctermbg=none guibg=none")
    vim.cmd("highlight EndOfBuffer ctermbg=none guibg=none")
  end,
})
