return {
  {
    "vimplugin-hlchunk.nvim",
    event = "BufReadPre",
    after = function()
      require("hlchunk").setup {
        chunk = {
          enable = true,
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = "─",
          },
          style = { vim.api.nvim_get_hl(0, { name = "Comment" }) },
          textobject = "is"
        },
        indent = {
          enable = true,
          chars = { "┊" }
        }
      }
    end
  },
  {
    'venn.nvim',
    ft = "markdown"
  },
  {
    "nvim-colorizer.lua",
    event = "BufReadPre",
    after = function()
      require 'colorizer'.setup({
        user_default_options = {
          mode = 'virtualtext',
          names = false
        }
      })
    end
  },
}
