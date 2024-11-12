{ lib, config, pkgs, ... }:

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
      plugins = with pkgs.vimPlugins; [
        # syntax
        vim-elixir
        vim-lfe
        salt-vim
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
        vim-test
        vim-dispatch
        neomake
        vimux

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

        { plugin = rose-pine; optional = true; }
        { plugin = nightfox-nvim; optional = true; }
      ];
    };

    xdg.configFile.nvim = {
      source = ./neovim;
      recursive = true;
    };
  };
}
