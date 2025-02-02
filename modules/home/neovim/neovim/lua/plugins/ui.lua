return {
  {
    "indent-blankline.nvim",
    event = "BufReadPre",
    after = function()
      require 'ibl'.setup {
        indent = {
          char = "┊"
        },
        scope = {
          char = "│",
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
