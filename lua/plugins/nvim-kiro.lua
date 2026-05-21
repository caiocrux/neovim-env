-- Kiro AI integration (chat with Kiro CLI inside Neovim)
-- Requires: kiro-cli installed and available in PATH
return {
  "ynnekF/nvim-kiro",
  version = "*",
  cmd = { "Kiro" },
  keys = {
    { "<leader>ki", "<cmd>Kiro<CR>", desc = "Open Kiro chat" },
    { "<leader>ke", desc = "Ask Kiro to explain selection", mode = "v" },
    { "<leader>kr", desc = "Ask Kiro to refactor selection", mode = "v" },
    { "<leader>kf", desc = "Ask Kiro to fix selection", mode = "v" },
    { "<leader>kq", desc = "Ask Kiro a question", mode = { "n", "v" } },
  },
  opts = {},
  config = function(_, opts)
    require("nvim-kiro").setup(opts)

    -- Helper: get visual selection text (works after exiting visual mode)
    local function get_visual_selection()
      -- Get marks set by the last visual selection
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      local start_line = start_pos[2]
      local end_line = end_pos[2]
      local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      if #lines == 0 then
        return ""
      end
      local start_col = start_pos[3]
      local end_col = end_pos[3]
      if #lines == 1 then
        lines[1] = string.sub(lines[1], start_col, end_col)
      else
        lines[1] = string.sub(lines[1], start_col)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
      end
      return table.concat(lines, "\n")
    end

    -- Helper: send code + prompt to kiro-cli in a terminal split
    local function kiro_ask(prompt_prefix)
      local code = get_visual_selection()
      if code == "" then
        vim.notify("No code selected", vim.log.levels.WARN)
        return
      end
      local filetype = vim.bo.filetype
      local filename = vim.fn.expand("%:t")
      local full_prompt = prompt_prefix
        .. "\n\nFile: "
        .. filename
        .. " (filetype: "
        .. filetype
        .. ")\n\n```"
        .. filetype
        .. "\n"
        .. code
        .. "\n```"

      -- Write prompt to a temp file to avoid shell escaping issues
      local tmpfile = vim.fn.tempname()
      local f = io.open(tmpfile, "w")
      if f then
        f:write(full_prompt)
        f:close()
      end

      -- Open terminal in a new split without replacing the code buffer
      vim.cmd("botright new")
      vim.cmd("resize 15")
      vim.fn.termopen("kiro-cli chat \"$(cat " .. tmpfile .. ")\"", {
        on_exit = function()
          os.remove(tmpfile)
        end,
      })
      vim.cmd("startinsert")
    end

    -- Helper: prompt user for a question then send with context
    local function kiro_question(has_selection)
      vim.ui.input({ prompt = "Ask Kiro: " }, function(input)
        if not input or input == "" then
          return
        end

        local filetype = vim.bo.filetype
        local filename = vim.fn.expand("%:t")
        local full_prompt = input

        if has_selection then
          local code = get_visual_selection()
          if code ~= "" then
            full_prompt = full_prompt
              .. "\n\nFile: "
              .. filename
              .. " (filetype: "
              .. filetype
              .. ")\n\n```"
              .. filetype
              .. "\n"
              .. code
              .. "\n```"
          end
        else
          full_prompt = full_prompt .. "\n\nContext file: " .. filename .. " (filetype: " .. filetype .. ")"
        end

        -- Write prompt to a temp file to avoid shell escaping issues
        local tmpfile = vim.fn.tempname()
        local f = io.open(tmpfile, "w")
        if f then
          f:write(full_prompt)
          f:close()
        end

        vim.cmd("botright new")
        vim.cmd("resize 15")
        vim.fn.termopen("kiro-cli chat \"$(cat " .. tmpfile .. ")\"", {
          on_exit = function()
            os.remove(tmpfile)
          end,
        })
        vim.cmd("startinsert")
      end)
    end

    -- Visual mode keymaps: select code, then press the key (stay in visual mode!)
    vim.keymap.set("v", "<leader>ke", function()
      -- Exit visual mode so '< and '> marks are set
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
      vim.schedule(function()
        kiro_ask("Explain the following code in detail. What does it do and why?")
      end)
    end, { desc = "Ask Kiro to explain selection", silent = true })

    vim.keymap.set("v", "<leader>kr", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
      vim.schedule(function()
        kiro_ask("Refactor the following code to improve readability and maintainability. Suggest improvements.")
      end)
    end, { desc = "Ask Kiro to refactor selection", silent = true })

    vim.keymap.set("v", "<leader>kf", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
      vim.schedule(function()
        kiro_ask("Find and fix any bugs or issues in the following code. Explain what was wrong.")
      end)
    end, { desc = "Ask Kiro to fix selection", silent = true })

    vim.keymap.set("v", "<leader>kq", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
      vim.schedule(function()
        kiro_question(true)
      end)
    end, { desc = "Ask Kiro a question (with selection)", silent = true })

    vim.keymap.set("n", "<leader>kq", function()
      kiro_question(false)
    end, { desc = "Ask Kiro a question", silent = true })
  end,
}
