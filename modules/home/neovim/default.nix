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

        require('lz.n').load("plugins")
      '';
      plugins = with pkgs.unstable.vimPlugins; [
        inputs.lz-n.packages.${pkgs.system}.default
        popup-nvim
        plenary-nvim
        { plugin = nvim-web-devicons; optional = true; }
        vim-tpipeline
        {
          plugin = nvim-web-devicons;
          optional = true;
          config = /* lua */''
            require("mini.icons").setup {}
          '';
          type = "lua";
        }
        { plugin = mini-icons; optional = false; }
        { plugin = bullets-vim; optional = true; }
        { plugin = venn-nvim; optional = true; }
        { plugin = oil-nvim; optional = true; }

        # editing support
        { plugin = pkgs.awesomeNeovimPlugins.mdeval-nvim; optional = true; }
        { plugin = dial-nvim; optional = true; }
        { plugin = hlchunk-nvim; optional = true; }
        { plugin = vim-tmux-navigator; optional = false; }
        { plugin = nvim-lint; optional = true; }
        { plugin = nvim-autopairs; optional = true; }
        { plugin = firenvim; optional = true; }
        { plugin = vim-surround; optional = true; }
        { plugin = comment-nvim; optional = true; }
        { plugin = vim-repeat; optional = true; }
        { plugin = flash-nvim; optional = true; }
        { plugin = nvim-colorizer-lua; optional = true; }
        { plugin = markdown-preview-nvim; optional = true; }
        { plugin = zk-nvim; optional = true; }
        neorg
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "spelunk-nvim";
            src = inputs.spelunk-nvim;
            doCheck = false;
          };
          optional = true;
        }
        galaxyline-nvim

        { plugin = aerial-nvim; optional = true; }
        { plugin = inputs.blink-cmp.packages.${pkgs.system}.default; optional = true; }
        { plugin = codecompanion-nvim; optional = true; }
        { plugin = render-markdown-nvim; optional = true; }
        { plugin = luasnip; optional = true; }

        { plugin = gitsigns-nvim; optional = true; }
        { plugin = diffview-nvim; optional = true; }
        { plugin = vim-fugitive; optional = true; }
        { plugin = git-messenger-vim; optional = true; }
        { plugin = vim-rhubarb; optional = true; }

        # database
        { plugin = vim-dadbod; optional = true; }
        { plugin = vim-dadbod-ui; optional = true; }
        { plugin = vim-dadbod-completion; optional = true; }

        # testing
        { plugin = vim-test; optional = true; }
        { plugin = vim-dispatch; optional = true; }
        { plugin = vimux; optional = true; }

        { plugin = pkgs.awesomeNeovimPlugins.treewalker-nvim; optional = true; }
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: nvim-treesitter.allGrammars ++ [
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
        { plugin = nvim-treesitter-textobjects; optional = true; }
        { plugin = nvim-treesitter-endwise; optional = true; }
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
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "embark-vim";
            src = inputs.embark-vim;
          };
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
