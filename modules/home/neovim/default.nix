{ lib, config, pkgs, inputs, ... }:

with lib;
let
  cfg = config.delta.neovim;
in
{
  options.delta.neovim = with types; {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.nodejs_20 pkgs.nodePackages.poor-mans-t-sql-formatter-cli ];
    programs.neovim = {
      # package = pkgs.neovim-nightly;
      enable = true;
      defaultEditor = true;
      extraPython3Packages = pyPkgs: with pyPkgs; [ beancount ];
      extraLuaConfig = /* lua */ ''
        require 'options'
        require 'plugins'
      '';
      plugins = with pkgs.vimPlugins; [
        inputs.lz-n.packages.${pkgs.system}.default
        # syntax
        vim-elixir
        {
          plugin = bullets-vim;
          config = /* lua */ ''
            require 'lz.n'.load {
              "bullets.vim",
              before = function()
                vim.g.bullets_outline_levels = { 'num', 'abc', 'std*' }
              end,
              ft = "markdown"
            }
          '';
          type = "lua";
          optional = true;
        }
        {
          plugin = venn-nvim;
          config = /* lua */ ''
            require 'lz.n'.load {
              'venn.nvim',
              ft = "markdown"
            }
          '';
          type = "lua";
          optional = true;
        }
        {
          plugin = oil-nvim;
          config = /* lua */ ''
            require 'lz.n'.load {
              "oil.nvim",
              after = function()
                require 'oil'.setup {
                  default_file_explorer = true,
                  columns = {
                    "icon",
                    "permissions",
                  },
                  keymaps = {
                    -- stub out defaults that clash
                    ["<C-s>"] = false,
                    ["<C-h>"] = false,
                    ["<C-l>"] = false,
                    ["<C-x>"] = "actions.select_split",
                    ["<C-v>"] = "actions.select_vsplit",
                  },
                  delete_to_trash = true,
                  skip_confirm_for_simple_edits = true,
                  view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name)
                      return name == ".." or name == ".git"
                    end
                  }
                }
              end,
              keys = {
                {"<leader>e", '<CMD>Oil<CR>', "Open oil"}
              }
            }
          '';
          type = "lua";
          optional = true;
        }

        # editing support
        {
          plugin = (pkgs.vimUtils.buildVimPlugin {
            name = "mdeval-nvim";
            version = "2654caf";
            src = pkgs.fetchFromGitHub {
              owner = "jubnzv";
              repo = "mdeval.nvim";
              rev = "2654caf";
              sha256 = "sha256-z+xowZ2ulJB5YcAW0OKAwcEed2iMdHYTwBkzKp5MHmQ=";
            };
          });
          optional = true;
        }
        {
          plugin = (pkgs.vimUtils.buildVimPlugin {
            name = "edit-code-block.nvim";
            version = "5e4e310";
            src = pkgs.fetchFromGitHub {
              owner = "dawsers";
              repo = "edit-code-block.nvim";
              rev = "main";
              sha256 = "sha256-rB37XE0cvOCmFjSEVSHFl95KVJ+ScMFnGWYfYQiK5CQ=";
            };
          });
          optional = true;
        }
        {
          plugin = (pkgs.vimUtils.buildVimPlugin {
            name = "quicker.nvim";
            version = "11f9eb0c803bb9ced8c6043805de89c62bd04515";
            src = pkgs.fetchFromGitHub {
              owner = "stevearc";
              repo = "quicker.nvim";
              rev = "11f9eb0c803bb9ced8c6043805de89c62bd04515";
              sha256 = "sha256-sTjDmfQacpvhGdKPyoMxqmoOSw5ceXi6Td48gYaDotE=";
            };
          });
        }
        {
          plugin = (pkgs.vimUtils.buildVimPlugin {
            name = "tide.nvim";
            version = "de64acfadcedec03f526ba79d95523cea6630b2d";
            src = pkgs.fetchFromGitHub {
              owner = "skbolton";
              repo = "tide.nvim";
              rev = "de64acfadcedec03f526ba79d95523cea6630b2d";
              sha256 = "sha256-W6zaaSPiEn6aIv28q91saQMDTK4VeGIZr/BHlXCfr/I=";
            };
          });
          config = /* lua */ ''
            require 'lz.n'.load {
              "vimplugin-tide.nvim",
              after = function()
                require 'tide'.setup {
                  keys = {
                    leader = '<leader>m',
                  },
                  hints = {
                    dictionary = 'rstdneio'
                  }
                }
              end,
              keys = { "<leader>m" }
            }
          '';
          type = "lua";
          optional = true;
        }
        lsp_lines-nvim
        dial-nvim
        neorg

        nui-nvim

        {
          plugin = indent-blankline-nvim;
          config = /* lua */ ''
            require 'lz.n'.load {
              "indent-blankline.nvim",
              event = "BufReadPre",
              after = function()
                require 'ibl'.setup {
                  indent = {
                    char = "┊"
                  },
                  scope = {
                    char = "│",
                    -- highlight = "@type"
                  }
                }
              end
            }
          '';
          type = "lua";
          optional = true;
        }
        {
          plugin = vim-tmux-navigator;
          config = /* lua */ ''
            require 'lz.n'.load {
              "vim-tmux-navigator",
              event = "UIEnter"
            }
          '';
          type = "lua";
          optional = true;
        }
        {
          plugin = nvim-lint;
          config = /* lua */ ''
            require 'lz.n'.load {
              "nvim-lint",
              event = "BufWritePost",
              after = function()
                local linter = require('lint')

                linter.linters_by_ft = {
                  elixir = { 'credo' }
                }

                local lint_group = vim.api.nvim_create_augroup(
                  'MyLinter',
                  {}
                )

                vim.api.nvim_create_autocmd(
                  { 'BufWritePost', 'BufEnter' },
                  {
                    pattern = {'*.ex', '*.exs' },
                    callback = function() linter.try_lint() end,
                    group = lint_group
                  }
                )
            end
            }
          '';
          type = "lua";
          optional = true;
        }
        auto-pairs
        {
          plugin = firenvim;
          config = /* lua */ ''
            require 'lz.n'.load {
              "firenvim",
              enabled = function() 
                return vim.g.started_by_firenvim
              end,
              before = function()
                -- turn off some visual clutter
                vim.opt.showtabline = 0
                vim.opt.laststatus = 0
                vim.opt.number = false
                vim.opt.relativenumber = false

                vim.opt.guifont = "Operator Mono Book:h22"
                vim.g.firenvim_config = {
                  localSettings = {
                    ['discord.com*'] = {
                      takeover = 'never',
                      priority = 1
                    },
                    ['www.notion.so.*'] = {
                      takeover = 'never',
                      priority = 1
                    },
                    ['regexr.com'] = {
                      takeover = 'never',
                      priority = 1
                    },
                    ['linkedin.*'] = {
                      takeover = 'never',
                      priority = 1
                    },
                    ['docs.google.com'] = {
                      takeover = 'never',
                      priority = 1
                    },
                    ['outlook.office.com'] = {
                      takeover = 'never',
                      priority = 1
                    },
                    [".*"] = {
                      takeover = 'nonempty'
                    }
                  }
                }
              end
            }
          '';
          type = "lua";
          optional = true;
        }
        vim-surround
        {
          plugin = comment-nvim;
          config = /* lua */ ''
            require 'lz.n'.load {
              'comment.nvim',
              after = function() require 'Comment'.setup() end,
              event = "UIEnter",
            }
          '';
          type = "lua";
          optional = true;
        }
        vim-repeat
        {
          plugin = flash-nvim;
          config = /* lua */ ''
            require 'lz.n'.load {
              "flash.nvim",
              after = function()
                require 'flash'.setup {}
              end,
              keys = {
                { "s", function() require("flash").jump() end, desc = "Flash", mode = { "n", "x", "o" }},
                { "S", function() require("flash").treesitter({ jump = { pos = "start" }}) end, desc = "Flash treesitter", mode = { "n", "x", "o" }}
              },
            }
          '';
          type = "lua";
          optional = true;

        }
        {
          plugin = nvim-colorizer-lua;
          config = /* lua */ ''
            require 'lz.n'.load {
              "nvim-colorizer.lua",
              event = "BufReadPre",
              after = function()
                require 'colorizer'.setup({
                  user_default_options = {
                    mode = 'virtualtext',
                    names = false
                  }
                })
              end
            }
          '';
          type = "lua";
          optional = true;
        }
        { plugin = markdown-preview-nvim; optional = true; }
        zk-nvim
        which-key-nvim
        {
          plugin = vim-wakatime;
          config = /* lua */ ''
            require 'lz.n'.load {
              "vim-wakatime",
              event = "InsertEnter"
            };
          '';
          type = "lua";
          optional = true;
        }

        galaxyline-nvim

        nvim-cmp
        cmp-nvim-lsp
        { plugin = vista-vim; optional = true; }
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp-nvim-lua
        cmp-beancount
        luasnip

        # nnn-vim
        {
          plugin = pkgs.vimUtils.buildVimPlugin
            {
              name = "nnn-nvim";
              version = "2023-12-24";
              src = pkgs.fetchFromGitHub {
                owner = "luukvbaal";
                repo = "nnn.nvim";
                rev = "662034c73718885ee599ad9fb193ab1ede70fbcb";
                sha256 = "sha256-8+ax8n1fA4jgJugvWtRXkad4YM7TmAAsAopzalmGu/4=";
              };
            };
          config = /* lua */ ''
            require 'lz.n'.load {
              "vimplugin-nnn-nvim",
              after = function()
                local nnn = require 'nnn'

                nnn.setup {
                  offset = true,
                  explorer = {
                    width = 24
                  },
                  picker = {
                    border = "rounded"
                  },
                  mappings = {
                    { "<C-t>", nnn.builtin.open_in_tab },    -- open file(s) in tab
                    { "<C-x>", nnn.builtin.open_in_split },  -- open file(s) in split
                    { "<C-v>", nnn.builtin.open_in_vsplit }, -- open file(s) in vertical split
                  }
                }
              end,
              keys = {
                {"<leader>E", "<CMD>NnnPicker %:p<CR>", desc = "NNN"}
              }
            }
          '';
          type = "lua";
          optional = true;
        }

        gitsigns-nvim
        {
          plugin = diffview-nvim;
          config = /* lua */ ''
            require 'lz.n'.load {
              "diffview.nvim",
              cmd = "DiffviewOpen";
            }
          '';
          type = "lua";
          optional = true;
        }
        vim-fugitive
        {
          plugin = git-messenger-vim;
          config = /* lua */ ''
            require 'lz.n'.load {
              "git-messenger.vim",
              keys = {
                { "<leader>gm", "<CMD>GitMessenger<CR>", desc = "Commit under cursor"},
              },
            }
          '';
          type = "lua";
          optional = true;
        }
        vim-rhubarb

        # database
        vim-dadbod
        vim-dadbod-ui
        vim-dadbod-completion

        # testing
        {
          plugin = vim-test;
          config = /* lua */ ''
            local lz = require 'lz.n'
            lz.load {
              "vim-test",
              before = function()
                lz.trigger_load("vim-dispatch")

                local g = vim.g

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
          '';
          type = "lua";
          optional = true;
        }
        { plugin = vim-dispatch; optional = true; }
        {
          plugin = vimux;
          config = /* lua */ ''
            require 'lz.n'.load {
              "vimux",
              event = "User DeferredUIEnter",
              before = function()
                vim.g.VimuxOrientation = "h"
                vim.g.VimuxHeight = "120"
                vim.g.VimuxCloseOnExit = true;

                vim.g.VimuxRunnerQuery = {
                  window = "󱈫 ",
                };
              end,
              after = function()
                local function send_to_tmux()
                  -- yank text into v register
                  if vim.api.nvim_get_mode()["mode"] == "n" then
                    vim.cmd('normal vip"vy')
                  else
                    vim.cmd('normal "vy')
                  end
                  -- construct command with v register as command to send
                  vim.cmd("call VimuxRunCommand(@v)")
                end

                vim.keymap.set('n', '<leader>ru', function()
                  if vim.g.VimuxRunnerType == 'window' then
                    vim.g.VimuxRunnerType = 'pane'
                    vim.g.VimuxCloseOnExit = true;
                  else
                    vim.g.VimuxRunnerType = 'window'
                    vim.g.VimuxCloseOnExit = false;
                  end
                end)
                vim.keymap.set('n', '<leader>rr', '<CMD>VimuxPromptCommand<CR>')
                vim.keymap.set('n', '<leader>r.', '<CMD>VimuxRunLastCommand<CR>')
                vim.keymap.set('n', '<leader>rc', '<CMD>VimuxClearTerminalScreen<CR>')
                vim.keymap.set('n', '<leader>rq', '<CMD>VimuxCloseRunner<CR>')
                vim.keymap.set('n', '<leader>r?', '<CMD>VimuxInspectRunner<CR>')
                vim.keymap.set('n', '<leader>r!', '<CMD>VimuxInterruptRunner<CR>')
                vim.keymap.set('n', '<leader>rz', '<CMD>VimuxZoomRunner<CR>')

                vim.keymap.set({ 'n', 'v' }, '<C-c><C-c>', send_to_tmux)
                vim.keymap.set({ 'n', 'v' }, '<C-c><M-c>', function()
                  vim.cmd('call VimuxRunCommand("clear")')
                  send_to_tmux()
                end)
              end
            }
          '';
          type = "lua";
          optional = true;
        }

        nvim-web-devicons
        popup-nvim
        plenary-nvim
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
        nvim-treesitter-endwise
        {
          plugin = playground;
          config = /* lua */ ''
            require 'lz.n'.load {
              "playground",
              cmd = "TSPlaygroundToggle"
            }
          '';
          type = "lua";
          optional = true;
        }

        {
          plugin = telescope-nvim;
          config = /* lua */ ''
            require 'lz.n'.load {
              'telescope.nvim',
              after = function()
                local lz = require 'lz.n'
                lz.trigger_load('telescope-fzf-native.nvim')

                local pickers = require 'telescope.pickers'
                local sorters = require 'telescope.sorters'
                local finders = require 'telescope.finders'

                local map = vim.keymap.set

                local function get_file_paths()
                  local picker = pickers.new {
                  finder = finders.new_oneshot_job(
                    { "tmux-file-paths" },
                    {
                      entry_maker = function(entry)
                        local _, _, filename, lnum = string.find(entry, "(.+):(%d+)")

                        return {
                          value = entry,
                          ordinal = entry,
                          display = entry,
                          filename = filename,
                          lnum = tonumber(lnum),
                          col = 0
                        }
                      end
                    }),
                    sorter = sorters.get_generic_fuzzy_sorter(),
                    previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new {}
                  }

                  picker:find()
                end

                map('n', '<leader>rf', get_file_paths)

                require 'telescope'.setup {
                  defaults = {
                    layout_config = {
                      prompt_position = 'top',
                    },
                    prompt_prefix = '  ',
                    sorting_strategy = 'ascending',
                    borderchars = {
                      { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                      prompt = { "─", "│", " ", "│", '┌', '┐', "│", "│" },
                      results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    }
                  },
                  pickers = {
                    find_files = {
                      find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
                      layout_config = {
                  height = 0.70
                      }
                    },
                    buffers = {
                      show_all_buffers = true
                    },
                    git_status = {
                      git_icons = {
                  added = "+",
                  changed = "~",
                  copied = "",
                  deleted = "-",
                  renamed = ">",
                  unmerged = "^",
                  untracked = "?",
                      },
                      theme = "ivy"
                    }
                  },
                  extensions = {
                    bibtex = {
                      global_files = { os.getenv("HOME") .. "/Documents/Notes/Resources/global.bib" }
                    },
                    heading = {
                      treesitter = true,
                    }
                  }
                }
              end,
              keys = {
                { "<leader>/",           "<CMD>Telescope live_grep<CR>",                   desc = "Grep"          },
                { "<leader><leader>",    "<CMD>Telescope find_files<CR>",                  desc = "Files"         },
                { "<leader><Backspace>", "<CMD>Telescope buffers<CR>",                     desc = "Recent"        },
                { "<leader>fm",          "<CMD>Telescope man_pages<CR>",                   desc = "Manpages"      },
                { "<leader>f?",          "<CMD>Telescope help_tags<CR>",                   desc = "Help"          },
                { "<leader>f.",          "<CMD>Telescope resume<CR>",                      desc = "Resume last"   },
                { "<leader>fg",          "<CMD>Telescope git_status<CR>",                  desc = "Git changes"   },
                { "<leader>fb",          "<CMD>Telescope current_buffer_fuzzy_find<CR>",   desc = "Current buffer"},
              }
            }
          '';
          type = "lua";
          optional = true;
        }
        {
          plugin = telescope-symbols-nvim;
          config = /* lua */ ''
            require 'lz.n'.load {
              "telescope-symbols.nvim",
              keys = {
                { "<leader>fi", "<CMD>Telescope symbols<CR>", desc = "Symbols" },
              }
            }
          '';
          type = "lua";
          optional = true;
        }
        {
          plugin = telescope-fzf-native-nvim;
          config = /* lua */ ''
            require 'lz.n'.load {
              "telescope-fzf-native.nvim",
              after = function()
                require 'telescope'.load_extension('fzf')
              end,
              lazy = true
            }
          '';
          type = "lua";
          optional = true;
        }
        {
          plugin = pkgs.vimUtils.buildVimPlugin
            {
              name = "telescope-headings";
              version = "e85c0f6";
              src = pkgs.fetchFromGitHub {
                owner = "crispgm";
                repo = "telescope-heading.nvim";
                rev = "e85c0f6";
                sha256 = "sha256-29nSqK4sWI3m5hHviGBfiSN/GPh8oXGiYrrTmN2okRk=";
              };
            };
          config = /* lua */ ''
            require 'lz.n'.load {
              'vimplugin-telescope-headings',
              after = function()
                require 'telescope'.load_extension('heading')
              end,
              keys = {
                { "<leader>fo", "<CMD>Telescope heading<CR>", desc = "Fuzzy headings"}
              }
            }
          '';
          type = "lua";
          optional = true;
        }
      ];
    };

    xdg.configFile.nvim = {
      source = ./neovim;
      recursive = true;
    };
  };
}
