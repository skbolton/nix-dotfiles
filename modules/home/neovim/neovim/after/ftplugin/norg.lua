local pickers = require 'telescope.pickers'
local sorters = require 'telescope.sorters'
local finders = require 'telescope.finders'

local function get_todos(file, state)
  local state_char
  if state == 'open' then
    state_char = ' '
  elseif state == 'done' then
    state_char = 'x'
  end
  local picker = pickers.new {
    finder = finders.new_oneshot_job(
      { "rg", "--vimgrep", "\\(" .. state_char .. "\\) ", file }
    ),
    sorter = sorters.get_generic_fuzzy_sorter()
  }

  picker:find()
end

vim.keymap.set('n', '<localleader>ft', function() get_todos(vim.fn.expand('%'), 'open') end, { buffer = true })
vim.keymap.set('n', '<localleader>ftu', function() get_todos(vim.fn.expand('%'), 'open') end, { buffer = true })
vim.keymap.set('n', '<localleader>ftd', function() get_todos(vim.fn.expand('%'), 'done') end, { buffer = true })

local clock_in = function(header)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  if header then
    vim.fn.append(line, {
      "@code ledger",
      "i " .. os.date("%Y/%m/%d") .. " " .. os.date("%H:%M:%S"),
      "@end"
    })
  else
    vim.fn.append(line, {
      "i " .. os.date("%Y/%m/%d") .. " " .. os.date("%H:%M:%S"),
    })
  end
end

local clock_out = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(line, {
    "o " .. os.date("%Y/%m/%d") .. " " .. os.date("%H:%M:%S"),
  })
end

vim.keymap.set('n', '<localleader>ci', clock_in, { buffer = true, desc = "clock in" })
vim.keymap.set('n', '<localleader>cI', function() clock_in(true) end, { buffer = true, desc = "clock in" })
vim.keymap.set('n', '<localleader>co', clock_out, { buffer = true, desc = "clock out" })
