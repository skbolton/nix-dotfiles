return {
  {
    "blink-cmp",
    event = "User DeferredUIEnter",
    after = function()
      require 'blink.cmp'.setup {
        fuzzy = {
          prebuilt_binaries = { download = false }
        },
        completion = {
          ghost_text = {
            enabled = false,
            show_without_selection = true,
          },
          documentation = {
            auto_show = true
          },
          menu = {
            auto_show = true,
          },
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer', 'dadbod' },
          providers = { dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" } }
        },
        snippets = { preset = 'luasnip' },
        appearance = {
          kind_icons = {
            Text = "",
            Method = "󰆧",
            Function = "λ",
            Constructor = ' ',
            Field = "󰇽",
            Variable = "󰂡",
            Class = '󰫅 ',
            Interface = "",
            Module = '󰫈 ',
            Property = "󰜢",
            Unit = "",
            Value = "󰎠",
            Enum = ' ',
            Keyword = "󰌋",
            Snippet = "",
            Color = ' ',
            File = "󰈙",
            Reference = "",
            Folder = ' ',
            EnumMember = ' ',
            Constant = "󰏿",
            Struct = "",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰅲"
          }
        }
      }
    end
  }
}
