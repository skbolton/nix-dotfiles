local zk = require('zk')
local util = require('zk.util')
local commands = require('zk.commands')

zk.setup {
  picker = "telescope",
  lsp = {
    auto_attach = {
      enabled = true
    }
  }
}

commands.add("ZkProjects", function(options)
  local options = options or {}
  local tags = options.tags or {}
  tags[#tags+1] = "PROJECT"
  tags[#tags+1] = "open"
  options = vim.tbl_extend("force", { tags = tags }, options)
  zk.edit(options, { title = "Open Projects" })
end)

commands.add("ZkSpells", function(options)
  options = vim.tbl_extend("force", {tags = {"SPELL"} }, options or {})
  zk.edit(options, { title = "Spellbook" })
end)

vim.keymap.set('n', '<leader>n*', ':e logs/<C-R>=strftime("%Y-%m-%d")<CR>.md<CR>', { buffer = true, silent = true })

