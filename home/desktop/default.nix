{ pkgs, ... }:

{
  imports = [
    ./hyprland.nix
  ];

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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Catppuccin-Mocha-Standard-Blue-dark";
      cursor-theme = "Bibata-Modern-Ice";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard"; # compact
        tweaks = [];
        variant = "mocha";
      };
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };

  home.sessionVariables.GTK_THEME = "Catppuccin-Mocha-Standard-Blue-dark";
}
