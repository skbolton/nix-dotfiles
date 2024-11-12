local lsp_lines = require 'lsp_lines'

local map = vim.keymap.set

lsp_lines.setup()

vim.diagnostic.config {
  underline = true,
  virtual_lines = true,
  virtual_text = false,
  signs = true,
}

map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<C-g>', vim.diagnostic.open_float)

-- Sign Icons
local signs = { Error = '🯀', Warn = '🯀', Hint = '⌕', Info = '🞔' }

-- Consigure signs
for type, icon in pairs(signs) do
  local highlight = "DiagnosticSign" .. type
  vim.fn.sign_define(highlight, { text = icon, texthl = highlight })
end

local diagnostic_group = vim.api.nvim_create_augroup("DiagnosticVisibility", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  group = diagnostic_group,
  callback = function() vim.diagnostic.config { virtual_lines = false } end
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  group = diagnostic_group,
  callback = function() vim.diagnostic.config { virtual_lines = true } end
})
