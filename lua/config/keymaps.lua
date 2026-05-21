-- ======================
--  Key Mappings
-- ======================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- ======================
--  Function Keys
-- ======================

-- F2: Toggle line numbers
map("n", "<F2>", "<cmd>set invnumber<CR>", { desc = "Toggle line numbers", silent = true })

-- F3/F4: Tab navigation
map("n", "<F3>", "<cmd>tabprevious<CR>", { desc = "Previous tab", silent = true })
map("n", "<F4>", "<cmd>tabnext<CR>", { desc = "Next tab", silent = true })

-- F5: File explorer toggle (defined in nvim-tree plugin spec)

-- F6: Highlight word under cursor
map("n", "<F6>", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\<" .. word .. "\\>")
  vim.opt.hlsearch = true
end, { desc = "Highlight word under cursor", silent = true })

-- F7: Toggle color column at 80
map("n", "<F7>", function()
  if vim.wo.colorcolumn == "" then
    vim.wo.colorcolumn = "80"
  else
    vim.wo.colorcolumn = ""
  end
end, { desc = "Toggle color column at 80", silent = true })

-- F8: Format with clang-format
map("n", "<F8>", "<cmd>%!clang-format<CR>", { desc = "Format buffer with clang-format", silent = true })
map("v", "<F8>", ":!clang-format<CR>", { desc = "Format selection with clang-format", silent = true })

-- F9: Symbol outline toggle (defined in symbols-outline plugin spec)

-- ======================
--  Window Management
-- ======================

map("n", "<S-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease split width", silent = true })
map("n", "<S-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase split width", silent = true })
map("n", "<S-Up>", "<cmd>resize +2<CR>", { desc = "Increase split height", silent = true })
map("n", "<S-Down>", "<cmd>resize -2<CR>", { desc = "Decrease split height", silent = true })

-- Window zoom/maximize toggle
-- Press <leader>wm to maximize current split, press again to restore
local _zoomed = false
local _zoom_winrestcmd = ""

map("n", "<leader>wm", function()
  if _zoomed then
    -- Restore previous layout
    vim.cmd(_zoom_winrestcmd)
    _zoomed = false
  else
    -- Save current layout and maximize
    _zoom_winrestcmd = vim.fn.winrestcmd()
    vim.cmd("wincmd _")  -- maximize height
    vim.cmd("wincmd |")  -- maximize width
    _zoomed = true
  end
end, { desc = "Toggle window zoom (fullscreen/restore)", silent = true })

-- Alternative: Ctrl-w z for quick zoom toggle
map("n", "<C-w>z", function()
  if _zoomed then
    vim.cmd(_zoom_winrestcmd)
    _zoomed = false
  else
    _zoom_winrestcmd = vim.fn.winrestcmd()
    vim.cmd("wincmd _")
    vim.cmd("wincmd |")
    _zoomed = true
  end
end, { desc = "Toggle window zoom", silent = true })

-- ======================
--  Leader Mappings
-- ======================

-- Visual mode paragraph formatting
map("v", "<leader>gq", "gq", { desc = "Format paragraph", silent = true })

-- ======================
--  Git
-- ======================

-- Git blame for current line
map("n", "<leader>gb", function()
  local line = vim.fn.line(".")
  local file = vim.fn.expand("%")
  local blame = vim.fn.system("git blame -L " .. line .. "," .. line .. " -- " .. vim.fn.shellescape(file))
  vim.notify(vim.fn.trim(blame), vim.log.levels.INFO)
end, { desc = "Git blame current line", silent = true })

-- Git blame for selected lines (visual mode)
map("v", "<leader>gb", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  vim.schedule(function()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local file = vim.fn.expand("%")
    local blame = vim.fn.system(
      "git blame -L " .. start_line .. "," .. end_line .. " -- " .. vim.fn.shellescape(file)
    )
    -- Show in a floating window for multi-line blame
    local lines = vim.split(vim.fn.trim(blame), "\n")
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    local width = math.min(120, vim.o.columns - 4)
    local height = math.min(#lines, 20)
    vim.api.nvim_open_win(buf, true, {
      relative = "cursor",
      row = 1,
      col = 0,
      width = width,
      height = height,
      style = "minimal",
      border = "rounded",
    })
    -- Close with q or Esc
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })
  end)
end, { desc = "Git blame selection", silent = true })
