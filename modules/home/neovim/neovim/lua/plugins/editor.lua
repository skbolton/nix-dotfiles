return {
  {
    'cfilter',
    event = "QuickFixCmdPre"
  },
  {
    "vim-surround",
    event = "User DeferredUIEnter"
  },
  {
    "vim-repeat",
    event = "User DeferredUIEnter"
  },
  {
    'nvim-autopairs',
    event = "InsertEnter",
    after = function()
      require('nvim-autopairs').setup {}
    end
  },
  {
    "vimplugin-spelunk-nvim",
    after = function()
      require 'spelunk'.setup {
        enable_persist = true,
        persist_by_git_branch = true,
        enable_status_col_display = true,
        base_mappings = {
          toggle = '<leader>mm',
          add = '<leader>ma',
          next_bookmark = '<c-i>',
          prev_bookmark = '<c-o>',
          search_bookmarks = '<leader>fm',
        }
      }
    end,
    keys = {
      '<c-o>',
      '<c-i>',
      '<leader>mm',
      '<leader>ma'
    }
  },
  {
    "luasnip",
    event = "User DeferredUIEnter",
  },
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
    'comment.nvim',
    after = function() require 'Comment'.setup() end,
    event = "User DeferredUIEnter",
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
    "playground",
    cmd = "TSPlaygroundToggle"
  }
}
