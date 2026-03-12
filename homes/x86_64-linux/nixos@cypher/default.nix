{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  delta = {
    zsh.enable = true;
    cli_apps.enable = true;
    tmux.enable = true;
    neovim.enable = true;
    theme = {
      enable = true;
      palette = "dev-null";
    };
    kitty.enable = true;
  };

  programs.man.generateCaches = true;

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = [ ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

