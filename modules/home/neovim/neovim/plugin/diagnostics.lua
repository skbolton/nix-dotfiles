local map = vim.keymap.set

local default_diagnostic_config = {
  underline = true,
  virtual_lines = false,
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = '⌕',
      [vim.diagnostic.severity.INFO] = '🞔',
      [vim.diagnostic.severity.ERROR] = '🯀',
      [vim.diagnostic.severity.WARN] = '🯀',
    }
  }
}

vim.diagnostic.config(default_diagnostic_config)

map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
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
