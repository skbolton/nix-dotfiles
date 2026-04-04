local gossip = require 'gossip'

gossip.contact {
  name = "ai",
  create = {
    split = { dir = "h", size = "120", command = "opencode" },
  },
  match_command = "opencode",
  breakup_on_exit = false
}

vim.api.nvim_create_user_command('SendPrompt', function(opts)
  local buffer = vim.fn.bufname()
  local selection = gossip.selection()
  local lines = ''

  if #selection then
    lines = string.format('L%s-%s', opts.line1, opts.line2)
  else
    lines = string.format('L%s', opts.line1)
  end

  gossip.send("ai", {
    buffer,
    'Space',
    lines,
    'Enter',
    'Enter',
    vim.fn.shellescape(opts.args),
    'C-y'
  })
end, { nargs = "+", range = true })

vim.keymap.set({ 'n', 'v' }, '<leader>ag', '!aichat -r grammar<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>ar', '!aichat -r dev ')
vim.keymap.set({ 'n', 'v' }, '<leader>aa', ':SendPrompt ')
vim.keymap.set({ 'n', 'v' }, '<leader>ae', ':SendPrompt explain this<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>ai', ':SendPrompt improve this<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>ad', ':SendPrompt add documentation to this<CR>')
