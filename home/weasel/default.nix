{ pkgs, ... }:

{
  imports = [
    ../capabilities/themes/inspired.theme.nix
    ../capabilities/git
    ../capabilities/shell.nix
    ../capabilities/editor
    ../capabilities/tmux
    ../capabilities/kitty
    ../capabilities/lang/elixir.nix
    ../capabilities/lang/nix.nix
  ];

  home.sessionVariables = {
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
  };

  fonts.fontconfig.enable = true;

  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = "/etc/nixos/my-key.asc";
        trust = 5;
      }
    ];
    settings = {
      no-autostart = true;
      throw-keyids = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  home = {
    username = "orlando";
    homeDirectory = "/home/orlando";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = with pkgs; [
      docker-compose
    ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
