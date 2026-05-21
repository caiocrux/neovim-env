-- Code Outline (replaces symbols-outline.nvim which is deprecated)
-- aerial.nvim is actively maintained and supports Neovim 0.11+
return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<F9>", "<cmd>AerialToggle<CR>", desc = "Toggle code outline" },
  },
  opts = {
    layout = {
      default_direction = "left",
      width = 30,
    },
    attach_mode = "global",
    show_guides = true,
    icons = {
      Array = "[] ",
      Boolean = "⊨ ",
      Class = "∷ ",
      Constant = "π ",
      Constructor = "⬡ ",
      Enum = "∈ ",
      EnumMember = "∈ ",
      Event = "⚡ ",
      Field = "→ ",
      File = "📄 ",
      Function = "ƒ ",
      Interface = "◌ ",
      Key = "🔑 ",
      Method = "ƒ ",
      Module = "📦 ",
      Namespace = "◇ ",
      Null = "∅ ",
      Number = "# ",
      Object = "{} ",
      Operator = "± ",
      Package = "📦 ",
      Property = "→ ",
      String = "\" ",
      Struct = "⊞ ",
      TypeParameter = "𝙏 ",
      Variable = "χ ",
    },
  },
}
