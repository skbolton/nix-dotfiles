local pickers = require 'telescope.pickers'
local sorters = require 'telescope.sorters'
local finders = require 'telescope.finders'

local map = vim.keymap.set

vim.g.tmux_navigator_disable_when_zoomed = true
vim.g.VimuxCloseOnExit = true;

vim.g.VimuxRunnerQuery = {
  window = "󱈫 ",
};

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

map({ 'n', 'v' }, '<C-c><C-c>', function()
  -- yank text into v register
  if vim.api.nvim_get_mode()["mode"] == "n" then
    vim.cmd('normal vip"vy')
  else
    vim.cmd('normal "vy')
  end
  -- construct command with v register as command to send
  -- vim.cmd(string.format('call VimuxRunCommand("%s")', vim.trim(vim.fn.getreg('v'))))
  vim.cmd("call VimuxRunCommand(@v)")
end)
map('n', '<leader>rr', '<CMD>VimuxPromptCommand<CR>')
map('n', '<leader>r.', '<CMD>VimuxRunLastCommand<CR>')
map('n', '<leader>rc', '<CMD>VimuxClearTerminalScreen<CR>')
map('n', '<leader>rq', '<CMD>VimuxCloseRunner<CR>')
map('n', '<leader>r?', '<CMD>VimuxInspectRunner<CR>')
map('n', '<leader>r!', '<CMD>VimuxInterruptRunner<CR>')
map('n', '<leader>rz', '<CMD>VimuxZoomRunner<CR>')
map('n', '<leader>rf', get_file_paths)

map('n', '<leader>ru', function()
  if vim.g.VimuxRunnerType == 'window' then
    vim.g.VimuxRunnerType = 'pane'
    vim.g.VimuxCloseOnExit = true;
  else
    vim.g.VimuxRunnerType = 'window'
    vim.g.VimuxCloseOnExit = false;
  end
end)
