local gossip = require 'gossip'

gossip.contact {
  name = "elixir",
  create = {
    split = { dir = "h", size = "120", command = "iex -S mix" }
  },
  match_command = "beam.smp",
  breakup_on_exit = false
}

vim.keymap.set('v', '<leader>ee', function()
    local table_with_enters = {}
    local selection = gossip.selection()
    for i, line in ipairs(selection) do
      table.insert(table_with_enters, line)
      if i <= #selection then
        table.insert(table_with_enters, "Enter")
      end
    end

    gossip.send("elixir", table_with_enters)
  end,
  { buffer = true }
)
