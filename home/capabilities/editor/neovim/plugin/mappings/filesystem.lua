local map = vim.keymap.set
local nnn = require 'nnn'
local oil = require 'oil'

oil.setup {
  keymaps = {
    -- stub out defaults that clash
    ["<C-s>"] = false,
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-x>"] = "actions.select_split",
    ["<C-v>"] = "actions.select_vsplit",
  }
}

map('n', '<leader>_', ':silent grep ', { silent = false })
map('n', '<leader>e', '<CMD>Oil<CR>')
