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
    wk.add {
      { "]g",         next_hunk,             desc = "Next hunk",    group = "+git", buffer = bufnr },
      { "[g",         prev_hunk,             desc = "Prev hunk",    group = "+git", buffer = bufnr },
      { "<leader>g+", gitsigns.stage_hunk,   desc = "Stage hunk",   group = "+git", buffer = bufnr },
      { "<leader>g-", gitsigns.stage_hunk,   desc = "Unstage hunk", group = "+git", buffer = bufnr },
      { "<leader>g=", gitsigns.reset_hunk,   desc = "Reset hunk",   group = "+git", buffer = bufnr },
      { "<leader>gp", gitsigns.preview_hunk, desc = "Preview hunk", group = "+git", buffer = bufnr }
    }
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

wk.add {
  { "<leader>gg",       "<CMD>G<CR>",                        desc = "Status",                       group = "+git" },
  { "<leader>go",       "<CMD>Git difftool --name-only<CR>", desc = "qf changed file names",        group = "+git" },
  { "<leader>gO",       "<CMD>Git difftool<CR>",             desc = "qf all changes",               group = "+git" },
  { "<leader>gd",       "<CMD>Gdiff<CR>",                    desc = "Diff file",                    group = "+git" },
  { "<leader>gD",       diff_against_default_branch,         desc = "Diff file",                    group = "+git" },
  { "<leader>gE",       view_default_branch,                 desc = "View file against default",    group = "+git" },
  { "<leader>gR",       read_default_branch,                 desc = "Reset against default branch", group = "+git" },
  { "<leader>gb",       "<CMD>Git blame<CR>",                desc = "Blame",                        group = "+git" },
  { "<leader>gw",       "<CMD>Gwrite<CR>",                   desc = "Write",                        group = "+git" },
  { "<leader>gr",       "<CMD>Gread<CR>",                    desc = "Read",                         group = "+git" },
  { "<leader>gl",       "<CMD>Gclog<CR>",                    desc = "Log",                          group = "+git" },
  { "<leader>gh",       "<CMD>0Gclog<CR>",                   desc = "File history",                 group = "+git" },
  { "<leader>gm",       "<CMD>GitMessenger<CR>",             desc = "Commit under cursor",          group = "+git" },
  { "<leader>g<up>",    "<CMD>Git push<CR>",                 desc = "push",                         group = "+git" },
  { "<leader>g<left>",  "<CMD>diffget<CR>",                  desc = "Diff get",                     group = "+git" },
  { "<leader>g<right>", "<CMD>diffget<CR>",                  desc = "Diff get",                     group = "+git" },
  { "<leader>g<down>",  "<CMD>diffput<CR>",                  desc = "diff put",                     group = "+git" }
}

wk.add {
  { "<leader>g<down>",  "<CMD>diffput<CR><ESC>",  desc = "Diff put",     group = "+git", mode = "v" },
  { "<leader>gv",       "<CMD>GBrowse<CR><ESC>",  desc = "Webview",      group = "+git", mode = "v" },
  { "<leader>gV",       "<CMD>GBrowse!<CR><ESC>", desc = "Webview copy", group = "+git", mode = "v" },
  { "<leader>g<left>",  "<CMD>diffget<CR><ESC>",  desc = "Diff get",     group = "+git", mode = "v" },
  { "<leader>g<right>", "<CMD>diffget<CR><ESC>",  desc = "Diff get",     group = "+git", mode = "v" },
}
