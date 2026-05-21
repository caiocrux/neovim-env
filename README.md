# Neovim Configuration

Modern Neovim configuration written entirely in Lua. Migrated from a traditional Vimscript setup to a modular structure using native Neovim 0.11+ APIs and lazy.nvim for plugin management.

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point: loads modules + bootstraps lazy.nvim
├── lazy-lock.json           # Plugin version lockfile
└── lua/
    ├── config/
    │   ├── options.lua      # Editor settings (vim.opt)
    │   └── keymaps.lua      # Key mappings (vim.keymap.set)
    └── plugins/
        ├── cmp.lua          # Autocompletion (nvim-cmp)
        ├── conform.lua      # Format on save (rustfmt)
        ├── lsp.lua          # Native LSP (vim.lsp.config/vim.lsp.enable)
        ├── nvim-kiro.lua    # Kiro AI assistant integration
        ├── nvim-surround.lua# Surround editing
        ├── nvim-tree.lua    # File explorer with Unicode icons
        ├── rustaceanvim.lua # Rust development
        ├── symbols-outline.lua # Code outline (aerial.nvim)
        ├── telescope.lua    # Fuzzy finder
        ├── toggleterm.lua   # Terminal integration
        └── treesitter.lua   # Syntax highlighting + parsers
```

## Requirements

- Neovim >= 0.11
- Git (for lazy.nvim bootstrap)
- A C compiler (for treesitter)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for Telescope live grep)
- Language servers (install via `:MasonInstall`):
  - `rust-analyzer` (Rust)
  - `pyright` (Python)
  - `clangd` (C/C++)
- `clang-format` (for C/C++ formatting with F8)
- `kiro-cli` (optional, for Kiro AI integration)

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repo
git clone https://github.com/caiocrux/nvim.git ~/.config/nvim

# Start Neovim — lazy.nvim will auto-install plugins
nvim
```

On first launch, treesitter will install parsers for C, C++, Python, Rust, Lua, bash, JSON, YAML, TOML, markdown, and gitcommit.

## Key Mappings

Leader key: `Space`

### General

| Key | Mode | Action |
|-----|------|--------|
| `<F2>` | Normal | Toggle line numbers |
| `<F3>` / `<F4>` | Normal | Previous / Next tab |
| `<F5>` | Normal | Toggle file explorer |
| `<F6>` | Normal | Highlight word under cursor |
| `<F7>` | Normal | Toggle color column at 80 |
| `<F8>` | Normal/Visual | Format with clang-format |
| `<F9>` | Normal | Toggle code outline (aerial) |

### Window Management

| Key | Mode | Action |
|-----|------|--------|
| `Shift+Arrow` | Normal | Resize splits |
| `<Space>wm` | Normal | Toggle window zoom (maximize/restore) |
| `Ctrl-w z` | Normal | Toggle window zoom (alternative) |

### LSP

| Key | Mode | Action |
|-----|------|--------|
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to declaration |
| `gr` | Normal | References |
| `K` | Normal | Hover documentation |
| `Ctrl-]` | Normal | Go to definition in vertical split |
| `<Space>gd` | Normal | Go to definition in horizontal split |
| `<Space>rn` | Normal | Rename symbol |
| `<Space>ca` | Normal | Code action |

### Telescope

| Key | Mode | Action |
|-----|------|--------|
| `<Space>ff` | Normal | Find files |
| `<Space>fg` | Normal | Live grep |
| `<Space>fb` | Normal | Find buffers |
| `<Space>fh` | Normal | Help tags |

### Terminal

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl-\` | Normal | Toggle terminal |
| `<Space>tt` | Normal | Toggle terminal |
| `<Space>th` | Normal | Terminal horizontal split |
| `<Space>tv` | Normal | Terminal vertical split |

### File Explorer (nvim-tree)

| Key | Action |
|-----|--------|
| `s` | Open in horizontal split |
| `i` | Open in vertical split |
| `Enter` | Open in current window |

### Git

| Key | Mode | Action |
|-----|------|--------|
| `<Space>gb` | Normal | Git blame for current line |
| `<Space>gb` | Visual | Git blame for selected lines (floating window) |

### Kiro AI

| Key | Mode | Action |
|-----|------|--------|
| `<Space>ki` | Normal | Open Kiro chat |
| `<Space>ke` | Visual | Explain selected code |
| `<Space>kr` | Visual | Refactor selected code |
| `<Space>kf` | Visual | Fix selected code |
| `<Space>kq` | Normal/Visual | Ask Kiro a question |

## Plugin Replacements

| Old (Vimscript) | New (Lua-native) |
|-----------------|------------------|
| vim-plug + pathogen | lazy.nvim |
| NERDTree | nvim-tree.lua |
| FZF | telescope.nvim |
| CoC | native LSP (vim.lsp.config) + nvim-cmp + mason |
| ALE | conform.nvim + native diagnostics |
| Tagbar | aerial.nvim |
| vim-surround | nvim-surround |
| rust.vim | rustaceanvim |

## Notes

- No Nerd Font required — all icons use standard Unicode characters
- LSP uses native Neovim 0.11+ API (`vim.lsp.config`/`vim.lsp.enable`), not the deprecated `nvim-lspconfig` framework
- Treesitter provides syntax highlighting and powers the aerial code outline
- The `industry` colorscheme is set in `lua/config/options.lua`

## License

MIT
