vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.filetype.add({
  extension = {
    qmd = "quarto",
  },
})

local opt = vim.opt

opt.autowrite = true
opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.confirm = true
opt.expandtab = true
opt.ignorecase = true
opt.inccommand = "split"
opt.laststatus = 3
opt.linebreak = true
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8
opt.shiftwidth = 2
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.spell = true
opt.spelllang = { "en_us", "de_de" }
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.undofile = true
opt.updatetime = 250
opt.wrap = true

-- noice renders the cmdline in a float, so the bottom line is dead space.
-- Revert to 1 if noice is ever removed or disabled.
opt.cmdheight = 0

opt.completeopt = { "menu", "menuone", "noselect" }
opt.fillchars = { eob = " " }
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "1"
