local quicker = require 'quicker'
local map = vim.keymap.set

quicker.setup {
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  }
}

map({ 'n', 'v' }, ';', ':')
map({ 'n', 'v' }, ':', ';', { silent = true })
map({ 'n', 'v' }, 'gy', '"+y')
map('n', '<UP>', function() quicker.open() end)
map('n', '<DOWN>', function() quicker.close() end)
map('n', '<RIGHT>', '<CMD>cnext<CR>zz')
map('n', '<LEFT>', '<CMD>cprev<CR>zz')

map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')
map('n', 'g;', 'g;zz')
map('n', 'g,', 'g,zz')
map('n', '<C-o>', '<C-o>zz')
map('n', '<C-i>', '<C-i>zz')
map('n', '*', '*zz')
map('n', '#', '#zz')
map('n', '<BS>', '<CMD>b#<CR>')
map('v', '<', '<gv')
map('v', '>', '>gv')
map('v', 'p', '"_c<c-r>0')
map('v', 'J', ":m '>+1<cr>gv=gv'")
map('v', 'K', ":m '<-2<cr>gv=gv'")
map('n', '<leader>,', '<CMD>nohlsearch<CR>')
map('n', '<leader>>', ':!<SPACE>', { silent = false })
map('t', '<ESC>', '<c-\\><c-n>', { silent = false })
map('n', '[x', '<CMD>set cursorcolumn<CR>')
map('n', ']x', '<CMD>set nocursorcolumn<CR>')
