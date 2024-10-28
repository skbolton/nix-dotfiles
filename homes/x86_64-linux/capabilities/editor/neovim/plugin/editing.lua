vim.g.mkdp_theme = 'light'

vim.g.AutoPairsMapSpace = false

local flash = require 'flash'

vim.keymap.set("n", "<C-a>", function()
  require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<C-x>", function()
  require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("v", "<C-a>", function()
  require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "<C-x>", function()
  require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("v", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("v", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gvisual")
end)

flash.setup {}

vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump, { desc = "Jump to location" })

require 'copilot'.setup {}

require 'colorizer'.setup({
  user_default_options = {
    mode = 'virtualtext',
    names = false
  }
})

require 'ibl'.setup {
  indent = {
    char = "┊"
  },
  scope = {
    char = "│",
    -- highlight = "@type"
  }
}

require 'tide'.setup {
  keys = {
    leader = '<leader>m',
  },
  hints = {
    dictionary = 'rstdneio'
  }
}

-- local linter = require('lint')

-- linter.linters_by_ft = {
--   elixir = { 'credo' }
-- }

-- local lint_group = api.nvim_create_augroup(
--   'MyLNinter',
--   {}
-- )

-- api.nvim_create_autocmd(
--   { 'BufWritePost', 'BufEnter' },
--   {
--     pattern = {'*.ex', '*.exs' },
--     callback = linter.try_lint,
--     group = lint_group
--   }
-- )

vim.g.user_emmet_settings = {
  ['javascript.jsx'] = {
    extends = 'jsx',
  },
  elixir = {
    extends = 'html'
  },
  eelixir = {
    extends = 'html'
  },
  heex = {
    extends = 'html'
  }
}
vim.g.user_emmet_mode = 'inv'
