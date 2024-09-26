local map = vim.keymap.set

map('n', '<leader>tT', '<CMD>TestFile<CR>')
map('n', '<leader>tt', '<CMD>TestFile -strategy=vimux_watch<CR>')
map('n', '<leader>tN', '<CMD>TestNearest<CR>')
map('n', '<leader>tn', '<CMD>TestNearest -strategy=vimux_watch<CR>')
map('n', '<leader>t.', '<CMD>TestLast<CR>')
map('n', '<leader>tv', '<CMD>TestVisit<CR>zz')
map('n', '<leader>ts', '<CMD>TestSuite -strategy=vimux_watch<CR>')
map('n', '<leader>tS', '<CMD>TestSuite<CR>')
