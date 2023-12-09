local bmap = vim.api.nvim_buf_set_keymap
local blocal = vim.opt_local
local capabilities = require 'lsp_capabilities'()

bmap(0, 'n', '<localleader>d', ':silent !xdg-open https://hexdocs.pm/', {noremap = true})

blocal.foldmethod = 'indent'

local executable = 'lexical'

if vim.fn.executable(executable) then
  vim.lsp.start {
    name = 'lexical',
    cmd = { executable },
    capabilities = capabilities,
    root_dir = vim.fs.dirname(vim.fs.find({'mix.exs', '.git'}, { upward = true })[1]),
    settings = {
      elixirLS = {
        dialyzerEnabled = true;
      }
    }
  }
end

