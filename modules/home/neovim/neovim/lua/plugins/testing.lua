return {
  {
    "vim-test",
    before = function()
      local lz = require 'lz.n'
      local gossip = require 'gossip'
      lz.trigger_load("vim-dispatch")

      gossip.contact {
        name = "tests",
        create = {
          split = { dir = "h", size = "120" }
        },
        breakup_on_exit = true
      }

      local g = vim.g

      g["test#custom_strategies"] = {
        gossip_watch = function(args)
          gossip.interrupt("tests")
          gossip.send("tests", { string.format('fd . | entr -c %s', args), 'Enter' })
        end,
        gossip = function(args)
          gossip.send("tests", { "clear", "Enter", args, 'Enter' })
        end

      }

      g["test#preserve_screen"] = false
      g['test#javascript#jest#options'] = '--reporters jest-vim-reporter'
      g['test#strategy'] = {
        nearest = 'gossip',
        file = 'gossip',
        suite = 'gossip'
      }
      g['test#neovim#term_position'] = 'vert'

      g.dispatch_compilers = { elixir = 'exunit' }
    end,
    keys = {
      { '<leader>tT', '<CMD>TestFile<CR>' },
      { '<leader>tt', '<CMD>TestFile -strategy=gossip_watch<CR>' },
      { '<leader>tN', '<CMD>TestNearest<CR>' },
      { '<leader>tn', '<CMD>TestNearest -strategy=gossip_watch<CR>' },
      { '<leader>t.', '<CMD>TestLast<CR>' },
      { '<leader>tv', '<CMD>TestVisit<CR>zz' },
      { '<leader>ts', '<CMD>TestSuite -strategy=gossip_watch<CR>' },
      { '<leader>tS', '<CMD>TestSuite<CR>' }
    }
  }
}
