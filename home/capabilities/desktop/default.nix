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
    font-manager
  ];

  programs.wofi.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # gtk-theme = "Catppuccin-Frappe-Standard-Blue-light";
      gtk-theme = "Catppuccin-Mocha-Standard-Blue-Dark";
      cursor-theme = "Bibata-Modern-Ice";
      icon-theme = "Fluent-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      # name = "Catppuccin-Frappe-Standard-Blue-light";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard"; # compact
        tweaks = [ ];
        variant = "mocha";
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

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-gtk";
  };

  # home.sessionVariables.GTK_THEME = "Catppuccin-Frappe-Standard-Blue-light";
  home.sessionVariables.GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
}
