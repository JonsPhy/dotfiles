vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("TransparentBG", { clear = true }),
  pattern = "*",
  callback = function()
    for _, group in ipairs({ "Normal", "NonText", "EndOfBuffer" }) do
      vim.cmd.highlight(group .. " ctermbg=none guibg=none")
    end
  end,
})
