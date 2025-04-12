return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "akinsho/toggleterm.nvim",
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true

    -- Setup NvimTree
    require("nvim-tree").setup({
      sort = { sorter = "case_sensitive" },
      view = { width = 30 },
      renderer = { group_empty = true },
      filters = { dotfiles = true },
    })

    -- Setup terminal
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
      direction = "horizontal",
      size = 15,
      persist_size = true,
      shade_terminals = true,
      start_in_insert = true,
      close_on_exit = false,
      on_open = function(term)
        vim.opt_local.statusline = " "
        -- Ensure terminal goes to bottom
        vim.cmd("wincmd J")
      end,
    })

    -- Auto-open layout on startup
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      callback = function()
        -- Open NvimTree at top
        vim.cmd("NvimTreeOpen")
        vim.cmd("wincmd K")
        vim.cmd("resize 30")
        
        -- Open terminal at bottom but don't focus it
        local Terminal = require("toggleterm.terminal").Terminal
        local term = Terminal:new({ id = 1 })
        if not term:is_open() then
          term:toggle()
          -- Immediately switch focus back to editor
          vim.cmd("wincmd p")
        end
      end,
    })

    -- F12 mapping to toggle terminal
    vim.keymap.set({ "n", "t" }, "<F12>", function()
      local term = require("toggleterm.terminal").get(1)
      
      if term:is_open() then
        if vim.api.nvim_get_current_win() == term.window then
          term:close()
        else
          term:focus()
        end
      else
        term:open()
        term:focus()
      end
    end, { noremap = true, silent = true })

    -- Additional autocmd to ensure statusline stays clean
    vim.api.nvim_create_autocmd({ "TermOpen" }, {
      pattern = "term://*",
      callback = function()
        vim.opt_local.statusline = " "
      end,
    })
  end,
}