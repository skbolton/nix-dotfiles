local source_icons = {
  nvim_lsp = '',
  lsp = '',
  buffer = '',
  luasnip = '',
  snippets = '',
  path = '',
  git = '',
  tags = '',
  cmdline = '󰘳',
  -- FALLBACK
  fallback = '󰜚',
}

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
            draw = {
              columns = {
                { 'kind_icon',  gap = 2 },
                { 'label',      'label_description', gap = 1 },
                { 'source_icon' },
              },
              components = {
                source_icon = {
                  ellipsis = false,
                  text = function(ctx)
                    return source_icons[ctx.source_name:lower()] or source_icons.fallback
                  end,
                  highlight = 'BlinkCmpSource',
                },
              },
            }
          },
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer', 'dadbod' },
          providers = { dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" } }
        },
        snippets = { preset = 'luasnip' },
        appearance = {
          use_nvim_cmp_as_default = true,
          kind_icons = {
            Text = "",
            Method = "󰆧",
            Function = "●",
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
