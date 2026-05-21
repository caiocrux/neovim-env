-- LSP Configuration (native vim.lsp.config for Neovim 0.11+)
-- No nvim-lspconfig dependency — uses built-in vim.lsp API
return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall" },
    opts = {},
  },
  {
    -- Trigger LSP setup on file open
    "hrsh7th/cmp-nvim-lsp",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
        callback = function(ev)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc, silent = true })
          end
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

          -- Ctrl-] : go to definition in a vertical split (like old FollowTag)
          map("n", "<C-]>", function()
            vim.cmd("vsplit")
            vim.lsp.buf.definition()
          end, "Go to definition in vsplit")

          -- gd stays as jump-in-place, use <leader>gd for horizontal split
          map("n", "<leader>gd", function()
            vim.cmd("split")
            vim.lsp.buf.definition()
          end, "Go to definition in hsplit")
        end,
      })

      -- Get capabilities from cmp-nvim-lsp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configure LSP servers using native Neovim 0.11+ API
      vim.lsp.config("rust_analyzer", {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", "rust-project.json" },
        capabilities = capabilities,
      })

      vim.lsp.config("pyright", {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        capabilities = capabilities,
      })

      -- Enable servers
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("pyright")
    end,
  },
}
