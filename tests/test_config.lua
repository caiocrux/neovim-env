-- ======================
--  Neovim Configuration Tests
--  Run with: nvim --headless -u tests/minimal_init.lua -l tests/test_config.lua
-- ======================

local errors = {}
local passed = 0
local failed = 0

local function assert_eq(actual, expected, msg)
  if actual == expected then
    passed = passed + 1
  else
    failed = failed + 1
    table.insert(errors, msg .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual))
  end
end

local function assert_true(val, msg)
  if val then
    passed = passed + 1
  else
    failed = failed + 1
    table.insert(errors, msg .. ": expected true, got " .. tostring(val))
  end
end

local function assert_keymap_exists(mode, lhs, msg)
  local maps = vim.api.nvim_get_keymap(mode)
  local found = false
  for _, map in ipairs(maps) do
    if map.lhs == lhs then
      found = true
      break
    end
  end
  if found then
    passed = passed + 1
  else
    failed = failed + 1
    table.insert(errors, msg .. ": keymap '" .. lhs .. "' not found in mode '" .. mode .. "'")
  end
end

-- ======================
--  Test: Options
-- ======================

print("Testing options...")

assert_eq(vim.opt.splitright:get(), true, "splitright should be true")
assert_eq(vim.opt.splitbelow:get(), true, "splitbelow should be true")
assert_eq(vim.opt.cursorline:get(), true, "cursorline should be true")
assert_eq(vim.opt.showmatch:get(), true, "showmatch should be true")
assert_eq(vim.opt.number:get(), true, "number should be true")
assert_eq(vim.opt.ruler:get(), true, "ruler should be true")
assert_eq(vim.opt.signcolumn:get(), "yes", "signcolumn should be 'yes'")
assert_eq(vim.opt.tabstop:get(), 4, "tabstop should be 4")
assert_eq(vim.opt.shiftwidth:get(), 4, "shiftwidth should be 4")
assert_eq(vim.opt.expandtab:get(), true, "expandtab should be true")
assert_eq(vim.opt.autoindent:get(), true, "autoindent should be true")
assert_eq(vim.opt.clipboard:get()[1], "unnamedplus", "clipboard should be 'unnamedplus'")

-- ======================
--  Test: Leader Key
-- ======================

print("Testing leader key...")

assert_eq(vim.g.mapleader, " ", "mapleader should be space")
assert_eq(vim.g.maplocalleader, " ", "maplocalleader should be space")

-- ======================
--  Test: Keymaps Exist
-- ======================

print("Testing keymaps...")

-- Function keys
assert_keymap_exists("n", "<F2>", "F2 toggle line numbers")
assert_keymap_exists("n", "<F3>", "F3 previous tab")
assert_keymap_exists("n", "<F4>", "F4 next tab")
assert_keymap_exists("n", "<F6>", "F6 highlight word")
assert_keymap_exists("n", "<F7>", "F7 toggle color column")
assert_keymap_exists("n", "<F8>", "F8 clang-format normal")
assert_keymap_exists("v", "<F8>", "F8 clang-format visual")

-- Window management
assert_keymap_exists("n", "<S-Left>", "Shift-Left resize")
assert_keymap_exists("n", "<S-Right>", "Shift-Right resize")
assert_keymap_exists("n", "<S-Up>", "Shift-Up resize")
assert_keymap_exists("n", "<S-Down>", "Shift-Down resize")

-- Window zoom
assert_keymap_exists("n", " wm", "Space-wm window zoom")

-- Git blame
assert_keymap_exists("n", " gb", "Space-gb git blame normal")
assert_keymap_exists("v", " gb", "Space-gb git blame visual")

-- Leader mappings
assert_keymap_exists("v", " gq", "Space-gq format paragraph")

-- ======================
--  Test: File Structure
-- ======================

print("Testing file structure...")

local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

assert_true(file_exists("init.lua"), "init.lua should exist")
assert_true(file_exists("lua/config/options.lua"), "lua/config/options.lua should exist")
assert_true(file_exists("lua/config/keymaps.lua"), "lua/config/keymaps.lua should exist")
assert_true(file_exists("lua/plugins/cmp.lua"), "lua/plugins/cmp.lua should exist")
assert_true(file_exists("lua/plugins/conform.lua"), "lua/plugins/conform.lua should exist")
assert_true(file_exists("lua/plugins/lsp.lua"), "lua/plugins/lsp.lua should exist")
assert_true(file_exists("lua/plugins/nvim-kiro.lua"), "lua/plugins/nvim-kiro.lua should exist")
assert_true(file_exists("lua/plugins/nvim-surround.lua"), "lua/plugins/nvim-surround.lua should exist")
assert_true(file_exists("lua/plugins/nvim-tree.lua"), "lua/plugins/nvim-tree.lua should exist")
assert_true(file_exists("lua/plugins/rustaceanvim.lua"), "lua/plugins/rustaceanvim.lua should exist")
assert_true(file_exists("lua/plugins/symbols-outline.lua"), "lua/plugins/symbols-outline.lua should exist")
assert_true(file_exists("lua/plugins/telescope.lua"), "lua/plugins/telescope.lua should exist")
assert_true(file_exists("lua/plugins/toggleterm.lua"), "lua/plugins/toggleterm.lua should exist")
assert_true(file_exists("lua/plugins/treesitter.lua"), "lua/plugins/treesitter.lua should exist")

-- ======================
--  Test: Plugin Specs Return Tables
-- ======================

print("Testing plugin specs...")

local plugin_files = {
  "plugins.cmp",
  "plugins.conform",
  "plugins.nvim-surround",
  "plugins.rustaceanvim",
  "plugins.telescope",
  "plugins.toggleterm",
  "plugins.treesitter",
}

for _, mod in ipairs(plugin_files) do
  local ok, result = pcall(require, mod)
  if ok then
    local is_table = type(result) == "table"
    assert_true(is_table, mod .. " should return a table")
  else
    failed = failed + 1
    table.insert(errors, mod .. " failed to load: " .. tostring(result))
  end
end

-- ======================
--  Test: No Personal Information
-- ======================

print("Testing for personal information leaks...")

local sensitive_patterns = {
  "/home/[%w%-]+/",       -- Hardcoded home paths
  "api_key",              -- API keys
  "password",            -- Passwords
  "secret",             -- Secrets
  "token",              -- Tokens
}

local files_to_check = {
  "init.lua",
  "lua/config/options.lua",
  "lua/config/keymaps.lua",
}

for _, filepath in ipairs(files_to_check) do
  local f = io.open(filepath, "r")
  if f then
    local content = f:read("*a")
    f:close()
    for _, pattern in ipairs(sensitive_patterns) do
      local match = content:match(pattern)
      if match then
        failed = failed + 1
        table.insert(errors, filepath .. " contains sensitive pattern: " .. pattern .. " (matched: " .. match .. ")")
      else
        passed = passed + 1
      end
    end
  end
end

-- ======================
--  Results
-- ======================

print("\n========================================")
print(string.format("  Results: %d passed, %d failed", passed, failed))
print("========================================")

if #errors > 0 then
  print("\nFailed tests:")
  for _, err in ipairs(errors) do
    print("  ✗ " .. err)
  end
  vim.cmd("cquit 1")  -- Exit with error code
else
  print("\n  All tests passed! ✓")
  vim.cmd("quit")     -- Exit with success
end
