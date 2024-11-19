local lsp_lines = require 'lsp_lines'

local map = vim.keymap.set

lsp_lines.setup()

local default_diagnostic_config = {
  underline = true,
  virtual_lines = false,
  virtual_text = true,
  signs = true,
}

vim.diagnostic.config(default_diagnostic_config)

map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<C-g>', function()
  vim.diagnostic.config { virtual_lines = true, virtual_text = false }

  vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "*",
    callback = function()
      vim.diagnostic.config(default_diagnostic_config)

      -- detach handler after first use
      return true
    end
  })
end)

-- Sign Icons
local signs = { Error = '🯀', Warn = '🯀', Hint = '⌕', Info = '🞔' }

-- Consigure signs
for type, icon in pairs(signs) do
  local highlight = "DiagnosticSign" .. type
  vim.fn.sign_define(highlight, { text = icon, texthl = highlight })
end
