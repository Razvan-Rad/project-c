vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local function save_file()
    vim.cmd('w')
    vim.notify('File saved!', vim.log.levels.INFO, { title = 'Success' })
  end
  
--   F6
-- Insert mode F6
    vim.keymap.set('n', '<F6>', 'gg=G<C-o>', { desc = 'Auto-indent entire file' })
    vim.keymap.set('i', '<F6>', '<Esc>gg=G<C-o>a', { desc = 'Auto-indent entire file' })
-- save
    vim.keymap.set('n', '<C-s>', save_file, { desc = 'Save file' })
    vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { desc = 'Save file' })
    vim.keymap.set('v', '<C-s>', '<Esc>:w<CR>', { desc = 'Save file' })
  
--   C-/
    vim.keymap.set({'n', 'v'}, '<C-_>', function()
    require('Comment.api').toggle.linewise.current()
  end, { desc = 'Toggle comment line' })
