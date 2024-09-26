vim.g.mkdp_theme = 'light'

vim.g.AutoPairsMapSpace = false

local flash = require 'flash'

flash.setup {}

vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump, { desc = "Jump to location" })

require 'neoscroll'.setup()

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
