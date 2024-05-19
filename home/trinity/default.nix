{ pkgs, ... }:

{
  imports = [
    ../capabilities/themes/embark.theme.nix
    ./rgb.nix
    ../../modules/home-manager/monitors.nix
    ../../modules/home-manager/keyboard.nix
    ../capabilities/git
    ../capabilities/gpg.nix
    ../capabilities/shell.nix
    ../capabilities/kitty
    ../capabilities/passwords.nix
    ../capabilities/editor
    ../capabilities/tmux
    ../capabilities/desktop
    ./pam.nix
    ../capabilities/notes
    ../capabilities/taskwarrior
    ../capabilities/networking
    ../capabilities/lang/elixir.nix
    ../capabilities/lang/nix.nix
    ../capabilities/habits.nix
    ../capabilities/timetracking.nix
  ];

  home.sessionVariables = {
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
  };

  fonts.fontconfig.enable = true;

  services.gpg-agent = {
    enable = true;
    verbose = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    enableZshIntegration = true;
    pinentryFlavor = "gnome3";
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    enableScDaemon = true;
    grabKeyboardAndMouse = false;
    sshKeys = [
      "B189B794F1B984F63BAFA6785F3B2EE2F3458934"
    ];
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      openssh_win32 = {
        hostname = "LT-STEVEB-HQ";
        user = "adminarsenal/stephen.bolton";
      };

      weasel = {
        proxyJump = "openssh_win32";
        hostname = "localhost";
        user = "orlando";
        port = 2242;
        remoteForwards = [
          {
            # host is the local client it this situation
            host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
            # bind is the remote
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
          }
          {
            host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
          }
        ];
      };
    };
  };

  home = {
    username = "orlando";
    homeDirectory = "/home/orlando";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = with pkgs; [
      mpv
      docker-compose
      (pkgs.makeDesktopItem {
        name = "Kitty - Weasel";
        desktopName = "weasel";
        icon = ../capabilities/kitty/kitty-light.png;
        exec = "kitty --config /home/orlando/.config/kitty/kitty-light.conf";
        terminal = false;
      })
    ];
  };

  monitors = [
    {
      name = "DP-2";
      width = 2560;
      height = 2880;
      scale = "1.25";
      workspaces = [ "7" "8" "9" ];
    }
    {
      name = "DP-5";
      width = 3840;
      height = 2160;
      x = 2048;
      y = 300;
      scale = "1.066667,bitdepth,10";
      workspaces = [ "1" "3" "5" ];
    }
    {
      name = "DP-1";
      width = 2560;
      height = 2880;
      scale = "1.25";
      x = 5648;
      workspaces = [ "2" "4" "6" ];
    }
  ];

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

