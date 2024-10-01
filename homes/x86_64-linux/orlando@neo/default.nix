{ pkgs, ... }:

{
  imports = [
    ../capabilities/themes/embark.theme.nix
    ../capabilities/git
    ../capabilities/shell.nix
    ../capabilities/kitty
    ../capabilities/finances.nix
    ../capabilities/editor
    ../capabilities/tmux
    ../capabilities/desktop
    ./pam.nix
    ../capabilities/notes
    ../capabilities/tasks
    ../capabilities/lang/elixir.nix
    ../capabilities/lang/nix.nix
    ../capabilities/habits.nix
    ../capabilities/timetracking.nix
  ];

  fonts.fontconfig.enable = true;

  delta = {
    gpg.enable = true;
    passwords.enable = true;
    desktop.wayland.hyprland = {
      enable = true;
      autostart = [ ];
    };
    desktop.wayland.waybar.enable = true;
    desktop.dunst.enable = true;
    desktop.nm-applet.enable = true;
    synology.enable = true;
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      openssh_win32 = {
        hostname = "172.16.90.200";
        user = "adminarsenal/stephen.bolton";
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

  monitors = [
    {
      name = "eDP-1";
      width = 2560;
      height = 1600;
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
    ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

