require("neorg").setup {
  load = {
    ["core.defaults"] = {},
    ["core.dirman"] = {
      config = {
        config = {
          workspaces = {
            logbook = "~/Documents/Logbook",
            reference = "~/Documents/Reference"
          },
          default_workspace = "logbook"
        }
      }
    },
    ["core.tangle"] = {
      config = {
        tangle_on_write = true,
        report_on_empty = false
      }
    },
    ["core.todo-introspector"] = {
      config = {
        highlight_group = "Comment"
      }
    },
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp"
      }
    },
    ["core.promo"] = {},
    ["core.concealer"] = {
      config = {
        icon_preset = "diamond",
        icons = {
          code_block = { conceal = true },
          todo = { undone = { icon = " " } },
          -- heading = {
          --   icons = {
          --     "󰎦",
          --     "󰎩",
          --     "󰎬",
          --     "󰎮",
          --     "󰎰",
          --     "󰎵"
          --   }
          -- }
        }
      }
    }
  }
}

vim.keymap.set('n', '<leader>n^', ':e Logs/<C-R>=strftime("%Y-%m-%d")<CR>.md<CR>', { buffer = true, silent = true })
