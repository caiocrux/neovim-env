-- Minimal init for running tests without plugins
-- This avoids loading lazy.nvim and plugins during test execution
vim.opt.rtp:prepend(".")
vim.opt.swapfile = false
vim.opt.backup = false

-- Load only config modules (no plugins)
require("config.options")
require("config.keymaps")
