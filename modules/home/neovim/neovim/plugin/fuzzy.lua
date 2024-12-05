local telescope = require 'telescope'
local builtin = require 'telescope.builtin'
local wk = require 'which-key'

wk.add {
  { "<leader>/",           builtin.live_grep,                   desc = "Grep",           group = "+fuzzy" },
  { "<leader><leader>",    builtin.find_files,                  desc = "Files",          group = "+fuzzy" },
  { "<leader><Backspace>", builtin.buffers,                     desc = "Recent",         group = "+fuzzy" },
  { "<leader>fm",          builtin.man_pages,                   desc = "Manpages",       group = "+fuzzy" },
  { "<leader>f?",          builtin.help_tags,                   desc = "Help",           group = "+fuzzy" },
  { "<leader>f.",          builtin.resume,                      desc = "Resume last",    group = "+fuzzy" },
  { "<leader>fi",          "<CMD>Telescope symbols<CR>",        desc = "Symbols",        group = "+fuzzy" },
  { "<leader>fg",          builtin.git_status,                  desc = "Git changes",    group = "+fuzzy" },
  { "<leader>fb",          builtin.current_buffer_fuzzy_find,   desc = "Current buffer", group = "+fuzzy" },
  { "<leader>nn",          "<CMD>ZkNotes<CR>",                  desc = "Find note",      group = "+notes" },
  { "<leader>nN",          ":ZkNotes { tags = {}}<left><left>", desc = "Notes with tag", group = "+notes" },
  { "<leader>nt",          "<CMD>ZkTags<CR>",                   desc = "Tag search",     group = "+notes" },
  { "<leader>n.",          "<CMD>ZkBacklinks<CR>",              desc = "Backlinks",      group = "+notes" },
  { "<leader>n<up>",       "<CMD>ZkLinks<CR>",                  desc = "Outbound links", group = "+notes" },
}

telescope.setup {
  defaults = {
    layout_config = {
      prompt_position = 'top',
    },
    prompt_prefix = '  ',
    sorting_strategy = 'ascending',
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      prompt = { "─", "│", " ", "│", '┌', '┐', "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    }
  },
  pickers = {
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
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
    },
    heading = {
      treesitter = true,
    }
  }
}

telescope.load_extension('fzf')
telescope.load_extension('heading')
-- telescope.load_extension('bibtex')
