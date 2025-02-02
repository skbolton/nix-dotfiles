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
            name = "tide.nvim";
            version = "de64acfadcedec03f526ba79d95523cea6630b2d";
            src = pkgs.fetchFromGitHub {
              owner = "skbolton";
              repo = "tide.nvim";
              rev = "de64acfadcedec03f526ba79d95523cea6630b2d";
              sha256 = "sha256-W6zaaSPiEn6aIv28q91saQMDTK4VeGIZr/BHlXCfr/I=";
            };
          });
          optional = true;
        }
        lsp_lines-nvim
        dial-nvim

        nui-nvim

        {
          plugin = (pkgs.vimUtils.buildVimPlugin {
            name = "hlchunk.nvim";
            version = "5465dd33ade8676d63f6e8493252283060cd72ca";
            src = pkgs.fetchFromGitHub {
              owner = "shellRaining";
              repo = "hlchunk.nvim";
              rev = "5465dd33ade8676d63f6e8493252283060cd72ca";
              sha256 = "sha256-f5VVfpfVZk6ULBWVSVEzXBN9F4ROTzhomV1F2mKIem4=";
            };
          });
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
