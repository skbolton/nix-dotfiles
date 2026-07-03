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

    home.packages = with pkgs; [ recursive maple-mono.Normal-TTF ];
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

    programs.kitty.settings = {
      font_family = mkForce "Lilex";
      bold_font = mkForce "Lilex Bold";
      bold_italic_font = mkForce "Maple Mono Normal Bold Italic";
      italic_font = mkForce "Maple Mono Normal Italic";
    };

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
      vim.api.nvim_set_hl(0, "@text.strong", { bold = true })
      vim.api.nvim_set_hl(0, "Visual", {bg = "#ebf0fc"})
      vim.api.nvim_set_hl(0, "CursorColumn", {link = "CursorLine"})
      vim.api.nvim_set_hl(0, "WinSeparator", {fg = "#E0E0E0"})
    '';

    xdg.configFile."nvim/plugin/statusline.lua".source = ./galaxy-line-inspired.lua;
    xdg.configFile."tmux/statusline.tmux".source = ./inspired.tmux;
    programs.starship.settings = {
      format = ''
        [](fg:#EAEAEA bg:#FFFFFF)$jobs$directory[](fg:#EAEAEA bg:#FFFFFF)$fill[$git_branch$git_status ](bg:#EAEAEA)[](fg:#EAEAEA bg:#FFFFFF)
        [  ├─](fg:#969896) $username$hostname$kubernetes$elixir
        [  └──](fg:#969896) $character 
      '';
      character = {
        format = "$symbol";
        error_symbol = "[ ](bold #CA1243)";
        success_symbol = "[ ](bold #795DA3)";
        vimcmd_symbol = "[ ](bold #0086B3)";
      };

      username = {
        show_always = true;
        format = "[$user](fg:#000000)";
      };

      fill = {
        symbol = "";
        style = "fg:#FFFFFF bg:#FFFFFF";
      };

      elixir = {
        symbol = " ";
        format = "[$symbol](fg:#795DA3)[$version \\($otp_version\\)](fg:#000000)";
      };

      directory = {
        format = "[   $path ](bg:#EAEAEA fg:#000000)";
        truncation_length = 5;
        truncate_to_repo = false;
      };

      kubernetes = {
        disabled = false;
        symbol = "󱃾 ";
        format = "[ $symbol](fg:#0086B3)[$context/$namespace ](fg:#000000)";
      };

      git_branch = {
        format = "[](fg:#EAEAEA bg:#FFFFFF)[  $branch ](bg:#EAEAEA fg:#000000)";
      };

      git_status = {
        format = "$ahead_behind$stashed$staged$modified$deleted$untracked";
        style = "#000000";
        ahead = "[ ](bg:#EAEAEA bold #0086B3)";
        behind = "[ ](bg:#EAEAEA bold #0086B3)";
        up_to_date = "[- ](bg:#EAEAEA bold #000000)";
        diverged = "[](bg:#EAEAEA bold #0086B3)";
        staged = "[](bg:#EAEAEA #0086B3)";
        untracked = "[](bg:#EAEAEA #969896)";
        modified = "[](bg:#EAEAEA #795DA3)";
        stashed = "[](bg:#EAEAEA #A71D5D)";
        deleted = "[](bg:#EAEAEA #CA1243)";
      };

      jobs = {
        symbol = " 󰠜 ";
        style = "#000000";
      };

      status = {
        format = "[ $symbol$status ](fg:#000000 bg:#EAEAEA)";
        disabled = false;
        symbol = " ";
      };

      hostname = {
        ssh_only = false;
        format = "[@$hostname](fg:#000000)";
      };
    };

    programs.bat.config.theme = "GitHub";

    programs.fzf.colors = {
      "bg+" = "#FFFFFF";
      "gutter" = "#FFFFFF";
      "fg" = "#444444";
      "fg+" = "#444444";
      "prompt" = "#A71D5D";
      "header" = "#0086B3";
      "pointer" = "#D4BFFF";
      "current-bg" = "#EEE6FF";
      "hl" = "#795DA3";
      "hl+" = "#795DA3";
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

