local telescope = require 'telescope'
local builtin = require 'telescope.builtin'
local actions = require 'telescope.actions'
local wk = require 'which-key'

local map = vim.keymap.set

wk.register({
  ["/"] = { builtin.live_grep, "fuzzy grep", },
  ["<leader>"] = { builtin.find_files, "find files" },
  ["<Backspace>"] = { builtin.buffers, "recent" },
  f = {
    name = "+fuzzy",
    f = { builtin.find_files, "files" },
    m = { builtin.man_pages, "manual" },
    ["?"] = { builtin.help_tags, "help" },
    ["."] = { builtin.resume, "resume last" },
    i = { "<CMD>Telescope symbols<CR>", "symbols"}
  },
  n = {
    name = "+notes",
    n = { "<CMD>ZkNotes<CR>", "find note" },
    N = { ":ZkNotes { tags = {}}<left><left>", "note with tag" },
    t = { "<CMD>ZkTags<CR>", "tag search" },
    ["."] = { "<CMD>ZkBacklinks<CR>", "backlinks" },
    ["<up>"] = { "<CMD>ZkLinks<CR>", "outword links" },
  },
  g = {
    name = "+git",
    f = { builtin.git_status, "fuzzy files" },
  }
}, { prefix = "<leader>" })

telescope.setup{
  defaults = {
    layout_config = {
      prompt_position = 'top',
    },
    prompt_prefix = '  ',
    sorting_strategy = 'ascending',
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
      prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
      results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
    }
  },
  pickers = {
    find_files = {
      find_command = {'rg', '--files', '--hidden', '-g', '!.git'},
      layout_config = {
        height = 0.70
      }
    },
    buffers = {
      show_all_buffers = true
    },
    git_status = {
      git_icons = {
        added = "+",
        changed = "~",
        copied = "",
        deleted = "-",
        renamed = ">",
        unmerged = "^",
        untracked = "?",
      },
      theme = "ivy"
    }
},
extensions = {
  bibtex = {
    global_files = { os.getenv("HOME") .. "/Documents/Notes/Resources/global.bib" }
  }
}
}

telescope.load_extension('fzf')
-- telescope.load_extension('bibtex')
