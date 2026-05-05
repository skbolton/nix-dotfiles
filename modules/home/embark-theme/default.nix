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
        [](fg:#2D2B40 bg:#19172C)$jobs$directory[](fg:#2D2B40 bg:#19172C)$fill[$git_branch$git_status ](bg:#2D2B40)[](fg:#2D2B40 bg:#19172C)
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

    programs.opencode = {
      settings.theme = "embark";
      themes.embark = {
        defs = {
          space0 = "#100E23";
          space1 = "#1e1c31";
          space2 = "#2d2a4a";
          space3 = "#3E3859";
          space4 = "#585273";
          astral0 = "#8A889D";
          astral1 = "#cbe3e7";
          red = "#F48FB1";
          dark_red = "#F02E6E";
          green = "#A1EFD3";
          dark_green = "#7fe9c3";
          yellow = "#ffe6b3";
          dark_yellow = "#F2B482";
          blue = "#91ddff";
          dark_blue = "#78a8ff";
          purple = "#d4bfff";
          dark_purple = "#7676ff";
          cyan = "#ABF8F7";
          dark_cyan = "#63f2f1";
          diff_add = "#2D5059";
          diff_del = "#5E3859";
          diff_changed = "#38325A";
        };
        theme = {
          primary = "green";
          secondary = "purple";
          accent = "cyan";
          error = "red";
          warning = "yellow";
          success = "green";
          info = "blue";
          text = "astral1";
          textMuted = "astral0";
          background = "space0";
          backgroundPanel = "space1";
          backgroundElement = "space1";
          border = "cyan";
          borderActive = "space3";
          borderSubtle = "yellow";
          diffAdded = "green";
          diffRemoved = "red";
          diffContext = "space1";
          diffHunkHeader = "space1";
          diffHighlightAdded = "green";
          diffHighlightRemoved = "red";
          diffAddedBg = "diff_add";
          diffRemovedBg = "diff_del";
          diffContextBg = "diff_changed";
          diffLineNumber = "space1";
          diffAddedLineNumberBg = "space1";
          diffRemovedLineNumberBg = "space1";
          markdownText = "astral1";
          markdownHeading = "dark_blue";
          markdownLink = "purple";
          markdownLinkText = "cyan";
          markdownCode = "green";
          markdownBlockQuote = "space3";
          markdownEmph = "yellow";
          markdownStrong = "astral1";
          markdownHorizontalRule = "space3";
          markdownListItem = "cyan";
          markdownListEnumeration = "cyan";
          markdownImage = "purple";
          markdownImageText = "cyan";
          markdownCodeBlock = "astral1";
          syntaxComment = "space4";
          syntaxKeyword = "purple";
          syntaxFunction = "red";
          syntaxVariable = "cyan";
          syntaxString = "green";
          syntaxNumber = "dark_yellow";
          syntaxType = "purple";
          syntaxOperator = "dark_blue";
          syntaxPunctuation = "astral1";
        };
      };
    };
  };
}

