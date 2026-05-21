-- Treesitter (syntax highlighting + parser for aerial, etc.)
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "c",
      "cpp",
      "python",
      "rust",
      "lua",
      "bash",
      "json",
      "yaml",
      "toml",
      "markdown",
      "gitcommit",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
