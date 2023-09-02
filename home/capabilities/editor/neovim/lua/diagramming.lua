local _M = { enabled = false };

local toggle_venn = function()
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if not _M.enabled then
    _M.enabled = true
    vim.cmd[[setlocal ve=all]]
    -- draw a line on <C-{HJKL}> keystokes
    vim.api.nvim_buf_set_keymap(0, "n", "<C-J>", "<C-v>j:VBox<CR>", {noremap = true})
    vim.api.nvim_buf_set_keymap(0, "n", "<C-K>", "<C-v>k:VBox<CR>", {noremap = true})
    vim.api.nvim_buf_set_keymap(0, "n", "<C-L>", "<C-v>l:VBox<CR>", {noremap = true})
    vim.api.nvim_buf_set_keymap(0, "n", "<C-H>", "<C-v>h:VBox<CR>", {noremap = true})
    -- draw a box by pressing "f" with visual selection
    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})

    vim.keymap.set('v', '<leader>V', function() vim.api.nvim_feedkeys("lohjok", 't', false) end)
  else
    _M.enabled = false
    vim.cmd[[setlocal ve=]]
    vim.cmd[[mapclear <buffer>]]
  end
end

vim.keymap.set('n', '<leader>v', toggle_venn)

return _M
