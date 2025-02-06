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
    after = function()
      local map = vim.keymap.set

      map('n', '<leader>tT', '<CMD>TestFile<CR>')
      map('n', '<leader>tt', '<CMD>TestFile -strategy=vimux_watch<CR>')
      map('n', '<leader>tN', '<CMD>TestNearest<CR>')
      map('n', '<leader>tn', '<CMD>TestNearest -strategy=vimux_watch<CR>')
      map('n', '<leader>t.', '<CMD>TestLast<CR>')
      map('n', '<leader>tv', '<CMD>TestVisit<CR>zz')
      map('n', '<leader>ts', '<CMD>TestSuite -strategy=vimux_watch<CR>')
      map('n', '<leader>tS', '<CMD>TestSuite<CR>')
    end
  }
}
