{ pkgs, config, ... }:

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
    tasks.sync = true;
    timetracking = {
      enable = false;
      timesheets = "$HOME/Documents/Notes/tracking/time";
    };
    habits.enable = true;
    neovim.enable = true;
    theme.enable = true;
    kitty.enable = true;
    calendar.enable = true;
    rally = {
      enable = true;
      rallypoints = [ "$HOME" "$HOME/c" ];
    };
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

  programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch --flake '${config.home.homeDirectory}/c/nix-dotfiles#framework'";

  programs.man.generateCaches = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks.niobe = {
      hostname = "niobe.home.arpa";
      user = "s.bolton";
      sendEnv = [ "LANG LC_*" ];
      # remoteForwards = [
      #   {
      #     # host is the local client in this situation
      #     host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
      #     # bind is the remote
      #     bind.address = "/Users/s.bolton/.gnupg/S.gpg-agent";
      #   }
      #   {
      #     host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
      #     bind.address = "/Users/s.bolton/.gnupg/S.gpg-agent.ssh";
      #   }
      # ];
    };
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
      delta.zen-fan-control
      delta.next-m
      delta.next-q
    ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

