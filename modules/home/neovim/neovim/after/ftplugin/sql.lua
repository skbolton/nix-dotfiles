local keymap = vim.keymap

keymap.set('n', '<leader>\\', '<CMD>DBUIToggle<CR>', { buffer = true })
keymap.set('n', '<localleader>r', ':normal vip<CR><PLUG>(DBUI_ExecuteQuery)', { buffer = true })
keymap.set('v', '<localleader>r', '<PLUG>(DBUI_ExecuteQuery)<CR>', { buffer = true })
keymap.set('n', '<localleader>F', ':%!sqlFormat .<CR>', { buffer = true })
keymap.set('n', '<localleader>f', ':normal vip<CR>:!sqlFormat<CR>', { buffer = true })
keymap.set('v', '<localleader>f', ':!sqlFormat<CR>', { buffer = true })
keymap.set('n', '<leader>w', '<PLUG>(DBUI_SaveQuery)', { buffer = true })
