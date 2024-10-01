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
        name = "Colloid-Teal-Dark";
        package = pkgs.colloid-gtk-theme.override {
          themeVariants = [ "purple" "teal" "grey" "green" ];
          tweaks = [ "black" ];
        };
      };

      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };

      iconTheme = {
        name = "Colloid-dracula-dark";
        package = pkgs.colloid-icon-theme.override {
          colorVariants = [ "default" "purple" "teal" "grey" "green" "pink" ];
          schemeVariants = [ "dracula" ];
        };
      };
    };
  };
}
