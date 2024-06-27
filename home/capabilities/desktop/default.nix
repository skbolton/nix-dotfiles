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
    wtype
    wofi-emoji
  ];

  programs.wofi.enable = true;

  services.cliphist.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Tokyonight-Storm-BL";
      cursor-theme = "Bibata-Modern-Ice";
      icon-theme = "Fluent-teal-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Storm-BL";
      package = pkgs.tokyonight-gtk-theme;
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
    platformTheme.name = "gtk3";
    style.name = "adwaita-gtk";
  };

  home.sessionVariables.GTK_THEME = "Tokyonight-Storm-BL";
}
