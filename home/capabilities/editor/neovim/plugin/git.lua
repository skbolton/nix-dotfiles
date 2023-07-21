local map = vim.keymap.set
local gitsigns = require 'gitsigns'

function next_hunk()
  -- Move to next hunk
  gitsigns.next_hunk()
  -- center cursor
  vim.cmd('normal zz')
end

function prev_hunk()
  -- Move to prev hunk
  gitsigns.prev_hunk()
  -- center cursor
  vim.cmd('normal zz')
end


gitsigns.setup {
  signs = {
    add          = {hl = 'GitGutterAdd'   , text = '│'},
    change       = {hl = 'GitGutterChange', text = '│'},
    delete       = {hl = 'GitGutterDelete', text = '│'},
    topdelete    = {hl = 'GitGutterDelete', text = '│'},
    changedelete = {hl = 'GitGutterDelete', text = '│'},
  },
  on_attach = function(bufnr)
    local map = vim.keymap.set
    local opts = {silent = true}

    map('n', ']g', next_hunk, opts)
    map('n', '[g', prev_hunk, opts)
    map('n', '<leader>g+', gitsigns.stage_hunk, opts)
    map('n', '<leader>g-', gitsigns.undo_stage_hunk, opts)
    map('n', '<leader>g=', gitsigns.reset_hunk, opts)
    map('n', '<leader>gp', gitsigns.preview_hunk, opts)
  end
}


-- Gets the default branch for the current repository
-- `git default-branch` is a git alias
local get_default_branch = function()
  return Job:new({
    command = 'git',
    args = { 'default-branch' }
  }):sync()[1]
end

-- Do a diff split against origin's default branch
-- Can be helpful when on a long lived feature branch to see the difference of a file
local diff_against_default_branch = function()
  return vim.api.nvim_command("Gvdiffsplit origin/" .. get_default_branch() .. ":%")
end

-- GRead from origin's default branch
-- Blow away all changes from the current branch
local read_default_branch = function()
  return vim.api.nvim_command("Gread origin/" .. get_default_branch() .. ":%")
end

map('n', '<leader>gg', '<CMD>G<CR>')
map('n', '<leader>go', '<CMD>Git difftool --name-only<CR>')
map('n', '<leader>gO', '<CMD>Git difftool<CR>')
map('n', '<leader>gd', '<CMD>Gdiff<CR>')
map('n', '<leader>gdd', diff_against_default_branch)
map('n', '<leader>gb', '<CMD>Git blame<CR>')
map('n', '<leader>gw', '<CMD>Gwrite<CR>')
map('n', '<leader>gr', '<CMD>Gread<CR>')
map('n', '<leader>grd', read_default_branch)
map('n', '<leader>gl', '<CMD>Gclog<CR>')
map('n', '<leader>gh', '<CMD>0Gclog<CR>')
map('n', '<leader>gm', '<CMD>GitMessenger<CR>')
map('n', '<leader>g<down>', '<CMD>Git pull<CR>')
map('n', '<leader>g<up>', '<CMD>Git push<CR>')

map('n', '<leader>g<left>', '<CMD>diffget<CR>')
map('n', '<leader>g<right>', '<CMD>diffget<CR>')
map('n', '<leader>g<down>', '<CMD>diffput<CR>')
map('v', '<leader>g<down>', '<CMD>diffput<CR><ESC>')

map('v', '<leader>gv', '<CMD>GBrowse<CR>')
map('v', '<leader>gV', '<CMD>GBrowse!<CR>')
map('v', '<leader>gh', '<CMD>diffget<CR>')
map('v', '<leader>gl', '<CMD>diffget<CR>')
map('v', '<leader>gj', '<CMD>diffput<CR>')

