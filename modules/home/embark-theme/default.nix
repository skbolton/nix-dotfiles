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
    # need to make a custom theme as the stylix form misses on some marks
    # will just rock system in the meantime
    stylix.targets.opencode.enable = false;

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
      format = ''
        $jobs$directory[](fg:#2D2B40 bg:#19172C)$fill[$git_branch$git_status ](bg:#2D2B40)
        [  ├─](fg:#585273) $username$hostname$kubernetes$elixir
        [  └──](fg:#585273) $character 
      '';
      character = {
        format = "$symbol";
        error_symbol = "[ ](bold red)";
        success_symbol = "[ ](bold bright-white)";
        vimcmd_symbol = "[ ](bold green)";
      };

      username = {
        show_always = true;
        format = "[$user](fg:bright-white)";
      };

      fill = {
        symbol = "";
        style = "fg:#19172C bg:#19172C";
      };

      elixir = {
        symbol = " ";
        format = "[$symbol](fg:purple)[$version \\($otp_version\\)](fg:bright-white)";
      };

      directory = {
        format = "[   $path ](bg:#2D2B40 fg:bright-white)";
        truncation_length = 5;
        truncate_to_repo = false;
      };

      kubernetes = {
        disabled = false;
        symbol = "󱃾 ";
        format = "[ $symbol](fg:blue)[$context/$namespace ](fg:bright-white)";
      };

      git_branch = {
        format = "[](fg:#2D2B40 bg:#19172C)[  $branch ](bg:#2D2B40 fg:bright-white)";
      };

      git_status = {
        format = "$ahead_behind$stashed$staged$modified$deleted$untracked";
        style = "bright-white";
        ahead = "[ ](bg:#2D2B40 bold green)";
        behind = "[ ](bg:#2D2B40 bold green)";
        up_to_date = "[- ](bg:#2D2B40 bold bright-white)";
        diverged = "[](bg:#2D2B40 bold green)";
        staged = "[](bg:#2D2B40 green)";
        untracked = "[](bg:#2D2B40 white)";
        modified = "[](bg:#2D2B40 purple)";
        stashed = "[](bg:#2D2B40 yellow)";
        deleted = "[](bg:#2D2B40 red)";
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
        format = "[@$hostname](italic fg:bright-white)";
      };
    };

    programs.bat = {
      config.theme = "embark";
      themes.embark = {
        src = inputs.embark-bat-theme;
        file = "Embark.tmTheme";
      };
    };

    programs.delta.options."syntax-theme" = "embark";

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

