return {
  {
    "nvim-treesitter",
    before = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { '*' },
        callback = function()
          local success = pcall(vim.treesitter.start)

          if success then
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo[0][0].foldmethod = 'expr'

            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end
  },
  {
    "nvim-treesitter-textobjects",
    event = "User DeferredUIEnter",
    after = function()
      require 'nvim-treesitter-textobjects'.setup {
        select = {
          enable = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["ic"] = "@comment.inner",
            ["ac"] = "@comment.outer",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["am"] = "@class.outer",
            ["im"] = "@class.inner",
            ["ib"] = "@block.inner",
            ["ab"] = "@block.outer"
          }
        },
        move = {
          enable = true,
          set_jumps = false,
          goto_next_start = {
            ["]]"] = "@function.outer",
          },
          goto_next_end = {
            ["]["] = "@function.outer",
          },
          goto_previous_start = {
            ["[["] = "@function.outer",
          },
          goto_previous_end = {
            ["[]"] = "@function.outer",
          },
        },
      }
    end
  },
  {
    "nvim-treesitter-endwise",
    event = "User DeferredUIEnter"
  },
  {
    "treewalker-nvim",
    after = function()
      require 'treewalker'.setup {
        highlight = true,
        highlight_group = "Visual"
      }
    end,
    keys = {
      { '<left>',  '<cmd>Treewalker Left<cr>zz' },
      { '<up>',    '<cmd>Treewalker Up<cr>zz' },
      { '<right>', '<cmd>Treewalker Right<cr>zz' },
      { '<down>',  '<cmd>Treewalker Down<cr>zz' },
    }
  }
}
