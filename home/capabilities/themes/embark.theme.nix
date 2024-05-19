{ inputs, pkgs, ... }:

{
  programs.neovim.plugins = [{ plugin = pkgs.vimUtils.buildVimPlugin { name = "embark-vim"; src = inputs.embark-vim; }; }];

  xdg.configFile."nvim/plugin/embark.lua".text = ''
    vim.o.background = 'dark'
    vim.g.embark_terminal_italics = true;
    vim.cmd("colorscheme embark")
  '';

  xdg.configFile."nvim/plugin/statusline.lua".source = ./galaxy-line-embark.lua;

  xdg.configFile."tmux/statusline.tmux".source = ./embark.tmux;

  xdg.configFile."kitty/themes/theme.conf".source = ../kitty/themes/embark.conf;

  programs.yazi.theme = {
    manager = {
      hovered = { bg = "#3E3859"; };
      tab_active = { bg = "#A1EFD3"; fg = "#100E23"; };
      tab_inactive = { bg = "#585273"; fg = "#CBE3E7"; };
    };

    status = {
      separator_open = "";
      separator_close = "";
      mode_normal = { fg = "#100E23"; bg = "#A1EFD3"; };
    };

    input = {
      border = { fg = "#585273"; };
      value = { fg = "#CBE3E7"; };
    };
  };

  programs.fzf.colors = {
    "bg+" = "#1E1C31";
    "fg" = "#8A889D";
    "fg+" = "#CBE3E7";
    "prompt" = "#A1EFD3";
    "header" = "#78a8ff";
    "pointer" = "#D4BFFF";
    "hl" = "#FFE6B3";
    "hl+" = "#FFE6B3";
    "spinner" = "#D4BFFF";
    "info" = "#91ddff";
    "border" = "#3E3859";
  };

  programs.skim = {
    defaultOptions = [ "--reverse" "--ansi" "--color=bg+:#1E1C31,border:#3E3859,fg:#8A889D,fg+:#CBE3E7,header:#78a8ff,hl:#FFE6B3,hl+:#FFE6B3,info:#91ddff,pointer:#D4BFFF,prompt:#A1EFD3,spinner:#D4BFFF" ];
  };

  programs.bat = {
    config.theme = "embark";
    themes.embark = {
      src = pkgs.fetchFromGitHub {
        owner = "embark-theme";
        repo = "bat";
        rev = "fae7e23";
        sha256 = "sha256-7xKdf5IRwRQo7nVc9hXb+ziULBtwhAn3pbOy4FiRbiQ=";
      };
      file = "Embark.tmTheme";
    };
  };

  programs.btop.settings.color_theme = "embark";

  xdg.configFile."btop/themes/embark.theme".source = pkgs.fetchFromGitHub
    {
      owner = "embark-theme";
      repo = "bashtop";
      rev = "master";
      sha256 = "sha256-HHoCVdCH4jCIK0JzoYagURcU722sBARtFkNeGPXuCNM=";
    } + "/embark.theme";

  programs.starship.settings = {
    format = "$character$jobs$directory$git_branch$git_status ";
    character = {
      format = "$symbol";
      error_symbol = "[  ](bold fg:red bg:#19172C)";
      success_symbol = "[  ](bold fg:green bg:#19172C)";
      vimcmd_symbol = "[  ](bold fg:purple bg:#19172C)";
    };

    directory = {
      format = "[   $path ](bg:#2D2B40 fg:bright-white)[](fg:#2D2B40)";
    };

    git_branch = {
      format = "[  $branch ](fg:bright-white)";
    };

    git_status = {
      style = "bold purple";
    };

    jobs = {
      symbol = " 󰠜 ";
      style = "bright-white";
    };

    status = {
      format = "[ $symbol$status ](fg:bright-white bg:#2D2B40)";
      disabled = false;
      symbol = " ";
    };

    hostname = {
      ssh_only = false;
      format = "[ $hostname ](italic fg:bright-white bg:#19172C)";
    };
  };

  programs.git.delta = {
    options = {
      light = false;
      decorations = {
        syntax-theme = "embark";
        minus-style = "syntax #741827";
        minus-emph-style = "syntax #a8113c";
        line-numbers-minus-style = "#F38BA8";
        line-numbers-plus-style = "#94E2D5";
        plus-style = "syntax #154e45";
        plus-emph-style = "syntax bold #146675";
      };
      features = "decorations";
    };
  };
}
