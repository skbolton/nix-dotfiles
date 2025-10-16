return {
  {
    "gitsigns.nvim",
    event = "User DeferredUIEnter",
    after = function()
      local gitsigns = require 'gitsigns'

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
          vim.keymap.set({ 'n' }, "]g", next_hunk, { desc = "Next hunk", buffer = bufnr })
          vim.keymap.set({ 'n' }, "[g", prev_hunk, { desc = "Prev hunk", buffer = bufnr })
          vim.keymap.set({ 'n' }, "<leader>g+", gitsigns.stage_hunk, { desc = "Stage hunk", buffer = bufnr })
          vim.keymap.set({ 'n' }, "<leader>g-", gitsigns.stage_hunk, { desc = "Unstage hunk", buffer = bufnr })
          vim.keymap.set({ 'n' }, "<leader>g=", gitsigns.reset_hunk, { desc = "Reset hunk", buffer = bufnr })
          vim.keymap.set({ 'n' }, "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk", buffer = bufnr })
        end
      }
    end
  },
  {
    "vim-fugitive",
    event = "User DeferredUIEnter",
    before = function()
      require 'lz.n'.trigger_load('vim-rhubarb')
    end,
    after = function()
      local Job = require 'plenary.job'

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

      vim.keymap.set({ 'n' }, "<leader>gg", "<CMD>G<CR>", { desc = "Status" })
      vim.keymap.set({ 'n' }, "<leader>go", "<CMD>Git difftool --name-only<CR>", { desc = "qf changed file names" })
      vim.keymap.set({ 'n' }, "<leader>gO", "<CMD>Git difftool<CR>", { desc = "qf all changes" })
      vim.keymap.set({ 'n' }, "<leader>gd", "<CMD>Gdiff<CR>", { desc = "Diff file" })
      vim.keymap.set({ 'n' }, "<leader>gD", diff_against_default_branch, { desc = "Diff file" })
      vim.keymap.set({ 'n' }, "<leader>gE", view_default_branch, { desc = "View file against default" })
      vim.keymap.set({ 'n' }, "<leader>gR", read_default_branch, { desc = "Reset against default branch" })
      vim.keymap.set({ 'n' }, "<leader>gb", "<CMD>Git blame<CR>", { desc = "Blame" })
      vim.keymap.set({ 'n' }, "<leader>gw", "<CMD>Gwrite<CR>", { desc = "Write" })
      vim.keymap.set({ 'n' }, "<leader>gr", "<CMD>Gread<CR>", { desc = "Read" })
      vim.keymap.set({ 'n' }, "<leader>gl", "<CMD>Gclog<CR>", { desc = "Log" })
      vim.keymap.set({ 'n' }, "<leader>gh", "<CMD>0Gclog<CR>", { desc = "File history" })
      vim.keymap.set({ 'n', 'v' }, "<leader>gv", ":GBrowse!<CR>", { desc = "Webview copy" })
      vim.keymap.set({ 'n' }, "<leader>g<up>", "<CMD>Git push<CR>", { desc = "push" })
      vim.keymap.set({ 'n', 'v' }, "<leader>g<left>", ":diffget<CR>", { desc = "Diff get" })
      vim.keymap.set({ 'n', 'v' }, "<leader>g<right>", ":diffget<CR>", { desc = "Diff get" })
      vim.keymap.set({ 'n', 'v' }, "<leader>g<down>", ":diffput<CR>", { desc = "diff put" })
    end,
  },
  {
    "vim-rhubarb",
    lazy = true
  },
  {
    "git-messenger.vim",
    keys = {
      { "<leader>gm", "<CMD>GitMessenger<CR>", desc = "Commit under cursor" },
    },
  },
  {
    "diffview.nvim",
    cmd = "DiffviewOpen",
  }
}
