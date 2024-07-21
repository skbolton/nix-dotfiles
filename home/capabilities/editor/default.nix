{ pkgs, ... }:

{
  home.packages = [ pkgs.nodejs_20 ];
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
          version = " 2654caf";
          src = pkgs.fetchFromGitHub {
            owner = "jubnzv";
            repo = "mdeval.nvim";
            rev = "master";
            sha256 = "sha256-KYWs1/bywPni/MOogs/f+NfnaOakvHdNFh6v4Eyna40=";
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
      copilot-lua
      copilot-cmp

      nui-nvim
      indent-blankline-nvim
      vim-tmux-navigator
      neoscroll-nvim
      nvim-lint
      auto-pairs
      firenvim
      vim-surround
      comment-nvim
      vim-repeat
      vim-speeddating
      leap-nvim
      nvim-colorizer-lua
      { plugin = markdown-preview-nvim; optional = true; }
      zk-nvim
      todo-comments-nvim
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

      { plugin = rose-pine; optional = true; }
      { plugin = nightfox-nvim; optional = true; }
    ];
  };

  xdg.configFile.nvim = {
    source = ./neovim;
    recursive = true;
  };

  xdg.dataFile."fonts/VictorMonoNerdFont".source = ./VictorMono_Nerd_Font_Regular.ttf;
}
