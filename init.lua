-- ======================
--  Neovim Configuration Entry Point
-- ======================

-- Load config modules with error isolation
local modules = { "config.options", "config.keymaps"}
for _, mod in ipairs(modules) do
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify("Failed to load " .. mod .. ": " .. err, vim.log.levels.WARN)
  end
end

-- ======================
--  lazy.nvim Bootstrap
-- ======================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin specs from lua/plugins/
require("lazy").setup("plugins")
