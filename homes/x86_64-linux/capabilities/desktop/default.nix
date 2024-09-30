{ pkgs, ... }:

{
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

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-gtk";
  };
}
