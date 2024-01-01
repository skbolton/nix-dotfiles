
local blocal = vim.opt_local
vim.cmd("packadd markdown-preview.nvim")
vim.cmd("packadd vimplugin-mdeval-nvim")
vim.cmd("packadd vimplugin-edit-code-block.nvim")

require 'mdeval'.setup {
  results_label = "**RESULTS**",
  require_confirmation = false,
  eval_options = {}
}

require 'ecb'.setup {
  wincmd = "vsplit"
}

local run_code_block = function()
  if vim.api.nvim_get_mode()["mode"] == "n" then
    vim.cmd('normal vib"vy')
  else
    vim.cmd('normal "vy')
  end
  vim.cmd("call VimuxRunCommand(@v)")
end

local clock_in = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(line, {
    string.format("```ledger tangle:%s/%s.timeclock", os.getenv("$TIMECARDS"), os.date("%Y-%m-%d")),
    "i " .. os.date("%Y/%m/%d") .. " " .. os.date("%H:%M:%S"),
    "```"
  })
end

local clock_out = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(line, {
    "o " .. os.date("%Y/%m/%d") .. " " .. os.date("%H:%M:%S"),
  })
end

vim.keymap.set('n', '<localleader>r', '<CMD>MarkdownPreview<CR>', { buffer = true })
vim.keymap.set('n', '<localleader>t', '<CMD>! md-tangle -f %<CR>', { buffer = true })
vim.keymap.set('n', '<C-c><C-c>', run_code_block, { buffer = true })
vim.keymap.set('n', '<C-c><C-x>', '<CMD>MdEval<CR>', { buffer = true })
vim.keymap.set('n', '<C-c><C-e>', '<CMD>EditCodeBlock<CR>', { buffer = true })
vim.keymap.set('n', '<localleader>ci', clock_in, { buffer = true })
vim.keymap.set('n', '<localleader>co', clock_out, { buffer = true })

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

vim.keymap.set('n', '<C-SPACE>', toggle_todo, { buffer = true })
vim.keymap.set('i', '<C-t>t', '**<C-R>=strftime("%H:%M")<CR>** ', { buffer = true })
vim.keymap.set('i', '<C-t>d', '**<C-R>=strftime("%Y-%m-%d")<CR>** ', { buffer = true })

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

