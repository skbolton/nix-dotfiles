{ lib, config, inputs, pkgs, ... }:

with lib;
let
  cfg = config.delta.embark-theme;
in
{
  options.delta.embark-theme = with types; {
    enable = mkEnableOption "embark theme";
  };

  config = mkIf cfg.enable {
    gtk.enable = true;
    stylix.enable = true;

    stylix.cursor = {
      size = 16;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

    stylix.icons = {
      package = pkgs.fluent-icon-theme;
      dark = "Fluent-dark";
      light = "Fluent";
    };

    stylix.targets.neovim.enable = false;
    stylix.targets.bat.enable = false;
    stylix.targets.btop.enable = false;
    stylix.targets.fzf.enable = false;
    stylix.targets.tmux.enable = false;
    stylix.targets.starship.enable = false;

    programs.kitty.extraConfig = ''
      include ${./kitty-embark.conf}
    '';

    programs.neovim = {
      plugins = [
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "embark-vim";
            src = inputs.embark-vim;
          };
          optional = true;
        }
      ];
      extraLuaConfig = /* lua */ ''
        vim.cmd("colorscheme embark")
      '';
    };

    xdg.configFile."nvim/plugin/statusline.lua".source = ./galaxy-line-embark.lua;

    xdg.configFile."tmux/statusline.tmux".source = ./embark.tmux;

    programs.starship.settings = {
      format = "$character$hostname$jobs$directory$git_branch$git_status ";
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
        ssh_only = true;
        format = "[ $hostname ](italic fg:bright-white bg:#19172C)";
      };
    };

    programs.bat = {
      config.theme = "embark";
      themes.embark = {
        src = inputs.embark-bat-theme;
        file = "Embark.tmTheme";
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

    programs.btop.settings.color_theme = "embark";

    xdg.configFile."btop/themes/embark.theme".source = pkgs.fetchFromGitHub
      {
        owner = "embark-theme";
        repo = "bashtop";
        rev = "master";
        sha256 = "sha256-HHoCVdCH4jCIK0JzoYagURcU722sBARtFkNeGPXuCNM=";
      } + "/embark.theme";

    delta.ai.aichat_theme = "dark";
    xdg.configFile."aichat/dark.tmTheme".source = inputs.embark-bat-theme + "/Embark.tmTheme";

  };
}

