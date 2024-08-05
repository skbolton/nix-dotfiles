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
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Purple-Dark-Compact";
      package = pkgs.orchis-theme.override {
        tweaks = [ "black" "compact" ];
      };
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    iconTheme = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-gtk";
  };
}
