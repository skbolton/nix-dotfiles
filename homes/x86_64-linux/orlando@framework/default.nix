{ pkgs, ... }:

{
  imports = [
    ./pam.nix
  ];

  fonts.fontconfig.enable = true;

  delta = {
    ai.enable = true;
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
      timesheets = "~/Documents/Notes/tracking/time";
    };
    habits.enable = true;
    neovim.enable = true;
    theme.enable = true;
    kitty.enable = true;
    calendar.enable = true;
    lang = {
      elixir.enable = true;
      lua.enable = true;
      nix.enable = true;
    };
    notes.enable = true;
    desktop.wayland.hyprland = {
      enable = true;
      autostart = [ ];
    };
    desktop.wayland.waybar.enable = true;
    desktop.wayland.waybar.target = "hyprland-session.target";
    desktop.dunst.enable = true;
    desktop.nm-applet.enable = true;
    desktop.ui_applications.enable = true;
    synology.enable = true;
  };

  programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch";

  programs.man.generateCaches = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };

  monitors = [
    {
      name = "eDP-1";
      width = 2880;
      height = 1920;
      scale = "1.666667, vrr, 1";
      refreshRate = 60;
      workspaces = [ "1" "2" "3" "4" "5" "6" ];
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
      firefox
      delta.fman
      delta.zen-fan-control
      delta.next-m
      delta.next-q
    ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

