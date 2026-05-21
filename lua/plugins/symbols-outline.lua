-- Symbol Outline (replaces Tagbar)
return {
  "simrat39/symbols-outline.nvim",
  keys = {
    { "<F9>", "<cmd>SymbolsOutline<CR>", desc = "Toggle symbols outline" },
  },
  opts = {
    position = "left",
    width = 25,
    auto_close = false,
    show_numbers = false,
    show_relative_numbers = false,
  },
}
