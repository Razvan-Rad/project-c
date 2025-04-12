return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "akinsho/toggleterm.nvim",
  },
  config = function()
    -- Basic setup
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true

    -- NvimTree configuration
    require("nvim-tree").setup({
      sort = { sorter = "case_sensitive" },
      view = { width = 30 },
      renderer = { group_empty = true },
      filters = { dotfiles = true },
    })

    -- Terminal configuration
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
      direction = "horizontal",
      size = 15,
      persist_size = true,
      shade_terminals = true,
      start_in_insert = true,
      close_on_exit = false,
    })

    local file_commands = {
      rust = "cargo run",
      python = "python3 %",
      javascript = "node %",
      typescript = "ts-node %",
      lua = "lua %",
      sh = "bash %",
    }

    -- Function to get and run the appropriate command
    local function run_file_command()
      local filetype = vim.bo.filetype
      local cmd = file_commands[filetype] or "echo 'No command defined for this filetype'"
      
      local term = require("toggleterm.terminal").get(1)
      if not term:is_open() then
        term:open()
      end
      
      term:send(cmd, false)
      term:focus()
    end

    -- Key mappings
    vim.keymap.set("n", "<F5>", run_file_command, { desc = "Run file-specific command" })
    vim.keymap.set({ "n", "t" }, "<F12>", function()
      require("toggleterm.terminal").get(1):toggle()
    end, { desc = "Toggle terminal" })

    -- Startup layout
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      callback = function()
        -- Open and position NvimTree
        vim.cmd("NvimTreeOpen | wincmd H | vertical resize 30")
        
        -- Open terminal (hidden)
        local term = require("toggleterm.terminal").Terminal:new({ id = 1, on_open = function(term) vim.opt_local.statusline = " " end })
        if not term:is_open() then
          term:toggle()
          vim.cmd("stopinsert | wincmd p")
        end
      end,
    })
  end,
}