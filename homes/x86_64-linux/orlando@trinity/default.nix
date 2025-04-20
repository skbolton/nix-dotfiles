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
    timetracking = {
      enable = true;
      timesheets = "$HOME/00-09-System/03-Quantified/03.10-Timecards/$(date +%Y)";
    };
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
    notes = {
      enable = true;
      notebook_dir = "$HOME/Documents/Reference";
    };
    desktop.wayland.hyprland = {
      enable = false;
      autostart = [
        # "remind -z -k':notify-send -u critical \"Reminder!\" %s' ~/00-09-System/02-Logs/02.10-Journal/agenda.rem"
        "[workspace 7 silent] kitty --title='kitty-journal' --hold smug start delta -a"
      ];
    };
    desktop.wayland.river.enable = true;
    desktop.wayland.waybar.enable = true;
    desktop.wayland.waybar.target = "river-session.target";
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
    matchBlocks.niobe = {
      hostname = "niobe.zionlab.local";
      user = "s.bolton";
      sendEnv = [ "LANG LC_*" ];
    };
    matchBlocks.framework = {
      hostname = "framework.zionlab.local";
      user = "orlando";
    };
  };

  home = {
    username = "orlando";
    homeDirectory = "/home/orlando";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = with pkgs; [
      plexamp
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
      wallpaper = "~/Desktop/dc0l5thp6nre1.jpeg";
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
      wallpaper = "~/Desktop/3840x2400-v0-sfwqjybeaawd1.jpg";
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

