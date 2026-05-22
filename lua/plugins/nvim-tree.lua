-- File Explorer (replaces NERDTree)
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    {
      "nvim-tree/nvim-web-devicons",
      opts = {
        override_by_extension = {
          ["c"] = { icon = "🇨", name = "C" },
          ["h"] = { icon = "🇭", name = "Header" },
          ["cpp"] = { icon = "⊕", name = "Cpp" },
          ["hpp"] = { icon = "⊕", name = "CppHeader" },
          ["cc"] = { icon = "⊕", name = "Cc" },
          ["py"] = { icon = "🐍", name = "Python" },
          ["txt"] = { icon = "📄", name = "Text" },
          ["md"] = { icon = "📝", name = "Markdown" },
          ["lua"] = { icon = "🌙", name = "Lua" },
          ["rs"] = { icon = "🦀", name = "Rust" },
          ["toml"] = { icon = "⚙", name = "Toml" },
          ["json"] = { icon = "⚙", name = "Json" },
          ["yaml"] = { icon = "⚙", name = "Yaml" },
          ["yml"] = { icon = "⚙", name = "Yml" },
          ["sh"] = { icon = "🐚", name = "Shell" },
          ["makefile"] = { icon = "⚒", name = "Makefile" },
        },
        default_icon = {
          icon = "📃",
          name = "Default",
        },
      },
    },
  },
  keys = {
    { "<F5>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
  },
  config = function()
    local api = require("nvim-tree.api")

    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- s = open in horizontal split (like NERDTree)
      vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))

      -- i = open in vertical split (like NERDTree)
      vim.keymap.set("n", "i", api.node.open.vertical, opts("Open: Vertical Split"))

      -- t = open in new tab (like NERDTree)
      vim.keymap.set("n", "t", api.node.open.tab, opts("Open: new tab"))


    end

    require("nvim-tree").setup({
      on_attach = on_attach,
      view = {
        side = "left",
        width = 30,
      },
      renderer = {
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            folder = {
              arrow_closed = "▸",
              arrow_open = "▾",
              default = "📁",
              open = "📂",
              empty = "📁",
              empty_open = "📂",
              symlink = "🔗",
              symlink_open = "🔗",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "⌥",
              renamed = "➜",
              untracked = "★",
              deleted = "⊖",
              ignored = "◌",
            },
          },
        },
      },
    })
  end,
}
