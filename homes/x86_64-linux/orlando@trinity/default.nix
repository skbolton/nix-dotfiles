{ pkgs, ... }:

{
  imports = [
    ../capabilities/themes/embark.theme.nix
    ./rgb.nix
    ../capabilities/git
    ../capabilities/shell.nix
    ../capabilities/kitty
    ../capabilities/editor
    ../capabilities/tmux
    ../capabilities/desktop
    ../capabilities/finances.nix
    ./pam.nix
    ../capabilities/notes
    ../capabilities/tasks
    ../capabilities/networking
    ../capabilities/lang/elixir.nix
    ../capabilities/lang/nix.nix
    ../capabilities/lang/node.nix
    ../capabilities/lang/lua.nix
    ../capabilities/habits.nix
    ../capabilities/timetracking.nix
  ];

  home.sessionVariables = {
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
  };

  fonts.fontconfig.enable = true;

  delta = {
    gpg.enable = true;
    passwords.enable = true;
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
      floorp
      pkgs.delta.weasel
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
      name = "DP-3";
      width = 2560;
      height = 2880;
      scale = "1";
      x = 2560;
      workspaces = [ "2" "4" "6" ];
      wallpaper = "~/Media/Pictures/Wallpapers/GHOSTEYESred.jpg";
    }
    {
      name = "DP-2";
      width = 3840;
      x = 5120;
      y = 0;
      refreshRate = 240;
      height = 2160;
      scale = "1";
      workspaces = [ "1" "3" "5" ];
      wallpaper = "~/Media/Pictures/Wallpapers/wallhaven-p91ve3.jpg";
    }
  ];

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
