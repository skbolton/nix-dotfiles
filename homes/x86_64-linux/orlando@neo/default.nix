{ pkgs, ... }:

{
  imports = [
    ../capabilities/themes/embark.theme.nix
    ../capabilities/kitty
    ../capabilities/desktop
    ./pam.nix
    ../capabilities/notes
  ];

  fonts.fontconfig.enable = true;

  delta = {
    gpg.enable = true;
    zsh.enable = true;
    cli_apps.enable = true;
    tmux.enable = true;
    finance.enable = true;
    passwords.enable = true;
    tasks.enable = true;
    timetracking.enable = true;
    neovim.enable = true;
    lang = {
      lua.enable = true;
      nix.enable = true;
    };
    desktop.wayland.hyprland = {
      enable = true;
      autostart = [ ];
    };
    desktop.gtk.enable = true;
    desktop.wayland.waybar.enable = true;
    desktop.dunst.enable = true;
    desktop.nm-applet.enable = true;
    synology.enable = true;
  };

  programs.man.generateCaches = true;

  programs.ssh = {
    enable = true;
  };

  monitors = [
    {
      name = "eDP-1";
      width = 2880;
      height = 1800;
      scale = "1.25";
      refreshRate = 120;
      workspaces = [ "1" "2" "3" "4" "5" "6" ];
      wallpaper = "~/Media/Pictures/Wallpapers/wallhaven-3l1z6v.jpg";
    }
  ];

  keyboard = {
    variant = "colemak";
    options = "lv3:ralt_alt";
  };

  home = {
    username = "orlando";
    homeDirectory = "/home/orlando";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = with pkgs; [
      mpv
      docker-compose
      floorp
      delta.fman
    ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

