local gossip = require 'gossip'
local state = require 'gossip.state'

vim.print("hi")

gossip.contact {
  name = "ai",
  create = "split -h -l 120 opencode",
  find = "opencode"
}

vim.print(state.get_all_contacts())
