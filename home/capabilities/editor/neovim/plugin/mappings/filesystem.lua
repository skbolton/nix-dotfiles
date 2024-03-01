local map = vim.keymap.set
local tfm = require 'tfm'
-- local nnn = require 'nnn'

tfm.setup {
  ui = {
    height = 0.9,
    width = 0.9,
    x = 0.5,
    y = 0.5
  }
}

map('n', '<leader>e', function() tfm.open(vim.fn.expand('%')) end)
map('n', '<leader>e', tfm.open)
map('n', '<leader>_', ':silent grep ', { silent = false })

-- nnn.setup {
--   offset = true,
--   explorer = {
--     width = 24
--   },
--   picker = {
--     cmd = "tmux new-session -s EXPLR nnn -Pp",
--     border = "rounded"
--   },
--   mappings = {
--     { "<C-t>", nnn.builtin.open_in_tab },       -- open file(s) in tab
--     { "<C-x>", nnn.builtin.open_in_split },     -- open file(s) in split
--     { "<C-v>", nnn.builtin.open_in_vsplit },    -- open file(s) in vertical split
--   }
-- }
