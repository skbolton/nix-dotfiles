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
    before = function()
      vim.g.no_plugin_maps = true
    end,
    after = function()
      local select = require 'nvim-treesitter-textobjects.select'
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
      }

      vim.keymap.set({ "x", "o" }, "ic", function()
        select.select_textobject("@comment.inner", "textobjects")
      end)

      vim.keymap.set({ "x", "o" }, "ac", function()
        select.select_textobject("@comment.outer", "textobjects")
      end)

      vim.keymap.set({ "x", "o" }, "im", function()
        select.select_textobject("@class.inner", "textobjects")
      end)

      vim.keymap.set({ "x", "o" }, "am", function()
        select.select_textobject("@class.outer", "textobjects")
      end)

      vim.keymap.set({ "x", "o" }, "if", function()
        select.select_textobject("@function.inner", "textobjects")
      end)

      vim.keymap.set({ "x", "o" }, "af", function()
        select.select_textobject("@function.outer", "textobjects")
      end)

      vim.keymap.set({ "x", "o" }, "ib", function()
        select.select_textobject("@block.inner", "textobjects")
      end)

      vim.keymap.set({ "x", "o" }, "ab", function()
        select.select_textobject("@block.outer", "textobjects")
      end)
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
