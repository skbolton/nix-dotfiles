{ lib, pkgs, ... }:

let
  embark-vim = pkgs.vimUtils.buildVimPlugin {
    name = "embark-vim";
    version = "2012-12-05";
    src = pkgs.fetchFromGitHub {
      owner = "embark-theme";
      repo = "vim";
      rev = "main";
      sha256 = "sha256-jnmrFlNLSXF/SPmyf1RVkL0C8IFbNwGNxvymSKXp2F4=";
    };
  };
in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      # syntax
      vim-elixir
      vim-lfe
      salt-vim
      bullets-vim
      venn-nvim

      # editing support
      noice-nvim
      nui-nvim
      nvim-notify
      indent-blankline-nvim
      nvim-nonicons
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

      galaxyline-nvim

      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lua
      luasnip

      nnn-vim

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

      { plugin = embark-vim; }
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
