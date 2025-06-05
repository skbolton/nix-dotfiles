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
    home.packages = [ pkgs.nodejs_20 pkgs.nodePackages.poor-mans-t-sql-formatter-cli pkgs.emmet-language-server ];
    programs.neovim = {
      # package = pkgs.neovim-nightly;
      enable = true;
      defaultEditor = true;
      extraPython3Packages = pyPkgs: with pyPkgs; [ beancount ];
      extraLuaConfig = /* lua */ ''
        require 'options'
        vim.cmd [[packadd cfilter]]

        require('lz.n').load("plugins")
      '';
      plugins = with pkgs.vimPlugins; [
        inputs.lz-n.packages.${pkgs.system}.default
        # syntax
        vim-elixir
        {
          plugin = bullets-vim;
          optional = true;
        }
        {
          plugin = venn-nvim;
          optional = true;
        }
        {
          plugin = oil-nvim;
          optional = true;
        }

        # editing support
        {
          plugin = pkgs.awesomeNeovimPlugins.mdeval-nvim;
          optional = true;
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
            doCheck = false;
          });
          optional = true;
        }
        lsp_lines-nvim
        dial-nvim

        nui-nvim

        {
          plugin = pkgs.awesomeNeovimPlugins.hlchunk-nvim;
          optional = true;
        }
        {
          plugin = vim-tmux-navigator;
          optional = false;
        }
        {
          plugin = nvim-lint;
          optional = true;
        }
        auto-pairs
        {
          plugin = firenvim;
          optional = true;
        }
        vim-surround
        {
          plugin = comment-nvim;
          optional = true;
        }
        vim-repeat
        {
          plugin = flash-nvim;
          optional = true;

        }
        {
          plugin = nvim-colorizer-lua;
          optional = true;
        }
        { plugin = markdown-preview-nvim; optional = true; }
        {
          plugin = zk-nvim;
          optional = true;
        }
        which-key-nvim
        {
          plugin = vim-wakatime;
          optional = true;
        }

        galaxyline-nvim

        { plugin = aerial-nvim; optional = true; }
        {
          plugin = inputs.blink-cmp.packages.${pkgs.system}.default;
          optional = true;
        }
        {
        {
          plugin = render-markdown-nvim;
          optional = true;
        }
        luasnip

        {
          plugin = pkgs.awesomeNeovimPlugins.nnn-nvim;
          optional = true;
        }

        {
          plugin = gitsigns-nvim;
          optional = true;
        }
        {
          plugin = diffview-nvim;
          optional = true;
        }
        { plugin = vim-fugitive; optional = true; }
        {
          plugin = git-messenger-vim;
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
          optional = true;
        }
        { plugin = vim-dispatch; optional = true; }
        {
          plugin = vimux;
          optional = true;
        }

        {
          plugin = pkgs.awesomeNeovimPlugins.treewalker-nvim;
          optional = true;
        }
        nvim-web-devicons
        popup-nvim
        plenary-nvim
        (nvim-treesitter.withPlugins (p: nvim-treesitter.allGrammars ++ [
          (p.markdown.overrideAttrs {
            env.EXTENSION_WIKI_LINK = "1";
            env.EXTENSION_TAGS = "1";
            nativeBuildInputs = [ pkgs.nodejs pkgs.tree-sitter ];
            configurePhase = ''
              cd tree-sitter-markdown
              tree-sitter generate
            '';
          })
          (p.markdown_inline.overrideAttrs {
            env.EXTENSION_WIKI_LINK = "1";
            env.EXTENSION_TAGS = "1";
            nativeBuildInputs = [ pkgs.nodejs pkgs.tree-sitter ];
            configurePhase = ''
              cd tree-sitter-markdown-inline
              tree-sitter generate
            '';
          })
        ]))
        nvim-treesitter-textobjects
        nvim-treesitter-endwise
        {
          plugin = playground;
          optional = true;
        }

        {
          plugin = telescope-nvim;
          optional = true;
        }
        {
          plugin = telescope-symbols-nvim;
          optional = true;
        }
        {
          plugin = telescope-fzf-native-nvim;
          optional = true;
        }
        {
          plugin = pkgs.awesomeNeovimPlugins.telescope-heading-nvim;
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
