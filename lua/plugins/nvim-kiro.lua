-- Kiro AI integration (chat with Kiro CLI inside Neovim)
-- Requires: kiro-cli installed and available in PATH
return {
  "ynnekF/nvim-kiro",
  version = "*",
  cmd = { "Kiro" },
  keys = {
    { "<leader>ki", "<cmd>Kiro<CR>", desc = "Open Kiro chat" },
  },
  opts = {},
}
