{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  delta = {
    gpg = {
      enable = true;
      autostart = false;
      enableExtraSocket = false;
    };
    zsh.enable = true;
    cli_apps.enable = true;
    tmux.enable = true;
    neovim.enable = true;
    theme = {
      enable = true;
      palette = "dev-null";
    };
    kitty.enable = true;
    lang = {
      elixir.enable = true;
      nodejs.enable = true;
      lua.enable = true;
      nix.enable = true;
    };
  };

  programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch";

  programs.man.generateCaches = true;

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = with pkgs; [
      docker-compose
      firefox
    ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

