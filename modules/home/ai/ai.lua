vim.api.nvim_create_user_command('SendPrompt', function(opts)
  local buffer = vim.fn.bufname()
  local lines = ''
  if (opts.line2 == opts.line1) then
    lines = string.format('L%s', opts.line1)
  elseif (opts.line2 > opts.line1) then
    lines = string.format('L%s-%s', opts.line1, opts.line2)
  else
    lines = ''
  end
  vim.system({ 'tmux', 'send-keys', '-t', '{right-of}',
    buffer, 'Space', lines,
    'Enter',
    'Enter',
    vim.fn.shellescape(opts.args), 'C-y' })
end, { nargs = "+", range = true })

vim.keymap.set({ 'n', 'v' }, '<leader>ag', '!aichat -r grammar<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>ar', '!aichat -r dev ')
vim.keymap.set({ 'n', 'v' }, '<leader>aa', ':SendPrompt ')
vim.keymap.set({ 'n', 'v' }, '<leader>ae', ':SendPrompt explain this<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>ai', ':SendPrompt improve this<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>ad', ':SendPrompt add documentation to this<CR>')
