local g = vim.g

g.VimuxOrientation = "h"
g.VimuxHeight = "30"

g["test#custom_strategies"] = {
  vimux_watch = function(args)
    vim.cmd("call VimuxClearTerminalScreen()")
    vim.cmd("call VimuxClearRunnerHistory()")
    vim.cmd(string.format("call VimuxRunCommand('fd . | entr -c %s')", args))
  end
}

g["test#preserve_screen"] = false
g['test#javascript#jest#options'] = '--reporters jest-vim-reporter'
g['test#strategy'] = {
  nearest = 'vimux',
  file = 'vimux',
  suite = 'vimux'
}
g['test#neovim#term_position'] = 'vert'

g.dispatch_compilers = { elixir = 'exunit' }

local M = {}
M.TESTING_STATUS = 'init'

return M
