local gitsigns = require 'gitsigns'
local Job = require 'plenary.job'
local wk = require 'which-key'

local next_hunk = function()
  -- Move to next hunk
  gitsigns.next_hunk()
  -- center cursor
  vim.cmd('normal zz')
end

local prev_hunk = function()
  -- Move to prev hunk
  gitsigns.prev_hunk()
  -- center cursor
  vim.cmd('normal zz')
end

gitsigns.setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '│' },
    topdelete    = { text = '│' },
    changedelete = { text = '│' },
  },
  on_attach = function(bufnr)
    wk.register({
      ["]g"] = { next_hunk, "Next hunk" },
      ["[g"] = { prev_hunk, "Prev hunk" },
      ["<leader>"] = {
        g = {
          name = "+git",
          ["+"] = { gitsigns.stage_hunk, "Stage hunk" },
          ["-"] = { gitsigns.undo_stage_hunk, "Unstage hunk" },
          ["="] = { gitsigns.reset_hunk, "Reset hunk" },
          ["p"] = { gitsigns.preview_hunk, "Preview hunk" },
        }
      }
    }, { buffer = bufnr })
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

local view_default_branch = function()
  return vim.api.nvim_command("Gvsplit origin/" .. get_default_branch() .. ":%")
end

wk.register({
  g = {
    name = "+git",
    g = { "<CMD>G<CR>", "status" },
    o = { "<CMD>Git difftool --name-only<CR>", "qf changed file names" },
    O = { "<CMD>Git difftool<CR>", "qf all changes" },
    d = { "<CMD>Gdiff<CR>", "diff file" },
    D = { diff_against_default_branch, "diff default branch" },
    E = { view_default_branch, "diff default branch" },
    b = { "<CMD>Git blame<CR>", "blame" },
    w = { "<CMD>Gwrite<CR>", "write" },
    r = { "<CMD>Gread<CR>", "read" },
    R = { read_default_branch, "reset to default" },
    l = { "<CMD>Gclog<CR>", "log" },
    h = { "<CMD>0Gclog<CR>", "file history" },
    m = { "<CMD>GitMessenger<CR>", "commit under cursor" },
    ["<up>"] = { "<CMD>Git push<CR>", "push" },
    ["<left>"] = { "<CMD>diffget<CR>", "diff get" },
    ["<right>"] = { "<CMD>diffget<CR>", "diff get" },
    ["<down>"] = { "<CMD>diffput<CR>", "diff put" },
  }
}, { prefix = "<leader>" })

wk.register({
  g = {
    name = "+git",
    ["<down>"] = { "<CMD>diffput<CR><ESC>", "diff put" },
    v = { '<CMD>GBrowse<CR>', "webview" },
    V = { '<CMD>GBrowse!<CR>', "webview copy" },
    ["<left>"] = { '<CMD>diffget<CR>', "diff get" },
    ["<right>"] = { '<CMD>diffget<CR>', "diff get" },
    ["<down>"] = { '<CMD>diffput<CR>', "diff get" }
  }
}, { prefix = "<leader>", mode = "v" })
