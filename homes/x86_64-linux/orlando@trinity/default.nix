{ pkgs, ... }:

{
  imports = [
    ./rgb.nix
    ./pam.nix
  ];

  fonts.fontconfig.enable = true;
  xdg.autostart.enable = true;

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
      enable = true;
      timesheets = "$HOME/Documents/new-journals/tracking/time";
    };
    habits.enable = true;
    neovim.enable = true;
    theme = {
      enable = true;
      palette = "embark";
    };
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
      enable = true;
      autostart = [ ];
    };
    desktop.wayland.river.enable = true;
    desktop.wayland.waybar.enable = true;
    desktop.wayland.waybar.target = "hyprland-session.target";
    desktop.dunst.enable = true;
    desktop.nm-applet.enable = true;
    desktop.ui_applications.enable = true;
    synology.enable = true;
    cloud.gcloud.enable = true;
  };

  programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch";

  programs.man.generateCaches = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks.niobe = {
      hostname = "niobe.home.arpa";
      user = "s.bolton";
      sendEnv = [ "LANG LC_*" ];
      remoteForwards = [
        {
          # host is the local client in this situation
          host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
          # bind is the remote
          bind.address = "/Users/s.bolton/.gnupg/S.gpg-agent";
        }
        {
          host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
          bind.address = "/Users/s.bolton/.gnupg/S.gpg-agent.ssh";
        }
      ];

    };
    matchBlocks.framework = {
      hostname = "framework.zionlab.local";
      user = "orlando";
    };
  };

  services.syncthing = {
    enable = true;
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
      delta.quantified-self
      delta.niobe
    ];
  };

  monitors = [
    # {
    #   name = "DP-1";
    #   width = 2560;
    #   x = 3200;
    #   y = 0;
    #   refreshRate = 60;
    #   height = 2880;
    #   scale = "1.6";
    #   workspaces = [ "2" "4" "6" ];
    #   enabled = true;
    # }
    # {
    #   name = "DP-5";
    #   width = 3840;
    #   x = 0;
    #   y = 0;
    #   refreshRate = 240;
    #   height = 2160;
    #   scale = "1";
    #   workspaces = [ "1" "3" "5" ];
    #   enabled = true;
    # }
  ];

  keyboard = {
    variant = "colemak";
    options = "lv3:ralt_alt";
  };

  # TODO: Find a way to automate this in themes
  # switching constructs theme should update this
  xdg.configFile."kitty/ssh.conf".text = ''
    hostname nixos@construct.home.arpa
    color_scheme ${../../../modules/home/dev-null-theme/kitty-dev-null.conf}
  '';

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

