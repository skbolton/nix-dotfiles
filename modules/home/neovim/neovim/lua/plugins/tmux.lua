return {
  {
    "vimux",
    event = "User DeferredUIEnter",
    before = function()
      vim.g.VimuxOrientation = "h"
      vim.g.VimuxHeight = "120"
      vim.g.VimuxCloseOnExit = true;

      vim.g.VimuxRunnerQuery = {
        window = "󱈫 ",
      };
    end,
    after = function()
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

      vim.keymap.set('n', '<leader>ru', function()
        if vim.g.VimuxRunnerType == 'window' then
          vim.g.VimuxRunnerType = 'pane'
          vim.g.VimuxCloseOnExit = true;
        else
          vim.g.VimuxRunnerType = 'window'
          vim.g.VimuxCloseOnExit = false;
        end
      end)
      vim.keymap.set('n', '<leader>rr', '<CMD>VimuxPromptCommand<CR>')
      vim.keymap.set('n', '<leader>r.', '<CMD>VimuxRunLastCommand<CR>')
      vim.keymap.set('n', '<leader>rc', '<CMD>VimuxClearTerminalScreen<CR>')
      vim.keymap.set('n', '<leader>rq', '<CMD>VimuxCloseRunner<CR>')
      vim.keymap.set('n', '<leader>r?', '<CMD>VimuxInspectRunner<CR>')
      vim.keymap.set('n', '<leader>r!', '<CMD>VimuxInterruptRunner<CR>')
      vim.keymap.set('n', '<leader>rz', '<CMD>VimuxZoomRunner<CR>')

      vim.keymap.set({ 'n', 'v' }, '<C-c><C-c>', send_to_tmux)
      vim.keymap.set({ 'n', 'v' }, '<C-c><M-c>', function()
        vim.cmd('call VimuxRunCommand("clear")')
        send_to_tmux()
      end)
    end
  }
}
