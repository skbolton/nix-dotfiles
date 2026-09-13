{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.notes;
in
{
  options.delta.notes = {
    enable = lib.mkEnableOption "Notes";
    notebook_dir = lib.mkOption {
      type = lib.types.str;
      description = "Primary nootbook root";
      default = "$HOME/Notes";
      example = "$HOME/Notes";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      JOURNALS = "$HOME/Documents/Logbook/Journal";
      ZK_NOTEBOOK_DIR = cfg.notebook_dir;
    };

    home.packages = with pkgs; [
      zk
      delta.qke
      delta.dsearch
      delta.weekp
      delta.dweek
      delta.dyear
      delta.dmonth
      delta.cosma
      unstable.vimPlugins.diagram-nvim
      unstable.vimPlugins.image-nvim
      mermaid-cli
    ];

    programs.neovim.extraLuaPackages = luaPkgs: with luaPkgs; [ neorg-interim-ls ];

    programs.neovim.plugins = with pkgs; [
      {
        plugin = vimPlugins.image-nvim;
        type = "lua";
        optional = true;
        config = /* lua */ ''
          require 'lz.n'.load {
            "image.nvim",
            filetypes = {"neorg", "markdown"},
            after = function()
              require 'image'.setup {}
            end
          }
        '';
      }
      {
        plugin = vimPlugins.diagram-nvim;
        type = "lua";
        optional = true;
        config = /* lua */ ''
          require 'lz.n'.load {
            "diagram.nvim",
            filetypes = {"neorg", "markdown"},
            after = function()
              require 'diagram'.setup {
                events = {
                  render_buffer = {'InsertLeave', 'BufEnter', 'BufWinEnter', 'FocusGained', 'TextChanged' },
                  clear_buffer = { 'FocusLost' }
                }
              }
            end
          }
        '';
      }
      {
        plugin = vimPlugins.zk-nvim;
        type = "lua";
        optional = true;
        config = /* lua */ ''
          require 'lz.n'.load {
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
            },
          }
        '';
      }
      {
        plugin = vimPlugins.neorg;
        type = "lua";
        config = /* lua */ ''
          require 'lz.n'.load {
            "neorg",
            lazy = false,
            after = function()
              require("neorg").setup {
                load = {
                  ["core.defaults"] = {},
                  ["core.completion"] = {
                    config = { engine = { module_name = "external.lsp-completion" } },
                  },
                  ["core.concealer"] = {
                    config = {
                      icons = {
                        code_block = { conceal = true },
                        heading = {
                          icons = {
                            "",
                            "",
                            "",
                            "",
                            "",
                            "",
                          }
                        }
                      }
                    }
                  },
                  ["core.dirman"] = {
                    config = {
                      workspaces = {
                        journal = "~/Documents/Notes/journal"
                      },
                      default_workspace = "journal"
                    }
                  },
                  ["core.qol.todo_items"] = {},
                  ["core.tangle"] = {
                    config = {
                      tangle_on_write = true,
                      report_on_empty = false
                    }
                  },
                  ["core.summary"] = {},
                  ["core.looking-glass"] = {},
                  ["external.interim-ls"] = {
                    config = {
                      -- default config shown
                      completion_provider = {
                        -- Enable or disable the completion provider
                        enable = true,
                        -- Show file contents as documentation when you complete a file name
                        documentation = true,
                        -- Try to complete categories provided by Neorg Query. Requires `benlubas/neorg-query`
                        categories = false,
                      }
                    }
                  }
                }
              }
            end
          }
        '';
      }
    ];

    xdg.configFile."zk/config.toml".source = ./zk.toml;
  };

}
