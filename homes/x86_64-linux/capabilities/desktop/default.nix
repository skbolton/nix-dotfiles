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

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-gtk";
  };
}
