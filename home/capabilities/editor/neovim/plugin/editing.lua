local api = vim.api

vim.g.mkdp_theme = 'light'

vim.g.AutoPairsMapSpace = false

local leap = require 'leap'
leap.opts.safe_labels = {}
leap.add_default_mappings()

require 'neoscroll'.setup()

require 'colorizer'.setup({
  user_default_options = {
    mode = 'virtualtext',
    names = false
  }
})

require 'notify'.setup {
  background_colour = "#1e1c31",
  timeout = 2500,
  level = vim.log.levels.WARN,
  render = "compact",
  stages = "fade_in_slide_out"
}

require 'noice'.setup {
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  }
}

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


