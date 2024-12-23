{ pkgs, ... }:

{
  imports = [
  ];

  fonts.fontconfig.enable = true;

  delta = {
    gpg.enable = true;
    zsh.enable = true;
    cli_apps.enable = true;
    tmux.enable = true;
    passwords.enable = true;
    tasks.enable = true;
    timetracking.enable = true;
    neovim.enable = true;
    terminal_theme.embark.enable = true;
    kitty.enable = true;
    lang = {
      lua.enable = true;
      nix.enable = true;
    };
  };

  programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch";

  programs.man.generateCaches = true;

  programs.ssh = {
    enable = true;
  };

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
    packages = with pkgs; [
      mpv
      docker-compose
      firefox
      delta.fman
    ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

