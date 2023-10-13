local api = vim.api

vim.g.mkdp_theme = 'light'

vim.g.AutoPairsMapSpace = false

local leap = require 'leap'
leap.opts.safe_labels = {}
leap.add_default_mappings()

require 'neoscroll'.setup()
require 'headlines'.setup()
require 'hlslens'.setup()

require 'colorizer'.setup({
  user_default_options = {
    mode = 'virtualtext',
    names = false
  }
})

require 'nvim-nonicons'.setup {}

require 'ibl'.setup {
  indent = {
    char = "┊"
  },
  scope = {
    char = "│";
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


