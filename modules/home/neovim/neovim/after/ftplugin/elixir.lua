local gossip = require 'gossip'

local iex = gossip.contact {
  name = "iex",
  create = {
    split = { dir = "h", size = "120" }
  },
  match_command = "iex",
}

-- vim.keymap.set({'n', 'v'}, '<C-c><C-c>', function() iex:send_command() end, { buffer = true })
vim.keymap.set({ 'n', 'v' }, '<C-c><C-c>', function() vim.print("hey") end, { buffer = true })
