{ lib, config, inputs, pkgs, ... }:

with lib;
let
  cfg = config.delta.dev-null-theme;
in
{
  options.delta.dev-null-theme = with types; {
    enable = mkEnableOption "dev-null theme";
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
    stylix.targets.tmux.enable = false;
    stylix.targets.fzf.enable = false;

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

    delta.ai.aichat_theme = "dark";
    # xdg.configFile."aichat/dark.tmTheme".source = inputs.embark-bat-theme + "/Embark.tmTheme";

  };
}

