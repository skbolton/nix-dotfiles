local pickers = require 'telescope.pickers'
local sorters = require 'telescope.sorters'
local finders = require 'telescope.finders'

local map = vim.keymap.set

vim.g.tmux_navigator_disable_when_zoomed = true

local function get_file_paths()
  local picker = pickers.new {
    finder = finders.new_oneshot_job(
      { "tmux-file-paths" },
      {
        entry_maker = function(entry)
          local _, _, filename, lnum = string.find(entry, "(.+):(%d+)")

          return {
            value = entry,
            ordinal = entry,
            display = entry,
            filename = filename,
            lnum = tonumber(lnum),
            col = 0
          }
        end
      }
    ),
    sorter = sorters.get_generic_fuzzy_sorter(),
    previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new {}
  }

  picker:find()
end

map('n', '<leader>rf', get_file_paths)
