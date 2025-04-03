return {
  {
    'zk-nvim',
    before = function()
      require 'lz.n'.trigger_load("telescope.nvim")
    end,
    after = function()
      local zk = require('zk')
      local util = require('zk.util')
      local commands = require('zk.commands')

      zk.setup {
        picker = "telescope",
        lsp = {
          auto_attach = {
            enabled = true
          }
        }
      }

      commands.add("ZkFromSelection", function(options)
        vim.ui.input({ prompt = "Title: " }, function(input)
          local location = util.get_lsp_location_from_selection()
          local selected_text = util.get_text_in_range(location.range)
          assert(selected_text ~= nil, "No selected text")

          options = options or {}
          options.content = selected_text

          if options.inline == true then
            options.inline = nil
            options.dryRun = true
            options.insertContentAtLocation = location
          else
            options.insertLinkAtLocation = location
          end

          zk.new(vim.tbl_extend("force", { title = input }, options))
        end)
      end, { needs_selection = true })

      commands.add("ZkProjects", function(options)
        options = options or {}
        local tags = options.tags or {}
        tags[#tags + 1] = "PROJECT"
        tags[#tags + 1] = "open"
        options = vim.tbl_extend("force", { tags = tags }, options)
        zk.edit(options, { title = "Open Projects" })
      end)

      commands.add("ZkSpells", function(options)
        options = vim.tbl_extend("force", { tags = { "SPELL" } }, options or {})
        zk.edit(options, { title = "Spellbook" })
      end)

      vim.keymap.set('v', '<leader>ne', ':ZkFromSelection<CR>')
      vim.keymap.set('n', '<leader>ne', function()
        vim.ui.input({ prompt = "Title: " }, function(input)
          vim.cmd("ZkNew { title = '" .. input .. "'}")
        end)
      end)
    end,
    cmd = { "ZkNotes", "ZkTags" },
    keys = {
      { "<leader>nn",    "<CMD>ZkNotes<CR>",                  desc = "Find note" },
      { "<leader>nN",    ":ZkNotes { tags = {}}<left><left>", desc = "Notes with tag" },
      { "<leader>nt",    "<CMD>ZkTags<CR>",                   desc = "Tag search" },
      { "<leader>n.",    "<CMD>ZkBacklinks<CR>",              desc = "Backlinks" },
      { "<leader>n<up>", "<CMD>ZkLinks<CR>",                  desc = "Outbound links" },
    },
    ft = "markdown"
  }
}
