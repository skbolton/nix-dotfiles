return {
  {
    'telescope.nvim',
    after = function()
      local lz = require 'lz.n'
      lz.trigger_load('telescope-fzf-native.nvim')

      local pickers = require 'telescope.pickers'
      local sorters = require 'telescope.sorters'
      local finders = require 'telescope.finders'

      local map = vim.keymap.set

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
            }),
          sorter = sorters.get_generic_fuzzy_sorter(),
          previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new {}
        }

        picker:find()
      end

      map('n', '<leader>rf', get_file_paths)

      require 'telescope'.setup {
        defaults = {
          layout_config = {
            prompt_position = 'top',
          },
          prompt_prefix = '  ',
          selection_caret = "󰧚 ",
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
          current_buffer_fuzzy_find = {
            skip_empty_lines = true,
            prompt_prefix = " ",
            results_title = "",
            prompt_title = "",
            preview_title = "",
            border = false,
            theme = 'ivy',
            layout_config = {
              prompt_position = 'bottom',
              height = 100
            }
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
    end,
    keys = {
      { "<leader>lo",          "<CMD>Telescope treesitter<CR>",                desc = "Fuzzy symbols" },
      { "/",                   "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy search file" },
      { "<leader>/",           "<CMD>Telescope live_grep<CR>",                 desc = "Grep" },
      { "<leader><leader>",    "<CMD>Telescope find_files<CR>",                desc = "Files" },
      { "<leader><Backspace>", "<CMD>Telescope buffers<CR>",                   desc = "Recent" },
      { "<leader>f?",          "<CMD>Telescope help_tags<CR>",                 desc = "Help" },
      { "<leader>f.",          "<CMD>Telescope resume<CR>",                    desc = "Resume last" },
      { "<leader>fg",          "<CMD>Telescope git_status<CR>",                desc = "Git changes" },
      { "<leader>fb",          "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Current buffer" },
    }
  },
  {
    "telescope-fzf-native.nvim",
    after = function()
      require 'telescope'.load_extension('fzf')
    end,
    lazy = true
  },
  {
    'telescope-heading-nvim',
    after = function()
      require 'telescope'.load_extension('heading')
    end,
    keys = {
      { "<leader>fo", "<CMD>Telescope heading<CR>", desc = "Fuzzy headings" }
    }
  },
  {
    "telescope-symbols.nvim",
    keys = {
      { "<leader>fi", "<CMD>Telescope symbols<CR>", desc = "Symbols" },
    }
  }
}
