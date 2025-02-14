return {
  {
    "vim-test",
    before = function()
      local lz = require 'lz.n'
      lz.trigger_load("vim-dispatch")

      local g = vim.g

      g["test#custom_strategies"] = {
        vimux_watch = function(args)
          vim.cmd("call VimuxInterruptRunner()")
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
    end,
    keys = {
      { '<leader>tT', '<CMD>TestFile<CR>' },
      { '<leader>tt', '<CMD>TestFile -strategy=vimux_watch<CR>' },
      { '<leader>tN', '<CMD>TestNearest<CR>' },
      { '<leader>tn', '<CMD>TestNearest -strategy=vimux_watch<CR>' },
      { '<leader>t.', '<CMD>TestLast<CR>' },
      { '<leader>tv', '<CMD>TestVisit<CR>zz' },
      { '<leader>ts', '<CMD>TestSuite -strategy=vimux_watch<CR>' },
      { '<leader>tS', '<CMD>TestSuite<CR>' }
    }
  }
}
