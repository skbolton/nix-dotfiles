{ pkgs, ... }:

{
  home.packages = with pkgs; [ 
    synology-drive-client
    logseq 
    slack
    discord
    zoom-us
    xfce.thunar
    xfce.thunar-archive-plugin
    gnome.nautilus
    lxappearance
    arandr
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Lavendar-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        size = "compact";
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
    };

    cursorTheme = {
      name = "Catppucin-Mocha-Lavender-Cursors";
      package = pkgs.catppuccin-cursors.mochaTeal;
    };
  };
}
