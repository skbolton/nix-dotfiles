{ pkgs, ... }:

{
  imports = [
    ../capabilities/themes/inspired.theme.nix
    ../capabilities/shell.nix
    ../capabilities/editor
    ../capabilities/tmux
    ../capabilities/lang/elixir.nix
    ../capabilities/lang/nix.nix
    ../capabilities/lang/node.nix
  ];

  home.sessionVariables = {
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
  };

  fonts.fontconfig.enable = true;

  delta = {
    gpg = {
      enable = true;
      autostart = false;
    };
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
