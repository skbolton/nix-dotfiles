local source_icons = {
  codecompanion = "󰭆 ",
  nvim_lsp = '󱜠 ',
  lsp = '󱜠 ',
  buffer = ' ',
  luasnip = ' ',
  snippets = ' ',
  path = ' ',
  git = ' ',
  tags = ' ',
  cmdline = '󰘳 ',
  -- FALLBACK
  fallback = ' ',
}

return {
  {
    "blink.cmp",
    event = "User DeferredUIEnter",
    after = function()
      require 'blink.cmp'.setup {
        fuzzy = {
          prebuilt_binaries = { download = false },
          implementation = "rust"
        },
        completion = {
          ghost_text = {
            enabled = true,
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
          default = { 'lsp', 'path', 'snippets', 'buffer' },
          per_filetype = {
            sql = { 'dadbod' },
            plsql = { 'dadbod' },
            mysql = { 'dadbod' },
            codecompanion = { "codecompanion" },
          },
          providers = {
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            buffer = { opts = { get_bufnrs = vim.api.nvim_list_bufs } },
          }
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
  },
  {
    "codecompanion.nvim",
    after = function()
      local Job = require 'plenary.job'
      local credsfile = os.getenv("HOME") .. "/.config/sops-nix/secrets/zaia-creds"

      local get_ollama_creds = function()
        local first_line, second_line

        Job:new {
          command = "cat",
          args = { credsfile },
          on_stdout = function(_, line)
            if first_line == nil then
              first_line = line
            elseif second_line == nil and line ~= "" then
              second_line = line

              -- stop when we have both lines
              return false
            end

            return true
          end
        }:sync()

        return { first_line, second_line }
      end

      local creds = get_ollama_creds()

      require 'codecompanion'.setup {
        show_defaults = false,
        strategies = {
          chat = {
            adapter = "zionlab",
          },
          inline = {
            adapter = "zionlab",
          },
          cmd = {
            adapter = "zionlab",
          }
        },
        adapters = {
          http = {
            zionlab = function()
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                  url = "https://zaia.zionlab.online",
                },
                headers = {
                  ["Content-Type"] = "application/json",
                  ["CF-Access-Client-Secret"] = creds[1],
                  ["CF-Access-Client-Id"] = creds[2],
                },
                schema = {
                  model = {
                    default = "qwen3-coder:30b-a3b",
                    choices = { "qwen3-coder:30b-a3b", "devstral:24b" }
                  },
                  num_predict = {
                    default = -1,
                  }
                }
              })
            end,
          }
        }
      }
    end,
    cmd = { "CodeCompanionChat", "CodeCompanion" },
    keys = {
      { "<leader>a", "<CMD>CodeCompanionChat Toggle<CR>", mode = "n" },
      { "<leader>a", ":CodeCompanion ",                   mode = "v" }
    }
  }
}
