local map = vim.keymap.set
local oil = require 'oil'
local nnn = require 'nnn'

oil.setup {
  default_file_explorer = true,
  columns = {
    "icon",
    "permissions",
  },
  keymaps = {
    -- stub out defaults that clash
    ["<C-s>"] = false,
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-x>"] = "actions.select_split",
    ["<C-v>"] = "actions.select_vsplit",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name)
      return name == ".." or name == ".git"
    end
  }
}

nnn.setup {
  offset = true,
  explorer = {
    width = 24
  },
  picker = {
    border = "rounded"
  },
  mappings = {
    { "<C-t>", nnn.builtin.open_in_tab },    -- open file(s) in tab
    { "<C-x>", nnn.builtin.open_in_split },  -- open file(s) in split
    { "<C-v>", nnn.builtin.open_in_vsplit }, -- open file(s) in vertical split
  }
}

map('n', '<leader>_', ':silent grep ', { silent = false })
map('n', '<leader>e', '<CMD>Oil<CR>')
map('n', '<leader>E', '<CMD>NnnPicker %:p<CR>')
