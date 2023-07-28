local blocal = vim.opt_local
vim.cmd("packadd markdown-preview.nvim")

vim.keymap.set('n', '<localleader>r', '<CMD>MarkdownPreview<CR>', { buffer = true })
blocal.textwidth = 120
blocal.softtabstop = 2
blocal.shiftwidth = 2

vim.g.bullets_outline_levels = {'num', 'abc', 'std*'}

local toggle_todo = function()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local curline = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]

  if string.find(curline, "%- %[ ]") then
    vim.cmd('s/\\v-\\s\\[\\s\\]/- [x]')
    vim.cmd('nohlsearch')
  elseif string.find(curline, "%- %[x]") then
    vim.cmd('s/\\v-\\s\\[x\\]/- [ ]')
    vim.cmd('nohlsearch')
  end
end

local undone = function()
  vim.cmd('s/\\v(TODO|CANC|WAIT|DONE|BLOCK)\\:/TODO:')
  vim.cmd('nohlsearch')
end

local done = function() 
  vim.cmd('s/\\v(TODO|CANC|WAIT|DONE|BLOCK)\\:/DONE:')
  vim.cmd('nohlsearch')
end

local wait = function() 
  vim.cmd('s/\\v(TODO|CANC|WAIT|DONE|BLOCK)\\:/WAIT:')
  vim.cmd('nohlsearch')
end

local canc = function() 
  vim.cmd('s/\\v(TODO|CANC|WAIT|DONE|BLOCK)\\:/CANC:')
  vim.cmd('nohlsearch')
end

local block = function() 
  vim.cmd('s/\\v(TODO|CANC|WAIT|DONE|BLOCK)\\:/BLOCK:')
  vim.cmd('nohlsearch')
end


vim.keymap.set('n', '<C-SPACE>', toggle_todo, { buffer = true })
vim.keymap.set('n', '<localleader>tu', undone, { buffer = true })
vim.keymap.set('n', '<localleader>td', done, { buffer = true })
vim.keymap.set('n', '<localleader>tc', canc, { buffer = true })
vim.keymap.set('n', '<localleader>tw', wait, { buffer = true })
vim.keymap.set('n', '<localleader>tb', block, { buffer = true })
vim.keymap.set('i', '<C-t>t', '**<C-R>=strftime("%H:%M")<CR>** ', { buffer = true })
vim.keymap.set('i', '<C-t>d', '**<C-R>=strftime("%Y-%m-%d")<CR>** ', { buffer = true })

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

