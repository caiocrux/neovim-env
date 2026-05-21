-- Terminal Integration (preserved from existing config)
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { [[<C-\>]], desc = "Toggle terminal" },
    { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal horizontal" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Terminal vertical" },
  },
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      winbar = {
        enabled = false,
        name_formatter = function(term)
          return term.name
        end,
      },
    })

    -- Terminal mode keymaps
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    end

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*",
      callback = function()
        set_terminal_keymaps()
      end,
    })
  end,
}
