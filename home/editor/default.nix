{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      # syntax
      vim-elixir
      vim-lfe
      salt-vim

      # editing support
      vim-tmux-navigator
      neoscroll-nvim
      nvim-lint
      auto-pairs
      firenvim
      vim-surround
      vim-slime
      vim-commentary
      vim-repeat
      vim-endwise
      vim-speeddating
      leap-nvim
      nvim-colorizer-lua
      markdown-preview-nvim

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
      playground

      telescope-nvim
      telescope-symbols-nvim
      telescope-fzf-native-nvim

      embark-vim
    ];
  };

 xdg.configFile.nvim = {
   source = ./neovim;
   recursive = true;
 };

 xdg.dataFile."fonts/VictorMonoNerdFont".source = ./VictorMono_Nerd_Font_Regular.ttf;
}
