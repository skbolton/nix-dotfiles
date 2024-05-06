{ pkgs, ... }:

{
  imports = [
    ./hyprland
  ];

  home.packages = with pkgs; [
    slack
    zoom-us
    gnome.nautilus
    lxappearance
    arandr
    gnucash
    morgen
    mpv
    tidal-hifi
    font-manager
    foliate
    okular
    galculator
  ];

  programs.wofi.enable = true;

  services.cliphist.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # gtk-theme = "Catppuccin-Frappe-Standard-Blue-light";
      gtk-theme = "Catppuccin-Mocha-Standard-Blue-Dark";
      cursor-theme = "Bibata-Modern-Ice";
      icon-theme = "Fluent-teal-dark";
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
      name = "Fluent-teal-dark";
      package = pkgs.fluent-icon-theme.override { roundedIcons = true; allColorVariants = true; };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk3";
    style.name = "adwaita-gtk";
  };

  # home.sessionVariables.GTK_THEME = "Catppuccin-Frappe-Standard-Blue-light";
  home.sessionVariables.GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
}
