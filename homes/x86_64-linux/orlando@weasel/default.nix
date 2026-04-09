{ config, pkgs, ... }:

{
  delta = {
    sops.enable = false;
    gpg = {
      enable = true;
      pinentry = pkgs.pinentry-qt;
      enableExtraSocket = false;
    };
    zsh.enable = true;
    neovim.enable = true;
    cli_apps.enable = true;
    theme.enable = true;
    theme.palette = "evergloom";
    kitty.enable = true;
  };

  programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch --flake '${config.home.homeDirectory}/c/nix-dotfiles#weasel'";

  programs.man.generateCaches = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };

  home = {
    username = "orlando";
    homeDirectory = "/home/orlando";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
    packages = with pkgs; [
      mpv
    ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

