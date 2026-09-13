return {
  {
    "aerial.nvim",
    after = function()
      require 'aerial'.setup {
        layout = {
          min_width = 40
        }
      }
    end,
    cmd = "AerialToggle"
  },
  {
    "nvim-navic",
    after = function()
      local navic = require('nvim-navic')

      navic.setup {
        highlight = false,
        depth_limit = 3,
        separator = " | ",
        icons = {
          File = ' ',
          Module = ' ',
          Namespace = ' ',
          Package = ' ',
          Class = ' ',
          Method = ' ',
          Property = ' ',
          Field = ' ',
          Constructor = ' ',
          Enum = ' ',
          Interface = ' ',
          Function = ' ',
          Variable = ' ',
          Constant = ' ',
          String = ' ',
          Number = ' ',
          Boolean = ' ',
          Array = ' ',
          Object = ' ',
          Key = ' ',
          Null = ' ',
          EnumMember = ' ',
          Struct = ' ',
          Event = ' ',
          Operator = ' ',
          TypeParameter = ' '
        }
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(env)
          local buffer = env.buf
          local client = vim.lsp.get_client_by_id(env.data.client_id)

          if client:supports_method("textDocument/documentSymbol") then
            navic.attach(client, buffer)
          end
        end
      })
    end
  }
}
