{ pkgs, ... }:

{
  imports = [
    ./rgb.nix
    ./pam.nix
  ];

  fonts.fontconfig.enable = true;

  delta = {
    sops.enable = true;
    gpg.enable = true;
    zsh.enable = true;
    cli_apps.enable = true;
    tmux.enable = true;
    finance.enable = true;
    passwords.enable = true;
    tasks.enable = true;
    timetracking.enable = true;
    habits.enable = true;
    neovim.enable = true;
    terminal_theme.embark.enable = true;
    calendar.enable = true;
    kitty.enable = true;
    lang = {
      elixir.enable = true;
      nodejs.enable = true;
      lua.enable = true;
      nix.enable = true;
    };
    notes.enable = true;
    desktop.wayland.hyprland = {
      enable = true;
      autostart = [
        # "remind -z -k':notify-send -u critical \"Reminder!\" %s' ~/00-09-System/02-Logs/02.10-Journal/agenda.rem"
        "[workspace 7 silent] kitty --title='kitty-journal' --hold smug start delta -a"
      ];
    };
    desktop.wayland.waybar.enable = true;
    desktop.wayland.waybar.target = "hyprland-session.target";
    desktop.dunst.enable = true;
    desktop.nm-applet.enable = true;
    desktop.gtk.enable = true;
    desktop.qt.enable = true;
    desktop.ui_applications.enable = true;
    synology.enable = true;
    cloud.gcloud.enable = true;
  };

  programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch";

  programs.man.generateCaches = true;

  programs.ssh = {
    enable = true;
  };

  home = {
    username = "orlando";
    homeDirectory = "/home/orlando";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = with pkgs; [
      mpv
      docker-compose
      firefox
      pkgs.delta.fman
      handbrake
    ];
  };

  monitors = [
    {
      name = "DP-1";
      width = 2560;
      height = 2880;
      scale = "1";
      workspaces = [ "7" "8" "9" ];
      wallpaper = "~/Media/Pictures/Wallpapers/KENSHI.jpg";
    }
    {
      name = "DP-5";
      width = 3840;
      x = 2560;
      y = 0;
      refreshRate = 240;
      height = 2160;
      scale = "1";
      workspaces = [ "1" "3" "5" ];
      wallpaper = "~/Media/Pictures/Wallpapers/wallhaven-p91ve3.jpg";
    }
  ];


  keyboard = {
    variant = "colemak";
    options = "lv3:ralt_alt";
  };


  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

