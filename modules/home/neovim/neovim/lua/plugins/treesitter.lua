return {
  {
    "nvim-treesitter",
    after = function()
      require "nvim-treesitter.configs".setup {
        highlight = {
          enable = true
        },
        endwise = {
          enable = true
        },
        indent = {
          enable = true
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "]n",
            node_decremental = "[n",
          }
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
        textobjects = {
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
      }
    end
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
      { '<M-left>',  '<cmd>Treewalker Left<cr>zz' },
      { '<M-up>',    '<cmd>Treewalker Up<cr>zz' },
      { '<M-right>', '<cmd>Treewalker Right<cr>zz' },
      { '<M-down>',  '<cmd>Treewalker Down<cr>zz' },
    }
  }
}
