return {
  {
    'nvim-lint',
    event = "BufWritePost",
    after = function()
      local linter = require('lint')

      linter.linters_by_ft = {
        elixir = { 'credo' }
      }

      local lint_group = vim.api.nvim_create_augroup(
        'MyLinter',
        {}
      )

      vim.api.nvim_create_autocmd(
        { 'BufWritePost', 'BufEnter' },
        {
          pattern = { '*.ex', '*.exs' },
          callback = function() linter.try_lint() end,
          group = lint_group
        }
      )
    end
  },
  {
    "vimplugin-tide.nvim",
    after = function()
      require 'tide'.setup {
        keys = {
          leader = '<leader>o',
          panel = "o"
        },
        hints = {
          dictionary = 'neitsr'
        }
      }
    end,
    keys = { "<leader>o" }
  },
  {
    'comment.nvim',
    after = function() require 'Comment'.setup() end,
    event = "UIEnter",
  },
  {
    "flash.nvim",
    after = function()
      require 'flash'.setup {}
    end,
    keys = {
      { "s", function() require("flash").jump() end,                                   desc = "Flash",            mode = { "n", "x", "o" } },
      { "S", function() require("flash").treesitter({ jump = { pos = "start" } }) end, desc = "Flash treesitter", mode = { "n", "x", "o" } }
    },
  },
  {
    "vim-wakatime",
    event = "InsertEnter"
  },
  {
    "playground",
    cmd = "TSPlaygroundToggle"
  }
}
