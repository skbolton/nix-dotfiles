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
        name = "Colloid-Dark";
        package = pkgs.colloid-gtk-theme.override {
          themeVariants = [ "default" "purple" "teal" "grey" "green" ];
          tweaks = [ "black" "rimless" "normal" ];
        };
      };

      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };

      iconTheme = {
        name = "Colloid-dark";
        package = pkgs.colloid-icon-theme.override {
          colorVariants = [ "default" "purple" "teal" "grey" "green" "pink" ];
        };
      };
    };
  };
}
