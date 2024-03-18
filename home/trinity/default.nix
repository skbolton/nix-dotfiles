{ inputs, pkgs, ... }:

{
  imports = [
    ../capabilities/themes/inspired.theme.nix
    ./rgb.nix
    ../../modules/home-manager/monitors.nix
    ../../modules/home-manager/keyboard.nix
    inputs.hyprland.homeManagerModules.default
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

  fonts.fontconfig.enable = true;

  services.gpg-agent = {
    enable = true;
    verbose = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    enableZshIntegration = true;
    pinentryPackage = pkgs.pinentry-gnome3;
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
        localForwards = [
          {
            # bind is the local 
            bind.port = 4000;
            # host is the remote
            host.address = "localhost";
            host.port = 4000;
          }
          {
            bind.port = 4001;
            host.address = "localhost";
            host.port = 4001;
          }
          {
            bind.port = 54321;
            host.address = "localhost";
            host.port = 54321;
          }
          {
            bind.port = 3333;
            host.address = "localhost";
            host.port = 3333;
          }
          {
            bind.port = 9090;
            host.address = "localhost";
            host.port = 9090;
          }
        ];
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

      arch_wsl = {
        proxyJump = "openssh_win32";
        hostname = "localhost";
        user = "orlando";
        port = 2222;
        localForwards = [
          {
            # bind is the local 
            bind.port = 4000;
            # host is the remote
            host.address = "localhost";
            host.port = 4000;
          }
          {
            bind.port = 54321;
            host.address = "localhost";
            host.port = 54321;
          }
        ];
        remoteForwards = [
          {
            # host is the local client it this situation
            host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
            # bind is the remote
            bind.address = "/run/user/1000/gnupg/d.7scgtn5j3mmef4u1zfkxpb9z/S.gpg-agent";
          }
          {
            host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            bind.address = "/run/user/1000/gnupg/d.7scgtn5j3mmef4u1zfkxpb9z/S.gpg-agent.ssh";
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
    ];
  };

  monitors = [
    {
      name = "DP-2";
      width = 2560;
      height = 2880;
      scale = "1.25";
      workspaces = [ "2" "4" ];
    }
    {
      name = "DP-5";
      width = 3840;
      height = 2160;
      x = 2048;
      y = 300;
      scale = "1.066667,bitdepth,10";
      workspaces = [ "1" "3" ];
    }
    {
      name = "DP-1";
      width = 2560;
      height = 2880;
      scale = "1.25";
      x = 5648;
      workspaces = [ "2" "4" ];
    }
  ];

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

