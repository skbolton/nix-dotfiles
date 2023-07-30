local map = vim.keymap.set

vim.g["nnn#action"] = {
  ['<c-t>'] = 'tab split',
  ['<c-x>'] = 'split',
  ['<c-v>'] = 'vsplit' 
}

vim.g["nnn#set_default_mappings"] = false

map('n', '<leader>E', '<CMD>NnnExplorer<CR>')
map('n', '<leader>e', '<CMD>NnnPicker %:p<CR>')
map('n', '<leader>_', ':silent grep ', { silent = false })
