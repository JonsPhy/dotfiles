local transparent = vim.api.nvim_create_augroup("TransparentBackground", { clear = true })

local function clear_background()
  for _, group in ipairs({ "Normal", "NormalFloat", "NonText", "EndOfBuffer", "SignColumn" }) do
    vim.cmd.highlight(group .. " ctermbg=none guibg=none")
  end
end

vim.api.nvim_create_user_command("TransparentBackground", clear_background, {})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = transparent,
  callback = clear_background,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("WritingFileTypes", { clear = true }),
  pattern = { "tex", "markdown", "quarto", "rmd" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})
