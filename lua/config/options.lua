-- ======================
--  Editor Options
-- ======================

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- UI
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.number = true
vim.opt.ruler = true
vim.opt.signcolumn = "yes"

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Syntax and Colorscheme
vim.cmd("syntax enable")
vim.cmd("colorscheme industry")
