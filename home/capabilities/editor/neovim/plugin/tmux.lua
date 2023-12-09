vim.g.tmux_navigator_disable_when_zoomed = true

local send_to_tmux = function()
  -- yank text into v register
  vim.cmd('normal vip"vy')
  -- construct command with v register as command to send
  vim.cmd(string.format('call VimuxRunCommand("%s")', vim.trim(vim.fn.getreg('v'))))
end

vim.keymap.set('n', '<C-c><C-c>', send_to_tmux)


