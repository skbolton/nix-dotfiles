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
        bullets-vim
        venn-nvim
        oil-nvim

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
        }
        lsp_lines-nvim
        dial-nvim
        copilot-lua
        copilot-cmp
        neorg

        nui-nvim
        indent-blankline-nvim
        vim-tmux-navigator
        nvim-lint
        auto-pairs
        firenvim
        vim-surround
        comment-nvim
        vim-repeat
        flash-nvim
        nvim-colorizer-lua
        { plugin = markdown-preview-nvim; optional = true; }
        zk-nvim
        which-key-nvim
        vim-wakatime

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
        (pkgs.vimUtils.buildVimPlugin {
          name = "nnn-nvim";
          version = "2023-12-24";
          src = pkgs.fetchFromGitHub {
            owner = "luukvbaal";
            repo = "nnn.nvim";
            rev = "662034c73718885ee599ad9fb193ab1ede70fbcb";
            sha256 = "sha256-8+ax8n1fA4jgJugvWtRXkad4YM7TmAAsAopzalmGu/4=";
          };
        })

        gitsigns-nvim
        diffview-nvim
        vim-fugitive
        git-messenger-vim
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
        playground

        telescope-nvim
        telescope-symbols-nvim
        telescope-fzf-native-nvim
        (pkgs.vimUtils.buildVimPlugin {
          name = "telescope-headings";
          version = "e85c0f6";
          src = pkgs.fetchFromGitHub {
            owner = "crispgm";
            repo = "telescope-heading.nvim";
            rev = "e85c0f6";
            sha256 = "sha256-29nSqK4sWI3m5hHviGBfiSN/GPh8oXGiYrrTmN2okRk=";
          };
        })
      ];
    };

    xdg.configFile.nvim = {
      source = ./neovim;
      recursive = true;
    };
  };
}
