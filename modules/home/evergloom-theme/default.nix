{ inputs, lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.evergloom-theme;
in
{
  options.delta.evergloom-theme = with types; {
    enable = mkEnableOption "evergloom theme";
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
      include ${./kitty-evergloom.conf}
    '';

    programs.neovim = {
      plugins = [
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "embark-vim";
            src = inputs.evergloom-nvim;
          };
          optional = false;
          config = /* lua */ ''
            require 'evergloom'.setup {}

            vim.cmd("colorscheme evergloom")
          '';
          type = "lua";
        }
      ];
    };

    xdg.configFile."nvim/plugin/statusline.lua".source = ./galaxy-line-evergloom.lua;

    xdg.configFile."tmux/statusline.tmux".source = ./evergloom.tmux;

    programs.starship.settings = {
      format = ''
        [](fg:#122d42 bg:#011627)$jobs$directory[](fg:#122d42 bg:#011627)$fill[$git_branch$git_status ](bg:#122d42)[](fg:#122d42 bg:#011627)
        [  ├─](fg:#5f7e97) $username$hostname$kubernetes$elixir
        [  └──](fg:#5f7e97) $character 
      '';
      character = {
        format = "$symbol";
        error_symbol = "[ ](bold #ef5075)";
        success_symbol = "[ ](bold #80A4C2)";
        vimcmd_symbol = "[ ](bold #3CD6A8)";
      };

      username = {
        show_always = true;
        format = "[$user](fg:#80A4C2)";
      };

      fill = {
        symbol = "";
        style = "fg:#011627 bg:#011627";
      };

      elixir = {
        symbol = " ";
        format = "[$symbol](fg:#c792ea)[$version \\($otp_version\\)](fg:#80A4C2)";
      };

      directory = {
        format = "[   $path ](bg:#122d42 fg:#80A4C2)";
        truncation_length = 5;
        truncate_to_repo = false;
      };

      kubernetes = {
        disabled = false;
        symbol = "󱃾 ";
        format = "[ $symbol](fg:#82AAFF)[$context/$namespace ](fg:#80A4C2)";
      };

      git_branch = {
        format = "[](fg:#122d42 bg:#011627)[  $branch ](bg:#122d42 fg:#80A4C2)";
      };

      git_status = {
        format = "$ahead_behind$stashed$staged$modified$deleted$untracked";
        style = "#80A4C2";
        ahead = "[ ](bg:#122d42 bold #c5e478)";
        behind = "[ ](bg:#122d42 bold #c5e478)";
        up_to_date = "[- ](bg:#122d42 bold #80A4C2)";
        diverged = "[](bg:#122d42 bold #c5e478)";
        staged = "[](bg:#122d42 #3CD6A8)";
        untracked = "[](bg:#122d42 #80A4C2)";
        modified = "[](bg:#122d42 #c792ea)";
        stashed = "[](bg:#122d42 #ffeb95)";
        deleted = "[](bg:#122d42 #ef5075)";
      };

      jobs = {
        symbol = " 󰠜 ";
        style = "#80A4C2";
      };

      status = {
        format = "[ $symbol$status ](fg:#80A4C2 bg:#122d42)";
        disabled = false;
        symbol = " ";
      };

      hostname = {
        ssh_only = false;
        format = "[@$hostname](italic fg:#80A4C2)";
      };
    };

    programs.bat = {
      config.theme = "evergloom";
      themes.embark = {
        src = ./evergloom.tmTheme;
      };
    };

    programs.delta.options."syntax-theme" = "evergloom";

    programs.fzf.colors = {
      "bg+" = "#011627";
      "fg" = "#8b9bb4";
      "fg+" = "#d6deeb";
      "prompt" = "#7FDBCA";
      "header" = "#82AAFF";
      "pointer" = "#c792ea";
      "hl" = "#ECC48D";
      "hl+" = "#ECC48D";
      "spinner" = "#f78c6c";
      "info" = "#82AAFF";
      "border" = "#1E3A5F";
    };

    programs.btop.settings.color_theme = "night-owl";

    delta.ai.aichat_theme = "dark";
    xdg.configFile."aichat/dark.tmTheme".source = ./evergloom.tmTheme;
  };
}

