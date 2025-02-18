local map = vim.keymap.set

map({ 'n', 'v' }, ';', ':')
map({ 'n', 'v' }, ':', ';', { silent = true })
map({ 'n', 'v' }, 'gy', '"+y')
map('n', '<UP>', '<CMD>copen<CR>')
map('n', '<DOWN>', '<CMD>cclose<CR>')
map('n', '<RIGHT>', '<CMD>cnext<CR>')
map('n', '<LEFT>', '<CMD>cprev<CR>')

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
