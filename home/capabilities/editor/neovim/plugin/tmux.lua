local map = vim.keymap.set

vim.g.tmux_navigator_disable_when_zoomed = true

map({'n', 'v'}, '<C-c><C-c>', function() 
  -- yank text into v register
  if vim.api.nvim_get_mode()["mode"] == "n" then
    vim.cmd('normal vip"vy')
  else
    vim.cmd('normal "vy')
  end
  -- construct command with v register as command to send
  -- vim.cmd(string.format('call VimuxRunCommand("%s")', vim.trim(vim.fn.getreg('v'))))
  vim.cmd("call VimuxRunCommand(@v)")
end)
map('n', '<leader>rr', '<CMD>VimuxPromptCommand<CR>')
map('n', '<leader>r.', '<CMD>VimuxRunLastCommand<CR>')
map('n', '<leader>rc', '<CMD>VimuxClearTerminalScreen<CR>')
map('n', '<leader>rq', '<CMD>VimuxCloseRunner<CR>')
map('n', '<leader>r?', '<CMD>VimuxInspectRunner<CR>')
map('n', '<leader>r!', '<CMD>VimuxInterruptRunner<CR>')
map('n', '<leader>rz', '<CMD>VimuxZoomRunner<CR>')


