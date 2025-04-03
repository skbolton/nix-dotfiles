local clock_in = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(line, {
    "i " .. os.date("%Y/%m/%d") .. " " .. os.date("%H:%M:%S")
  })
end

local clock_out = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(line, {
    "o " .. os.date("%Y/%m/%d") .. " " .. os.date("%H:%M:%S")
  })
end

vim.keymap.set('n', '<localleader>ci', clock_in, { buffer = true, desc = "clock in" })
vim.keymap.set('n', '<localleader>co', clock_out, { buffer = true, desc = "clock out" })
