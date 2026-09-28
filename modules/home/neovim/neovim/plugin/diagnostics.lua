local map = vim.keymap.set

vim.diagnostic.config {
  underline = true,
  virtual_lines = { current_line = true },
  virtual_text = true,
  float = {
    max_width = 120
  },
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = '󱥁 ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = '󰒡 ',
    }
  }
}

map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
map('n', '<C-g>', vim.diagnostic.open_float)
