local wk = require 'which-key'

wk.add {
  { "<leader>nn",    "<CMD>ZkNotes<CR>",                  desc = "Find note",      group = "+notes" },
  { "<leader>nN",    ":ZkNotes { tags = {}}<left><left>", desc = "Notes with tag", group = "+notes" },
  { "<leader>nt",    "<CMD>ZkTags<CR>",                   desc = "Tag search",     group = "+notes" },
  { "<leader>n.",    "<CMD>ZkBacklinks<CR>",              desc = "Backlinks",      group = "+notes" },
  { "<leader>n<up>", "<CMD>ZkLinks<CR>",                  desc = "Outbound links", group = "+notes" },
}
