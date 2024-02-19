local nnn = require 'nnn'
local map = vim.keymap.set

nnn.setup {
  offset = true,
  explorer = {
    width = 24
  },
  picker = {
    cmd = "tmux new-session -s EXPLR nnn -Pp",
    border = "rounded"
  },
  mappings = {
    { "<C-t>", nnn.builtin.open_in_tab },       -- open file(s) in tab
    { "<C-x>", nnn.builtin.open_in_split },     -- open file(s) in split
    { "<C-v>", nnn.builtin.open_in_vsplit },    -- open file(s) in vertical split
  }
}

map('n', '<leader>E', '<CMD>NnnExplorer<CR>')
map('n', '<leader>e', '<CMD>NnnPicker %:p<CR>')
map('n', '<leader>_', ':silent grep ', { silent = false })
