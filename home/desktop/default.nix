{ pkgs, ... }:

{
  imports = [
    ./hyprland
  ];

  home.packages = with pkgs; [ 
    synology-drive-client
    logseq 
    obsidian
    slack
    discord
    zoom-us
    xfce.thunar
    xfce.thunar-archive-plugin
    gnome.nautilus
    lxappearance
    arandr
    gnucash
    morgen
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Catppuccin-Mocha-Standard-Blue-dark";
      cursor-theme = "Bibata-Modern-Ice";
      icon-theme = "Fluent-dark";
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

    iconTheme = {
      name = "Fluent-dark";
      package = pkgs.fluent-icon-theme;
    };
  };

  home.sessionVariables.GTK_THEME = "Catppuccin-Mocha-Standard-Blue-dark";
}
