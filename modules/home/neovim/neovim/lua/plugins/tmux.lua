local function send_to_tmux()
  -- yank text into v register
  if vim.api.nvim_get_mode()["mode"] == "n" then
    vim.cmd('normal vip"vy')
  else
    vim.cmd('normal "vy')
  end
  -- construct command with v register as command to send
  vim.cmd("call VimuxRunCommand(@v)")
end

local function toggle_output()
  if vim.g.VimuxRunnerType == 'window' then
    vim.g.VimuxRunnerType = 'pane'
    vim.g.VimuxCloseOnExit = true;
  else
    vim.g.VimuxRunnerType = 'window'
    vim.g.VimuxCloseOnExit = false;
  end
end

return {
  {
    'vim-tmux-navigator',
    event = 'BufEnter',
    before = function()
      vim.g.tmux_navigator_disable_when_zoomed = true
    end
  },
  {
    "vimux",
    before = function()
      vim.g.VimuxOrientation = "h"
      vim.g.VimuxHeight = "120"
      vim.g.VimuxCloseOnExit = true;

      vim.g.VimuxRunnerQuery = {
        window = "󱈬 ",
      };
    end,
    cmd = {
      'VimuxPromptCommand',
      'VimuxRunLastCommand',
      'VimuxClearTerminalScreen',
      'VimuxCloseRunner',
      'VimuxInspectRunner',
      'VimuxInterruptRunner',
      'VimuxZoomRunner'
    },
    keys = {
      { '<leader>rr', '<CMD>VimuxPromptCommand<CR>' },
      { '<leader>r.', '<CMD>VimuxRunLastCommand<CR>' },
      { '<leader>rc', '<CMD>VimuxClearTerminalScreen<CR>' },
      { '<leader>rq', '<CMD>VimuxCloseRunner<CR>' },
      { '<leader>r?', '<CMD>VimuxInspectRunner<CR>' },
      { '<leader>r!', '<CMD>VimuxInterruptRunner<CR>' },
      { '<leader>rz', '<CMD>VimuxZoomRunner<CR>' },
      { '<leader>ru', toggle_output },
      { '<C-c><C-c>', send_to_tmux,                       mode = { 'n', 'v' } }
    }
  }
}
