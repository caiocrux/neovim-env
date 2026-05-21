-- Rust Development (replaces rust.vim)
return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  ft = "rust",
  config = function()
    -- Rust-specific keymaps (set via autocmd in autocmds.lua)
    -- rustaceanvim auto-configures rust-analyzer
  end,
}
