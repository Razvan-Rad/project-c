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
  require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    direction = "horizontal",
    size = 15,
    persist_size = true,
    shade_terminals = true,
    start_in_insert = true,
    close_on_exit = false,
  })

  -- Modify the VimEnter autocmd
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        -- Open NvimTree at left
        vim.cmd("NvimTreeOpen")
        vim.cmd("wincmd H")  -- Move to far left
        vim.cmd("vertical resize 30")
        
        -- Open terminal at bottom
        local Terminal = require("toggleterm.terminal").Terminal
        local term = Terminal:new({
            id = 1,
            direction = "horizontal",
            on_open = function(term)
                vim.opt_local.statusline = " "
                -- Ensure terminal stays at bottom
                vim.cmd("wincmd J")
            end
        })
        
        if not term:is_open() then
            term:toggle()
            vim.cmd("stopinsert")
            vim.cmd("wincmd p")  -- Go back to previous window
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
        -- Ensure we're in normal mode when terminal opens
        vim.cmd("stopinsert")
      end,
    })
  end,
}