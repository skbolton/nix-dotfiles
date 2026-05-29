{ ... }:

{
  fonts.fontconfig.enable = true;

  delta = {
    theme = {
      enable = true;
      palette = "dev-null";
    };
    tasks.enable = true;
    tasks.sync = true;
    sops.enable = true;
    tmux.enable = true;
    neovim.enable = true;
  };

  programs.man.generateCaches = true;

  home = {
    username = "mira";
    homeDirectory = "/home/mira";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

