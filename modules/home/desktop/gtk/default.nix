{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.desktop.gtk;
in
{
  options.delta.desktop.gtk = with types; {
    enable = mkEnableOption "gtk";
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    gtk = {
      enable = true;
      theme = {
        # Accent-<Light|Dark>-Tweak
        name = "Colloid-Purple-Dark-Catppuccin";
        package = pkgs.colloid-gtk-theme.override {
          themeVariants = [ "all" ];
          tweaks = [ "catppuccin" "black" "rimless" "normal" ];
        };
      };

      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };

      iconTheme = {
        # <green|purple|...>-<light|dark>
        name = "Fluent-dark";
        package = pkgs.fluent-icon-theme;
      };
    };
  };
}
