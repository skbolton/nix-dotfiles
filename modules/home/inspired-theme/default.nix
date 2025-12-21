{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.inspired-theme;
in
{
  options.delta.inspired-theme = with types; {
    enable = mkEnableOption "inspired theme";
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
      include themes/inspired-github.conf
    '';

    programs.neovim.plugins = [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "inspired-github";
          src = pkgs.fetchFromGitHub {
            owner = "skbolton";
            repo = "inspired-github.vim";
            rev = "108ceda";
            sha256 = "sha256-hLqQWy+S4QHOx7z7+yAxLHTVoyuwUZXThxIJh2gS07M=";
          };
        };
      }
    ];

    xdg.configFile."nvim/plugin/inspired.lua".text = ''
      vim.o.background = 'light'
      vim.cmd("colorscheme inspired-github")
      vim.cmd("hi! Visual guibg=#F4F4F4")
      vim.cmd("hi! link CursorLineNr Keyword")
      vim.cmd("hi! link @markup.link.label Keyword")
      vim.api.nvim_set_hl(0, "@markup.strong", { bold = true })
      vim.api.nvim_set_hl(0, "@markup.heading", { bold = true, sp = "#CA1243", underline = true })
      vim.api.nvim_set_hl(0, "Todo", { bold = true, link = "Function"})
      vim.api.nvim_set_hl(0, "@text.todo.unchecked", { bold = true, link = "Function"})
      vim.api.nvim_set_hl(0, "@text.todo.checked", { link = "Comment"})
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "#DDFFDD"})
      vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#DDFFDD"})
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#FFDDDD"})
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#F7F7F7"})
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#ebebeb" })
      vim.api.nvim_set_hl(0, "CurSearch", { link = "Search" })
      vim.api.nvim_set_hl(0, "@neorg.tags.ranged_verbatim.code_block", { link = "Visual"})
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#F4F4F4"})
    '';

    xdg.configFile."nvim/plugin/statusline.lua".source = ./galaxy-line-inspired.lua;
    xdg.configFile."tmux/statusline.tmux".source = ./inspired.tmux;
    programs.starship.settings = {
      format = "$character$jobs$directory$git_branch$git_status ";
      character = {
        format = "$symbol";
        error_symbol = "[  ](bold fg:#CA1243 bg:#F4F4F4)";
        success_symbol = "[  ](bold fg:#795DA3 bg:#F4F4F4)";
        vimcmd_symbol = "[  ](bold fg:#0086B3 bg:#F4F4F4)";
      };

      directory = {
        format = "[   $path ](fg:#000000 bg:#E0E0E0)[](fg:#E0E0E0)";
      };

      git_branch = {
        format = "[  $branch ](fg:#A71D5D)";
      };

      git_status = {
        style = "bold #795DA3";
      };

      jobs = {
        symbol = "[ 󰠜 ](bg:#E0E0E0 fg:#000000)";
      };

      status = {
        format = "[ $symbol$status ](fg:#000 bg:#CCC)";
        disabled = false;
        symbol = " ";
      };
    };

    programs.bat.config.theme = "GitHub";

    programs.fzf.colors = {
      "bg+" = "#FFFFFF";
      "fg" = "-1";
      "fg+" = "-1";
      "prompt" = "#A71D5D";
      "header" = "#0086B3";
      "pointer" = "#D4BFFF";
      "hl" = "#A71D5D";
      "hl+" = "#A71D5D";
      "spinner" = "#795DA3";
      "info" = "#0086B3";
      "border" = "#969896";
    };

    programs.delta = {
      options = {
        light = true;
        decorations = {
          syntax-theme = "GitHub";
        };
        features = "decorations";
      };
    };


    programs.btop.settings.color_theme = "flat-remix-light";


    delta.ai.aichat_theme = "light";
    xdg.configFile."aichat/light.tmTheme".source = ./github-light.conf;

  };
}

