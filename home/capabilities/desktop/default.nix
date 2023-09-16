{ pkgs, ... }:

{
  imports = [
    ./hyprland
  ];

  home.packages = with pkgs; [ 
    slack
    webcord
    zoom-us
    xfce.thunar
    xfce.thunar-archive-plugin
    gnome.nautilus
    lxappearance
    arandr
    gnucash
    morgen
    mpv
    tidal-hifi
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # color-scheme = "prefer-dark";
      gtk-theme = "Catppuccin-Frappe-Standard-Blue-light";
      cursor-theme = "Bibata-Modern-Ice";
      icon-theme = "Fluent-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      # name = "Catppuccin-Mocha-Standard-Blue-dark";
      name = "Catppuccin-Frappe-Standard-Blue-light";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard"; # compact
        tweaks = [];
        variant = "frappe";
      };
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    iconTheme = {
      name = "Fluent-dark";
      package = pkgs.fluent-icon-theme;
    };
  };

  home.sessionVariables.GTK_THEME = "Catppuccin-Frappe-Standard-Blue-light";
}
