{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.delta.dev-null-theme;
in
{
  options.delta.dev-null-theme = {
    enable = lib.mkEnableOption "dev-null theme";
  };

  config = lib.mkIf cfg.enable {
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
    stylix.targets.tmux.enable = false;
    stylix.targets.fzf.enable = false;
    stylix.targets.starship.enable = false;
    stylix.targets.opencode.enable = false;

    programs.kitty.extraConfig = ''
      include ${./kitty-dev-null.conf}
    '';

    programs.fzf.colors = {
      "bg+" = "#161616";
      "fg" = "#6F6F6F";
      "fg+" = "#C6C6C6";
      "prompt" = "#3DDBD9";
      "header" = "#78A9FF";
      "pointer" = "#D4BBFF";
      "hl" = "#08BDBA";
      "hl+" = "#08BDBA";
      "spinner" = "#D4BBFF";
      "info" = "#4589FF";
      "border" = "#252525";
    };

    programs.neovim = {
      plugins = [
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "dev-null-nvim";
            src = inputs.dev-null-theme;
          };
          config = /* lua */ ''
            vim.cmd("colorscheme dev-null")
          '';
          type = "lua";
          optional = false;
        }
      ];
    };

    xdg.configFile."nvim/plugin/statusline.lua".source = ./galaxy-line-dev-null.lua;

    xdg.configFile."tmux/statusline.tmux".source = ./dev-null.tmux;
    programs.starship.settings = {
      format = ''
        [](fg:#252525 bg:#161616)$jobs$directory[](fg:#252525 bg:#161616)$fill[$git_branch$git_status ](bg:#252525)[](fg:#252525 bg:#161616)
        [  ├─](fg:#484848) $username$hostname$kubernetes$elixir
        [  └──](fg:#484848) $character 
      '';
      character = {
        format = "$symbol";
        error_symbol = "[ ](bold #FF75B6)";
        success_symbol = "[ ](bold #C6C6C6)";
        vimcmd_symbol = "[ ](bold #9ef0f0)";
      };

      username = {
        show_always = true;
        format = "[$user](fg:#C6C6C6)";
      };

      fill = {
        symbol = "";
        style = "fg:#161616 bg:#161616";
      };

      elixir = {
        symbol = " ";
        format = "[$symbol](fg:#d4bbff)[$version \\($otp_version\\)](fg:#C6C6C6)";
      };

      directory = {
        format = "[   $path ](bg:#252525 fg:#C6C6C6)";
        truncation_length = 5;
        truncate_to_repo = false;
      };

      kubernetes = {
        disabled = false;
        symbol = "󱃾 ";
        format = "[ $symbol](fg:#82AAFF)[$context/$namespace ](fg:#C6C6C6)";
      };

      git_branch = {
        format = "[](fg:#252525 bg:#161616)[  $branch ](bg:#252525 fg:#C6C6C6)";
      };

      git_status = {
        format = "$ahead_behind$stashed$staged$modified$deleted$untracked";
        style = "#C6C6C6";
        ahead = "[ ](bg:#252525 bold #d5ff5e)";
        behind = "[ ](bg:#252525 bold #d5ff5e)";
        up_to_date = "[- ](bg:#252525 bold #C6C6C6)";
        diverged = "[](bg:#252525 bold #d5ff5e)";
        staged = "[](bg:#252525 #9ef0f0)";
        untracked = "[](bg:#252525 #C6C6C6)";
        modified = "[](bg:#252525 #d4bbff)";
        stashed = "[](bg:#252525 #d5ff5e)";
        deleted = "[](bg:#252525 #FF75B6)";
      };

      jobs = {
        symbol = " 󰠜 ";
        style = "#C6C6C6";
      };

      status = {
        format = "[ $symbol$status ](fg:#C6C6C6 bg:#252525)";
        disabled = false;
        symbol = " ";
      };

      hostname = {
        ssh_only = false;
        format = "[@$hostname](italic fg:#C6C6C6)";
      };
    };

    programs.opencode = {
      tui.theme = "dev-null";
      themes.dev-null = {
        defs = {
          bg = "#161616";
          surface = "#1B1B1B";
          surfaceAlt = "#252525";
          border = "#393939";
          borderActive = "#484848";
          fg = "#c6c6c6";
          muted = "#6f6f6f";
          # primary = "#3ddbd9";
          primary = "#9ef0f0";
          accent = "#a56eff";
          listing = "#d0e2ff";
          heading = "#d4bbff";
          link = "#78a9ff";
          interactive = "#be95ff";
          success = "#3ddbd9";
          warning = "#d5ff5e";
          error = "#ee5396";
          info = "#78a9ff";
          diffAdd = "#08bdba";
          diffAddBg = "#173634";
          diffDelete = "#ee5396";
          diffDeleteBg = "#2b1828";
          string = "#d9fbfb";
          variable = "#f4f4f4";
          property = "#a6c8ff";
          constant = "#78a9ff";
          operator = "#d0e2ff";
          object = "#a6c8ff";
        };
        theme = {
          primary = {
            dark = "primary";
          };
          secondary = {
            dark = "accent";
          };
          accent = {
            dark = "accent";
          };
          error = {
            dark = "error";
          };
          warning = {
            dark = "warning";
          };
          success = {
            dark = "success";
          };
          info = {
            dark = "info";
          };
          text = {
            dark = "fg";
          };
          textMuted = {
            dark = "muted";
          };
          background = {
            dark = "bg";
          };
          # backgroundPanel = { dark = "surface"; };
          # backgroundElement = { dark = "surfaceAlt"; };
          backgroundPanel = {
            dark = "surface";
          };
          backgroundElement = {
            dark = "surface";
          };
          border = {
            dark = "border";
          };
          borderActive = {
            dark = "borderActive";
          };
          borderSubtle = {
            dark = "border";
          };
          diffAdded = {
            dark = "success";
          };
          diffRemoved = {
            dark = "error";
          };
          diffContext = {
            dark = "surfaceAlt";
          };
          diffHunkHeader = {
            dark = "surfaceAlt";
          };
          diffHighlightAdded = {
            dark = "diffAdd";
          };
          diffHighlightRemoved = {
            dark = "diffDelete";
          };
          diffAddedBg = {
            dark = "diffAddBg";
          };
          diffRemovedBg = {
            dark = "diffDeleteBg";
          };
          diffContextBg = {
            dark = "surface";
          };
          diffLineNumber = {
            dark = "muted";
          };
          diffAddedLineNumberBg = {
            dark = "diffAddBg";
          };
          diffRemovedLineNumberBg = {
            dark = "diffDeleteBg";
          };
          markdownText = {
            dark = "fg";
          };
          markdownHeading = {
            dark = "heading";
          };
          markdownLink = {
            dark = "link";
          };
          markdownLinkText = {
            dark = "accent";
          };
          markdownCode = {
            dark = "string";
          };
          markdownBlockQuote = {
            dark = "muted";
          };
          markdownEmph = {
            dark = "accent";
          };
          markdownStrong = {
            dark = "heading";
          };
          markdownHorizontalRule = {
            dark = "muted";
          };
          markdownListItem = {
            dark = "fg";
          };
          markdownListEnumeration = {
            dark = "listing";
          };
          markdownImage = {
            dark = "listing";
          };
          markdownImageText = {
            dark = "link";
          };
          markdownCodeBlock = {
            dark = "fg";
          };
          syntaxComment = {
            dark = "muted";
          };
          syntaxKeyword = {
            dark = "accent";
          };
          syntaxFunction = {
            dark = "interactive";
          };
          syntaxVariable = {
            dark = "variable";
          };
          syntaxString = {
            dark = "string";
          };
          syntaxNumber = {
            dark = "constant";
          };
          syntaxType = {
            dark = "interactive";
          };
          syntaxOperator = {
            dark = "operator";
          };
          syntaxPunctuation = {
            dark = "operator";
          };
        };
      };
    };
  };
}
