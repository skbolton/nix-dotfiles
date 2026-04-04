return {
  {
    'vim-tmux-navigator',
    event = 'BufEnter',
    before = function()
      vim.g.tmux_navigator_disable_when_zoomed = true
    end
  }
}
